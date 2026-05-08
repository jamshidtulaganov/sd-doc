---
sidebar_position: 14
title: onlineOrder
audience: Backend engineers, QA, PM, B2B customers
summary: B2B online store + Telegram bot ordering channel — customers place orders directly without an agent visit.
topics: [online-order, b2b, telegram, webapp, self-service, online-payment]
---

# `onlineOrder` module

The B2B online store + Telegram bot ordering channel. Customers (or
their operators) place orders without an agent visit.

## Key features

| Feature | What it does | Owner role(s) |
|---------|--------------|---------------|
| Public catalog browsing | Customer browses products with category / brand / stock filters | end customer |
| Cart + order placement | Customer submits via api4 | end customer |
| Online payment redirect | Hand off to Click / Payme / Paynet for payment | end customer |
| Pay-later flow | For customers with credit; goes through standard order pipeline | end customer |
| Order history | Customer sees past orders + statuses + downloadable invoices | end customer |
| Contact form | Reach the operator team from the portal | end customer |
| Reports | Customer's own consumption reports | end customer |
| Scheduled reports | Periodic emailed report digests | end customer |
| Telegram bot | `/start`, `/catalog`, `/order`, `/orders`, `/help` | end customer |
| Telegram WebApp | Embedded SPA inside Telegram for full ordering | end customer |

## Controllers

| Controller | Purpose |
|------------|---------|
| `CatalogController` | Public catalog browsing |
| `ContactController` | Contact form / messaging |
| `OrderController` | Order placement & history |
| `PaymentController` | Online payment redirect |
| `ReportController` | Customer's own reports |
| `ScheduledReportController` | Periodic emailed reports |
| `TelegramController` | Telegram bot webhook |
| `WebAppController` | Telegram WebApp host |

## Auth

Online users authenticate against the same `User` table but with a
different `ROLE`. Sessions still go through Redis db0 with
`HTTP_HOST` prefix.

## Key feature flow — Online order

See **Feature · Online order + Defect/Return** in
[FigJam · sd-main · Feature Flows](https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU).

```mermaid
flowchart LR
  C(["Customer login api4"]) --> CAT["Catalog"]
  CAT --> CRT["Cart"]
  CRT --> SUB["POST /api4/order/create"]
  SUB --> ORD["Order STATUS=New"]
  ORD --> PAY{"Pay now?"}
  PAY -->|yes| RDR[("Redirect to provider")]
  RDR --> CB["Callback verify"]
  CB --> AP(["Mark paid"])

  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000

  class C,CAT,CRT,SUB,ORD,PAY,CB action
  class RDR external
  class AP success
```
