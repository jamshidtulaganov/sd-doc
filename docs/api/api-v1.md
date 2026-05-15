---
sidebar_position: 3
title: API v1 (legacy)
---

# API v1 — `api` module

Legacy API for partner integrations and one-off connectors. Maintenance
only — **don't add new endpoints here**, use v4 instead.

## Surface

```
protected/modules/api/controllers/
```

Active controllers (non-`*.obsolete`):

- `Json1CController` — 1C JSON sync
- `BillingController` — billing webhooks
- `LicenseController` — licence checks
- `NotificationController` — push registration
- `OperatorController` / `Operator2Controller` — operator-side helpers
- `OrderController` — partner order create
- `PushController` — FCM/APNS dispatcher
- `R2Controller` — second-generation read
- `SdController`, `SalesdocController`, `Mef1cController`,
  `IdokonController`, `IkromController`, `NavruzController`,
  `ZarqandController`, `NeonController`, `OnlineOrderController`,
  `OnlineOrder3Controller`, `PradataController`, `SmartUpController`,
  `StockController`, `TelegramBotController`, `V2Controller`,
  `V4Controller`, `CronVisitController`, `ScheduledSmsController`,
  `AnalyticsController`, `ApiLogController`, `CislinkController`,
  `CleannerController`, `ConstructionController`, `DemoCronController`,
  `DisabledChatsController`, `Json1CController`.

(See the API v3 / v4 pages for the modern surfaces.)

## Auth

Mostly **shared-secret** in URL or POST body, varying per endpoint. Some
use HTTP basic. There is no global token scheme.

## Format

JSON. A few endpoints accept XML (`xml1c`, `pradata`).

## Recommended migration

If you're integrating today: prefer
[API v4](./api-v4-online/). If you're adding a feature for an existing
v1 consumer, contact the platform team — many v1 endpoints are scheduled
for retirement.
