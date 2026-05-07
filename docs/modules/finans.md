---
sidebar_position: 9
title: finans
---

# `finans` module

Financial accounting layer: P&L, cashbox displacement, payment transfers,
agent P&L.

## Controllers

| Controller | Purpose |
|------------|---------|
| `PnlController` | P&L by period |
| `PivotPnlController` | Pivot view |
| `AgentPnlController` | Per-agent P&L |
| `PaymentTransferController` | Transfer between cashboxes |
| `CashboxDisplacementController` | Cashbox displacement |
| `ConsumptionController` | Expenses |

## See also

- [`pay`](./payment.md) — payment processing
- [`payment`](./payment.md) — payment approval workflow
