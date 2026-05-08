---
sidebar_position: 6
title: inventory
audience: Backend engineers, QA, PM
summary: Physical inventory counts (stocktakes) with mobile barcode scanning and reconciliation against system stock.
topics: [inventory, stocktake, scan, reconciliation, barcode]
---

# `inventory` module

Physical inventory counts (stocktakes), with mobile barcode scanning
and reconciliation against the system stock.

## Key features

| Feature | What it does | Owner role(s) |
|---------|--------------|---------------|
| Create inventory doc | Start a new stocktake; choose `inventory_type` | 1 / 2 / 9 |
| Scope by client / warehouse | Limit the doc to a specific outlet or warehouse | 1 / 9 |
| Mobile scanning | Operators scan barcodes one-by-one via api3 | 4 / warehouse staff |
| Photo evidence | Attach photos of damaged or short items | 4 |
| Reconciliation | Compute deltas vs current `Stock` | system |
| Adjustments | On approval, post deltas back to stock | 1 / 9 |
| History | Per-doc history of edits and approvals | system |

## Folder

```
protected/modules/inventory/
├── controllers/
│   ├── AddController.php
│   ├── EditController.php
│   ├── DeleteController.php
│   ├── ListController.php
│   ├── HistoryController.php
│   ├── PhotoController.php
│   ├── ScanController.php
│   └── StatusController.php
└── views/
```

## Workflow

1. Manager creates an inventory document (`AddController`).
2. Operators scan products in the warehouse via `ScanController`
   (mobile, api3).
3. System computes deltas vs current stock.
4. Manager approves; deltas post to `stock` as adjustments.

## Key feature flow — Stocktake

```mermaid
flowchart LR
  M(["Manager creates doc"]) --> SC["Operators scan"]
  SC --> CALC["Compute deltas vs Stock"]
  CALC --> REV{"Manager approves?"}
  REV -->|approve| POST(["Post adjustments"])
  REV -->|adjust| SC

  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000

  class M,SC,CALC action
  class REV approval
  class POST success
```

## Photos

`PhotoController` attaches per-row photo evidence (e.g. damaged
goods). Stored under `upload/inventory/<doc_id>/`.

## Permissions

| Action | Roles |
|--------|-------|
| Create | 1 / 2 / 9 |
| Scan (mobile) | 4 / warehouse staff |
| Approve | 1 / 2 / 9 |

## Workflows

### Entry points

| Trigger | Controller / Action / Job | Notes |
|---|---|---|
| Web (manager) | `AddController::actionIndex` | Create a single inventory item; validates `InventoryType` and optional `Client` |
| Web (manager, batch) | `AddController::actionBatch` | Bulk-create items from an imported list |
| Web (manager) | `EditController::actionInventory` | Edit item metadata (name, serial, type) |
| Web (manager) | `EditController::actionHistory` | Re-attach / re-assign item to a different client; closes old `InventoryHistory` row |
| Web (manager) | `StatusController::actionEdit` | Single-item status transition; guards allowed transitions via `InventoryService::CAN_CHANGE_STATUS_TO` |
| Web (manager, bulk) | `StatusController::actionBulkEdit` | Bulk status change across a set of item IDs |
| Web (manager) | `PhotoController::actionAdd` | Attach evidence photo to an item (max 3, max 5 MB) |
| Mobile (agent) | `api4/InventoryController::actionScanning` | Record a barcode/QR scan event for an item at a client site |
| Mobile (agent) | `api4/InventoryController::actionScanningPhoto` | Upload a scan-event photo (`InventoryCheckPhoto`) |
| Web (report) | `ScanController::actionList` | Pull the scan-event log (joins `inventory_check` + `inventory_history` + `inventory_check_photo`) |
| Web (report) | `HistoryController::actionData` | Pull full assignment history across all items |

### Domain entities

```mermaid
erDiagram
    Inventory {
        string INVENTORY_ID PK
        string INV_TYPE_ID FK
        string NAME
        string SERIAL_NUM
        string INV_NO
        string DATE_PRODUCTION
        string ACTIVE
        string XML_ID
    }
    InventoryType {
        string INV_TYPE_ID PK
        string NAME
    }
    InventoryHistory {
        string INVENTORY_HIST_ID PK
        string INVENTORY_ID FK
        string CLIENT_ID FK
        string STATUS
        string CONDITION
        string DATE_FROM
        string DATE_TO
        string ACTIVE
    }
    InventoryCheck {
        int ID PK
        string INVENTORY_ID FK
        string INVENTORY_HIST_ID FK
        string CLIENT_ID
        double LAT
        double LON
        string SCANNED_AT
    }
    InventoryCheckPhoto {
        int ID PK
        int INVENTORY_CHECK_ID FK
        string FILE_NAME
    }
    PhotoInventory {
        int ID PK
        string INV_ID FK
        string PHOTO
    }

    Inventory ||--o{ InventoryHistory : "has history rows"
    InventoryType ||--o{ Inventory : "classifies"
    Inventory ||--o{ InventoryCheck : "scanned as"
    InventoryHistory ||--o{ InventoryCheck : "active at scan time"
    InventoryCheck ||--o{ InventoryCheckPhoto : "has scan photos"
    Inventory ||--o{ PhotoInventory : "has item photos"
```

### Workflow 1.1 — Inventory item lifecycle (creation and status transitions)

A manager registers a physical asset via `AddController::actionIndex`, which atomically inserts an `Inventory` row and an initial `InventoryHistory` row. From that point the item moves through a controlled set of statuses. All transitions are validated against `InventoryService::CAN_CHANGE_STATUS_TO`; illegal jumps are rejected before any DB write.

```mermaid
stateDiagram-v2
    [*] --> Available : AddController insert inventory + history STATUS=1
    Available --> InUse : StatusController status=2 attach to client
    Available --> InRepair : StatusController status=3
    Available --> WrittenOff : StatusController status=4
    Available --> Deleted : StatusController status=5
    InUse --> Available : StatusController status=1 detach from client
    InUse --> InUse : StatusController status=2 reassign client
    InUse --> InRepair : StatusController status=3
    InUse --> Deleted : StatusController status=5
    InRepair --> Available : StatusController status=1
    InRepair --> InUse : StatusController status=2
    InRepair --> Deleted : StatusController status=5
    WrittenOff --> Available : StatusController status=1
    WrittenOff --> InRepair : StatusController status=3
    WrittenOff --> Deleted : StatusController status=5
    Deleted --> Available : StatusController status=1
    Deleted --> InUse : StatusController status=2
    Deleted --> InRepair : StatusController status=3
    Deleted --> WrittenOff : StatusController status=4
```

### Workflow 1.2 — Mobile scan event (agent scans QR/barcode at client site)

An agent in the field opens `api4/InventoryController::actionScanning`. The endpoint validates the item and client, resolves the current `InventoryHistory` row, saves an `InventoryCheck` record (with GPS coords), saves any attached photos as `InventoryCheckPhoto` rows, and — if the agent's config has `visiting.inventory_qr_report` enabled — marks the corresponding `Visit` as visited. The Web `ScanController::actionList` later joins `inventory_check`, `inventory_history`, and `inventory_check_photo` to produce the scan-event report.

```mermaid
sequenceDiagram
    participant Mobile
    participant api4
    participant DB

    Mobile->>api4: POST api4/inventory/scanning {inventory_id, client_id, scanned_at, latitude, longitude, photos[]}
    api4->>DB: SELECT inventory WHERE INVENTORY_ID=:id
    DB-->>api4: Inventory row (or 404)
    api4->>DB: SELECT client WHERE CLIENT_ID=:id
    DB-->>api4: Client row (or 404)
    api4->>DB: SELECT inventory_history WHERE INVENTORY_ID=:id AND active
    DB-->>api4: Current InventoryHistory row
    api4->>DB: INSERT inventory_check (INVENTORY_ID, CLIENT_ID, INVENTORY_HIST_ID, SCANNED_AT, LAT, LON)
    DB-->>api4: new check ID
    api4->>DB: INSERT inventory_check_photo per base64 image (INVENTORY_CHECK_ID, FILE_NAME)
    DB-->>api4: photo IDs
    api4->>DB: UPDATE visit SET VISITED=1, CHECK_IN_TIME, CHECK_OUT_TIME (only if agent config inventory_qr_report=true)
    DB-->>api4: ok
    api4-->>Mobile: {status:true, result:{id, photos[]}}
    Note over Mobile,DB: Web report: ScanController::actionList SELECT inventory_check JOIN inventory_history JOIN inventory_check_photo
```

### Cross-module touchpoints

- Reads: `client.Client` (validate target client on `AddController::actionIndex`, `EditController::actionHistory`, `api4/InventoryController::actionScanning`)
- Reads: `visiting.Visiting` (resolve agent's client list in `api4/InventoryController::actionList`)
- Writes: `visiting.Visit` (mark visit as `VISITED=1` when `inventory_qr_report` agent config is enabled, inside `api4/InventoryController::actionScanning`)
- APIs: `api4/inventory/scanning`, `api4/inventory/scanningPhoto`, `api4/inventory/add`, `api4/inventory/edit`, `api4/inventory/list`

### Gotchas

- `InventoryHistory` uses a **soft-close** pattern: when a status changes, the previous active row is set `ACTIVE='N'` and `DATE_TO=now` in a separate `UPDATE`, then a brand-new row is inserted — there is no in-place update of the status column. Queries that forget the `ACTIVE='Y'` filter will see duplicate current states.
- `StatusController::actionEdit` checks `InventoryService::CAN_CHANGE_STATUS_TO` for single-item transitions, but `StatusController::actionBulkEdit` falls back to `InventoryHistory::model()->statuses` (the older instance-property array, which does not include status `5`). The two guards are not in sync.
- Soft-delete (`ACTIVE='N'` on the `Inventory` row) is gated behind `ServerSettings::enableInventoryDeletion()`. If the flag is off, status `5` can still be written to `InventoryHistory` but the item stays visible in `ListController::actionData`.
- `api3/InventoryController::actionSet` is an older mobile endpoint that creates `Inventory` + `InventoryHistory` without the `InventoryService` factory; it always hard-codes `STATUS=2` and `DILER_ID='d0_1'`. Prefer `api4` for any new work.
