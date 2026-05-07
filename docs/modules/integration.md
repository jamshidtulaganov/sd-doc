---
sidebar_position: 13
title: integration
audience: Backend engineers, QA, PM, Compliance
summary: Hub for outbound + inbound integrations with external systems (1C, Didox, Faktura.uz, Smartup, TraceIQ).
topics: [integration, 1c, didox, faktura, smartup, edi, sync]
---

# `integration` module

Hub for outbound + inbound integrations with external systems. Each
integration has its own controller; shared logic sits in
`protected/components/`.

## Key features

| Feature | What it does | Owner role(s) |
|---------|--------------|---------------|
| 1C order export | Push every order header + lines to 1C | system |
| 1C catalog import | Pull product / category / price changes from 1C | system |
| Didox e-invoice | Submit signed e-invoices on order Loaded / Delivered | system |
| Faktura.uz | State-mandated VAT e-invoices | system |
| Smartup import | Inbound orders from Smartup ERP | system |
| TraceIQ | Inbound trace events | system |
| Generic CSV / XML import / export | Ad-hoc transfer | 1 / Ops |
| Integration log UI | Browse / filter / re-trigger failed jobs | 1 / Ops |
| Per-tenant config | Each tenant configures its own credentials | 1 |

## Controllers

| Controller | External system |
|------------|-----------------|
| `DidoxController` | Didox (EDI) |
| `FakturaController` | Faktura.uz (e-faktura, EIMZO) |
| `TraceiqController` | Trace IQ |
| `ImportController` / `ExportController` | Generic 1C / CSV / XML |
| `ListController`, `EditController`, `GetController` | Admin UI for integration jobs |

## How it works

- **Outbound**: a job is enqueued (e.g. `ExportInvoiceJob`) when an
  order reaches a status that triggers EDI submission. The job calls
  the external API, updates the local document with response data,
  and writes to `IntegrationLog`.
- **Inbound**: scheduled poll jobs pull updates (e.g. price catalogs
  from 1C) and upsert into local tables.

## Key feature flow — Order export

See **Feature · Order Export to 1C / Faktura.uz** in
[FigJam · sd-main · Feature Flows](https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU).

```mermaid
flowchart LR
  S(["Order Loaded/Delivered"]) --> J["Enqueue ExportOrderJob"]
  J --> C{"Provider"}
  C -->|1C| S1[("POST 1C")]
  C -->|Didox| S2[("POST Didox")]
  C -->|Faktura| S3[("POST Faktura.uz")]
  S1 --> LOG["integration_log"]
  S2 --> LOG
  S3 --> LOG
  LOG --> RTY{"Retry count ≤ 6 and error?"}
  RTY -->|yes| BACK["Retry backoff max 6"]
  RTY -->|no| DONE(["Done"])
classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
classDef approval fill:#fef3c7,stroke:#92400e,color:#000
classDef success  fill:#dcfce7,stroke:#166534,color:#000
classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
classDef external fill:#f3f4f6,stroke:#374151,color:#000
classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
class S,J,LOG,BACK action
class S1,S2,S3 external
class DONE success
```

## Failure handling

- Per-job retry with exponential backoff (max 6 retries).
- After 6 failures, alert is dispatched to `adminEmail`.
- `IntegrationLog` row stays `ERROR` until manually re-triggered.

## Detailed protocol-level docs

- [1C / Esale](../integrations/1c-esale.md)
- [Didox](../integrations/didox.md)
- [Faktura.uz](../integrations/faktura-uz.md)
- [Smartup](../integrations/smartup.md)
