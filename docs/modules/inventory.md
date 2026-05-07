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
