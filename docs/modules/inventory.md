---
sidebar_position: 6
title: inventory
---

# `inventory` module

Physical inventory counts (stocktakes), with mobile-app barcode scanning
and reconciliation against the system stock.

## Controllers

`AddController`, `EditController`, `DeleteController`, `ListController`,
`HistoryController`, `PhotoController`, `ScanController`, `StatusController`.

## Workflow

1. Manager creates an inventory document (`AddController`).
2. Operators scan products in the warehouse via `ScanController` (mobile).
3. System computes deltas vs current stock.
4. Manager approves; deltas post to `stock` as adjustments.

## Key feature flow — Stocktake

See **Feature — Inventory Stocktake** in the
[FigJam board](../architecture/diagrams.md).

```mermaid
flowchart LR
  M[Manager creates doc] --> SC[Operators scan]
  SC --> CALC[Compute deltas vs Stock]
  CALC --> REV[Manager review]
  REV -->|approve| POST[Post adjustments]
  REV -->|adjust| SC
```

## Photos

`PhotoController` attaches per-row photo evidence (e.g. damaged goods).
Stored under `upload/inventory/<doc_id>/`.
