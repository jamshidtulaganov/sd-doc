---
sidebar_position: 10
title: payment / pay
audience: Backend engineers, QA, PM, Cashier
summary: Two related modules — pay (low-level payment recording) and payment (cashier approval workflow on top).
topics: [payment, approval, cashier, cash, non-cash]
---

# `payment` and `pay` modules

Two related modules:

- **`pay`** — low-level payment recording (entries against orders).
- **`payment`** — approval workflow on top of `pay`.

## Key features

| Feature | What it does | Owner role(s) |
|---------|--------------|---------------|
| Record payment | Create a `Payment` row tied to an order | Agent / Operator |
| Approve payment | Cashier confirms the payment is real | Cashier |
| Reject payment | Cashier rejects with a reason | Cashier |
| Apply against debt | On approval, applies to client's debt + cashbox | system |
| Reassign to other order | Operator can re-route a misplaced payment | 1 / 6 |
| Notification | Agent + customer notified on outcome | system |

## Approval flow

See **Feature · Payment Collection & Approval** in
[FigJam · sd-main · Feature Flows](https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU).

<!-- TODO: missing reject/error branch — see workflow-design.md principle #9 -->
```mermaid
flowchart LR
  A["Agent collects cash"] --> B["Pay record created"]
  B --> C{"Approval needed?"}
  C -- yes --> D["Cashier reviews"]
  D --> E["Approved / Rejected"]
  C -- no --> F["Auto-applied"]
  E --> F
classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
classDef approval fill:#fef3c7,stroke:#92400e,color:#000
classDef success  fill:#dcfce7,stroke:#166534,color:#000
classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
classDef external fill:#f3f4f6,stroke:#374151,color:#000
classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
class A,B,F action
class D approval
class E success
```

`payment/ApprovalController` is the cashier's review screen.

## Workflow audit

See [Workflow design standards](../team/workflow-design.md) — this
flow is rated against 12 design principles. Open action items: add an
auto-approve threshold, capture rejection reason, add an SLA timer.

## Permissions

| Action | Roles |
|--------|-------|
| Create | 4 / 5 / 6 |
| Approve / reject | 6 (cashier) / 1 / 2 |
| Reassign | 1 / 6 |
