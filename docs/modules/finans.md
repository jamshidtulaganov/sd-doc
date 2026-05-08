---
sidebar_position: 9
title: finans
audience: Backend engineers, QA, PM, Finance ops
summary: Financial accounting layer in sd-main — P&L, agent P&L, pivot P&L, cashbox transfers, consumption / expense tracking.
topics: [finance, pnl, cashbox, transfer, consumption, expense]
---

# `finans` module

Financial accounting layer for sd-main. Aggregates the money side of
the business: P&L, agent P&L, cashbox movements, expenses.

## Key features

| Feature | What it does | Owner role(s) |
|---------|--------------|---------------|
| P&L by period | Income / expense / margin per period | 1 / 9 / Finance |
| Pivot P&L | Slice-and-dice P&L | 1 / 9 / Finance |
| Agent P&L | Per-agent profitability | 1 / 8 / 9 |
| Cashbox displacement | Move money between cashboxes (e.g. agent → main) | 6 / Finance |
| Payment transfer | Reassign a payment to a different cashbox / order | 1 / 6 |
| Consumption / expense tracking | Operational expenses against budget | 1 / Finance |

## Folder

```
protected/modules/finans/
└── controllers/
    ├── PnlController.php
    ├── PivotPnlController.php
    ├── AgentPnlController.php
    ├── CashboxDisplacementController.php
    ├── PaymentTransferController.php
    └── ConsumptionController.php
```

## See also

- [`pay`](./payment.md) — payment recording
- [`payment`](./payment.md) — payment approval workflow
