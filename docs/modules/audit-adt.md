---
sidebar_position: 11
title: audit / adt
audience: Backend engineers, QA, PM, Field ops
summary: Merchandising and trade-marketing — agents and dedicated auditors run structured surveys at outlets (audits, polls, facing, photo reports).
topics: [audit, merchandising, polls, facing, photo-report, adt]
---

# `audit` and `adt` modules

Merchandising and trade marketing. Agents and dedicated auditors run
structured surveys at client outlets.

| Module | Purpose |
|--------|---------|
| `audit` | Standard audits, polls, photo reports, facing |
| `adt` | Advanced audit toolkit (configurable surveys, brand / segment) |

## Key features

| Feature | What it does | Owner role(s) |
|---------|--------------|---------------|
| Define audit form | Build a poll: questions, variants, products to face | 1 / 9 |
| Assign to outlets / segments | Target the audit to specific clients | 1 / 9 |
| Run audit (mobile) | Agent answers poll, marks facing, takes photos | Agent |
| Photo report | Photo-only audit (lighter than full poll) | Agent |
| Facing per SKU | Track shelf placement for each SKU | Agent |
| Compliance scoring | Auto-score per outlet from poll answers | system |
| Supervisor review | Dashboard surfaces low-compliance outlets | Supervisor / Manager |
| ADT — properties / brands / segments | Multi-dimensional analytics on audit data | 1 / 9 |
| ADT — configurable reports | Parametrised report library on top of audit data | 1 / 9 |

## Audit module controllers

`AuditController`, `AuditorController`, `AuditsController`,
`DashboardController`, `FacingController`, `PhotoReportController`,
`PollController`, `PollResultController`.

## Audit data model

| Entity | Model |
|--------|-------|
| Audit | `Audit` |
| Audit result | `AuditResult` |
| Poll question | `AuditPollQuestion` |
| Poll variant | `AuditPollVariant` |
| Poll result | `AuditPollResult`, `AuditPollResultData` |
| Facing | `AFacing` |
| Photo report | `PhotoReport` |

## ADT (advanced)

`adt` supports configurable polls (`AdtPoll`, `AdtPollQuestion`,
`AdtPollResult`), property dimensions (`AdtProperty1`, `AdtProperty2`),
brand and segment grouping, and parametrised reports (`AdtReports`).

The mobile app's "audit" tab calls api3 endpoints that proxy into
these models.

## Key feature flow — Submission

See **Feature · Audit submission** in
[FigJam · sd-main · Feature Flows](https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU).

<!-- TODO: missing reject/error branch — see workflow-design.md principle #9 -->
```mermaid
flowchart LR
  V(["At client"]) --> Q["Answer poll"]
  Q --> F["Mark facing"]
  F --> P["Photos"]
  P --> SUB["POST /api3/auditor/index"]
  SUB --> AR["AuditResult rows"]
  AR --> RV["Supervisor review"]
  RV --> KPI(["Compliance KPI"])

  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000

  class V,Q,F,P,SUB,AR action
  class RV approval
  class KPI success
```

## Permissions

| Action | Roles |
|--------|-------|
| Configure audit | 1 / 9 |
| Run audit | 4 (agent) / dedicated auditors |
| Review | 8 / 9 |
