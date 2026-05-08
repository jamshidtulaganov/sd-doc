---
sidebar_position: 5
title: warehouse
audience: Backend engineers, QA, PM
summary: Multi-warehouse operations — receipts, transfers, picking, dispatch, and inter-filial movements.
topics: [warehouse, receipt, transfer, dispatch, multi-warehouse]
---

# `warehouse` module

Multi-warehouse operations: **receipts** (goods in), **transfers**
(between warehouses or filials), **picking / dispatch** (for orders),
and **inter-filial movements**.

## Key features

| Feature | What it does | Owner role(s) |
|---------|--------------|---------------|
| Goods receipt | Add a new receipt document; stock += count | 1 / 2 / 9 / warehouse staff |
| Receipt types | `sales` / `defect` / `reserve` (different downstream effects) | 1 / 9 |
| Stock transfer | Move stock between two warehouses inside one filial | 1 / 9 |
| Filial movement | Move stock between filials (inter-branch) | 1 |
| Pick & pack | Reserve and load lines for an order during fulfilment | 1 / 9 / warehouse staff |
| Audit trail | Every doc has create/approve/post timestamps | system |
| 1C sync | Optional outbound XML/JSON of receipts and movements | system |

## Folder

```
protected/modules/warehouse/
├── controllers/
│   ├── AddController.php
│   ├── EditController.php
│   ├── ListController.php
│   ├── ViewController.php
│   ├── ExchangeController.php           # transfer
│   ├── FilialMovementController.php     # inter-filial
│   └── ApiController.php
└── views/
```

## Concepts

- **Warehouse** — a physical or logical stock location.
- **Document** — the legal/operational paper trail of a stock movement
  (receipt / transfer / writeoff / inventory).
- **Stock row** — `(warehouse_id, product_id, lot, batch, count)`.
- **Reservation** — count blocked by an `Order` in status `Reserved`.

## Key feature flow — Goods receipt

See **Feature · Warehouse + Stock + Inventory** in
[FigJam · sd-main · Feature Flows](https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU).

<!-- TODO: missing reject/error branch — see workflow-design.md principle #9 -->
```mermaid
flowchart LR
  S(["Open Add doc"]) --> WT["Pick warehouse + type"]
  WT --> ADD["Scan/pick lines"]
  ADD --> SAV["Save doc"]
  SAV --> POST["Stock += count"]
  POST --> SYNC[("Optional 1C sync")]

  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000

  class S,WT,ADD,SAV,POST action
  class SYNC external
```

## Permissions

| Action | Roles |
|--------|-------|
| Create receipt | 1 / 2 / 9 |
| Approve transfer | 1 / 2 / 9 |
| Inter-filial movement | 1 |

## See also

- [`stock`](./stock.md) — pure quantity operations
- [`inventory`](./inventory.md) — physical inventory counts
- [`store`](./store.md) — retail store-side operations

## Workflows

### Entry points

| Trigger | Controller / Action / Job | Notes |
|---|---|---|
| Web | `AddController::actionIndex` | Create a new `Store` (warehouse) — POST JSON |
| Web | `FilialMovementController` via `CreateRequest` | Requester filial submits inter-filial stock request |
| Web | `FilialMovementController` via `ApproveRequest` | Provider filial approves pending request and creates downstream doc |
| Web | `FilialMovementController` via `ChangeStatus` | Draft → Pending → Cancelled / Rejected lifecycle |
| Web | `ApiController` via `CreatePurchaseDraftAction` | Mobile/web submits a purchase draft for manager review |
| Web | `ApiController` via `AcceptPurchaseDraftAction` | Manager accepts draft; `PurchaseDraftService::createPurchase` converts to `Purchase` |
| Web | `ApiController` via `CreateAdjustmentAction` | Stockman creates a stock adjustment (`StoreCorrector`) |

### Domain entities

```mermaid
erDiagram
    FilialMovementRequest {
        int ID PK
        int REQUESTER_FILIAL_ID FK
        int PROVIDER_FILIAL_ID FK
        int TYPE "1=movement 2=primary"
        int STATUS "1=draft 2=pending 3=approved 4=rejected 5=cancelled"
        string RESULT_DOC_ID FK
        int STORE_ID FK
        int TRADE_ID FK
    }
    FilialMovementRequestDetail {
        int ID PK
        int REQUEST_ID FK
        string PRODUCT_ID FK
        float QUANTITY
        float APPROVED_QUANTITY
        float PRICE
    }
    PurchaseDraft {
        int ID PK
        int STORE_ID FK
        int SHIPPER_ID FK
        int PRICE_TYPE_ID FK
        int STATUS "1=pending 2=confirmed 3=rejected 4=deleted"
        json DETAILS
    }
    Purchase {
        string PURCHASE_ID PK
        int STORE_ID FK
        int SHIPPER_ID FK
        int STATUS
        float SUMMA
    }
    StoreCorrector {
        string CORRECTOR_ID PK
        string STORE_ID FK
        string PRODUCT_ID FK
        float COUNT
        int TYPE "1=inventory 2=adjustment"
        string PARENT "0 = header row"
    }
    FilialMovementRequest ||--o{ FilialMovementRequestDetail : "has lines"
    PurchaseDraft ||--|| Purchase : "accepted into"
    StoreCorrector ||--o{ StoreCorrector : "parent/child lines"
```

### Workflow 1.1 — Inter-filial stock movement request lifecycle

A requester branch creates a stock request, the provider branch approves it, and a `PurchaseRefund` (type=movement) or `Order` (type=primary) is written atomically.

```mermaid
sequenceDiagram
    participant Web
    participant FilialMovementController
    participant CreateRequest
    participant ChangeStatus
    participant ApproveRequest
    participant WarehouseService
    participant DB

    Web->>FilialMovementController: POST /warehouse/filial-movement/create-request
    FilialMovementController->>CreateRequest: run()
    CreateRequest->>CreateRequest: validateProviderFilialId()
    CreateRequest->>CreateRequest: validateAndConvertType()
    CreateRequest->>CreateRequest: validateItems() — lookup Product, TradeDirection
    CreateRequest->>DB: INSERT filial_movement_request STATUS=1 (draft)
    CreateRequest->>DB: INSERT filial_movement_request_detail x N
    CreateRequest-->>Web: {request_id}

    Web->>FilialMovementController: POST /warehouse/filial-movement/change-status {status:"pending"}
    FilialMovementController->>ChangeStatus: run()
    ChangeStatus->>ChangeStatus: validateStatusChange() draft to pending
    ChangeStatus->>ChangeStatus: validateAccess() requester filial only
    ChangeStatus->>DB: UPDATE filial_movement_request STATUS=2

    Web->>FilialMovementController: POST /warehouse/filial-movement/approve-request
    FilialMovementController->>ApproveRequest: run()
    ApproveRequest->>ApproveRequest: validateProviderAccess() provider filial only
    ApproveRequest->>WarehouseService: getStockBalance(store_id)
    ApproveRequest->>ApproveRequest: validateStockAvailability()
    alt TYPE_MOVEMENT
        ApproveRequest->>DB: INSERT purchase_refund TYPE=movement
        ApproveRequest->>DB: INSERT purchase_refund_detail x N
        ApproveRequest->>DB: INSERT filial_order via FilialOrder::createMovement()
    else TYPE_PRIMARY
        ApproveRequest->>DB: INSERT order via FilialClient virtual client
        ApproveRequest->>DB: INSERT order_detail x N
    end
    ApproveRequest->>DB: UPDATE filial_movement_request STATUS=3, RESULT_DOC_ID
    ApproveRequest-->>Web: {request_id, result_doc_id}
```

### Workflow 1.2 — Purchase draft review and acceptance

A purchase draft is submitted (typically from the mobile app or web) and sits in status=pending until a manager accepts or rejects it. Acceptance calls `PurchaseDraftService::createPurchase` which writes the canonical `Purchase` + `PurchaseDetail` + `ShipperTransaction` and updates prices.

```mermaid
flowchart TD
    A(["Web: POST /warehouse/api/create-purchase-draft"]) --> B[CreatePurchaseDraftAction::run]
    B --> C{Date within close date?}
    C -- No --> ERR1[send ERROR_CODE_OUT_OF_CLOSE_DATE]
    C -- Yes --> D["setPriceType — validate PriceType.TYPE=1"]
    D --> E["setWarehouse — Store.ACTIVE=Y, VAN_SELLING=0, STORE_TYPE in 1/5"]
    E --> F["setSupplier — Shipper.ACTIVE=Y"]
    F --> G[preparePurchaseItems — aggregate by product/lot/price]
    G --> H[INSERT purchase_draft STATUS=1 DETAILS=json_encode items]

    H --> I(["Web: POST /warehouse/api/accept-purchase-draft ids"])
    I --> J[AcceptPurchaseDraftAction::run]
    J --> K[PurchaseDraftService::createPurchase per draft]
    K --> L[INSERT purchase STATUS=3]
    K --> M[INSERT purchase_detail x N]
    K --> N[INSERT shipper_transaction SUMMA negative]
    K --> O["PriceService::setPrices purchase price_type"]
    O --> P{selling_price_type_id set?}
    P -- Yes --> Q["PriceService::setPrices selling price_type"]
    P -- No --> R[UPDATE purchase_draft STATUS=2 confirmed]
    Q --> R

    H --> S(["Web: POST /warehouse/api/reject-purchase-draft ids"])
    S --> T[RejectPurchaseDraftAction::run]
    T --> U[UPDATE purchase_draft STATUS=3 rejected]
```

### Workflow 1.3 — Stock adjustment (StoreCorrector)

A stockman or warehouse manager records a manual stock correction via `CreateAdjustmentAction`. The `StoreCorrector` table uses a parent/child row structure: the header row has `PARENT='0'`, detail lines reference it by `CORRECTOR_ID`.

```mermaid
sequenceDiagram
    participant Web
    participant ApiController
    participant CreateAdjustmentAction
    participant DB

    Web->>ApiController: POST /warehouse/api/create-adjustment
    ApiController->>CreateAdjustmentAction: run()
    CreateAdjustmentAction->>CreateAdjustmentAction: authenticate() authorize(operation.stock.corrector)
    CreateAdjustmentAction->>DB: SELECT store WHERE STORE_ID — validate warehouse exists
    CreateAdjustmentAction->>DB: INSERT store_corrector PARENT=0 TYPE header row
    loop each product line
        CreateAdjustmentAction->>DB: INSERT store_corrector PARENT=corrector_id detail line
    end
    CreateAdjustmentAction-->>Web: {corrector_id}

    Web->>ApiController: GET /warehouse/api/list-adjustments?from=&to=
    ApiController->>CreateAdjustmentAction: ListAdjustmentsAction::run()
    Note over CreateAdjustmentAction,DB: JOIN store_corrector header + detail rows, GROUP BY CORRECTOR_ID
    CreateAdjustmentAction->>DB: SELECT store_corrector AS doc JOIN store_corrector AS det
    DB-->>Web: [{id, warehouse_id, date, quantity, summa}]
```

### Cross-module touchpoints

- Reads: `models.FilialClient` (virtual client lookup during primary-type approval in `ApproveRequest::createPrimaryDocument`)
- Reads: `models.PriceType`, `PriceService::getPrices` (price resolution in `PurchaseDraftService` and `ApproveRequest`)
- Reads: `models.TradeDirection` (trade-direction validation in `CreateRequest`)
- Writes: `models.Order` + `models.OrderDetail` (filial primary request → new sale order in `ApproveRequest::createPrimaryDocument`)
- Writes: `models.PurchaseRefund` + `models.PurchaseRefundDetail` (filial movement request → stock refund in `ApproveRequest::createMovementDocument`)
- Writes: `models.FilialOrder` via `FilialOrder::createMovement` (bridges movement document to requester filial)
- Writes: `models.ShipperTransaction` (supplier debt ledger entry in `PurchaseDraftService::createDocument`)
- APIs: `warehouse/api/get-stock-balance` — called internally by `ApproveRequest` via `WarehouseService::getStockBalance`

### Gotchas

- `FilialMovementRequest::STATUS_APPROVED` is terminal — `ChangeStatus` hard-blocks any further status change. Attempting to cancel or reject an approved request returns `ERROR_CODE_INVALID_STATUS`.
- `ApproveRequest::createMovementDocument` hard-codes `DILER_ID = "d0_1"` and `FILIAL_ID = 1` on the `PurchaseRefund`; this will break in multi-diler deployments.
- `PurchaseDraftService::createPurchase` calls `$purchaseModel->tgNotify()` — a Telegram notification side-effect; ensure the bot token is configured or the call silently fails but does not roll back the transaction.
- `CreateAdjustmentAction.php` was found empty (1 line) in the current branch (`btx-51207`). The list and get actions reference `StoreCorrector` correctly, but creation may be a work-in-progress.
- The `delete-purchase-draft` action is intentionally disabled in `ApiController` (commented out with "disabled by now").
- `WarehouseService::getStockBalance` does not lock rows; a race condition is possible between availability check and `PurchaseRefund` insert inside `ApproveRequest`.
