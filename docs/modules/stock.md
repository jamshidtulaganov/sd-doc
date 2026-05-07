---
sidebar_position: 7
title: stock
audience: Backend engineers, QA, PM
summary: Quantity-level stock operations — returns, exchanges, write-offs, purchases. Complements warehouse (which holds the documents).
topics: [stock, return, exchange, writeoff, purchase, reservation]
---

# `stock` module

Quantity-level operations on top of the warehouse layer: returns,
exchanges between stores, write-offs, purchase. Complements
[`warehouse`](./warehouse.md) (which holds the document headers).

## Key features

| Feature | What it does | Owner role(s) |
|---------|--------------|---------------|
| Add return | Record a return-to-stock from a defect / reject | 1 / 9 / warehouse |
| Buy / purchase | Inbound purchase from a supplier | 1 / 9 |
| Exchange between stores | Move stock between retail stores | 1 / 9 |
| Excretion / write-off | Permanent removal (damage, theft) | 1 |
| Financial report | Stock value, ageing, dead stock | 1 / 9 |
| Store report | Per-store stock posture | 1 / 9 |
| Reservation atomic op | `Stock::reserveForOrder()` runs in a transaction | system |

## Folder

```
protected/modules/stock/
├── controllers/
│   ├── AddReturnController.php
│   ├── BuyController.php
│   ├── ExchangeStoresController.php
│   ├── ExcretionController.php
│   ├── FinancialReportController.php
│   └── …
└── views/
```

## Stock services

The shared `StockService` (in `protected/components/`) is the **single
point** that mutates `stock` rows. Avoid hand-rolled SQL — concurrency
bugs lurk there.

## Reservations

When an order moves to `Reserved`, `Stock::reserveForOrder()`
decrements `available` count and increments `reserved` count
**atomically** in one transaction.

## Key feature flow — Defect & Return

See **Feature · Online order + Defect/Return** in
[FigJam · sd-main · Feature Flows](https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU).

```mermaid
flowchart LR
  D(["Delivery"]) --> CHK{"All lines accepted (no defect)?"}
  CHK -->|yes| OK["STATUS=Delivered"]
  CHK -->|no| DEF["Defect rows"]
  DEF --> RTS["Return-to-stock job"]
  RTS --> RPT["Defect KPI"]
classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
classDef approval fill:#fef3c7,stroke:#92400e,color:#000
classDef success  fill:#dcfce7,stroke:#166534,color:#000
classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
classDef external fill:#f3f4f6,stroke:#374151,color:#000
classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
class D,DEF,RTS,RPT action
class OK success
```

## Permissions

| Action | Roles |
|--------|-------|
| Return / write-off | 1 / 9 |
| Purchase | 1 / 9 |
| Exchange between stores | 1 / 9 |
