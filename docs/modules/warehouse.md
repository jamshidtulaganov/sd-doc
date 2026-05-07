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
