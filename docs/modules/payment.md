---
sidebar_position: 10
title: payment / pay
---

# `payment` and `pay` modules

Two related modules:

- **`pay`** — low-level payment recording (entries against orders).
- **`payment`** — approval workflow on top of `pay`.

## Approval flow

Field-collected payments need approval to apply against debt:

```mermaid
flowchart LR
  A[Agent collects cash] --> B[Pay record created]
  B --> C{Approval needed?}
  C -- yes --> D[Cashier reviews]
  D --> E[Approved / Rejected]
  C -- no --> F[Auto-applied]
  E --> F
```

`payment/ApprovalController` is the cashier's review screen.

## Key feature flow — Payment collection & approval

See **Feature — Payment Collection & Approval** in the
[FigJam board](../architecture/diagrams.md).

```mermaid
flowchart LR
  A[Agent collects] --> P[PaymentDeliver pending]
  P --> C[Cashier review]
  C -->|approve| AP[Apply against debt]
  C -->|reject| RJ[Rejected]
  AP --> CB[Cashbox updated]
  AP --> NOT[Notify agent]
  RJ --> NOT
```
