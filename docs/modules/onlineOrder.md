---
sidebar_position: 14
title: onlineOrder
---

# `onlineOrder` module

The B2B online store + Telegram bot ordering channel. Customers (or their
operators) place orders without an agent visit.

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
different `ROLE`. Sessions still go through Redis db0 with `HTTP_HOST`
prefix.

## Key feature flow — Online order

See **Feature — Online Order (B2B / WebApp)** in the
[FigJam board](../architecture/diagrams.md).

```mermaid
flowchart LR
  C[Customer login api4] --> CAT[Catalog]
  CAT --> CRT[Cart]
  CRT --> SUB[POST /api4/order/create]
  SUB --> ORD[Order STATUS=New]
  ORD --> PAY{Pay now?}
  PAY -->|yes| RDR[Redirect to provider]
  RDR --> CB[Callback verify]
  CB --> AP[Mark paid]
```
