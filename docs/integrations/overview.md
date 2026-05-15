---
sidebar_position: 1
title: Integrations overview
---

# Integrations overview

| Integration | Direction | Module | Page |
|-------------|-----------|--------|------|
| 1C / Esale | bidirectional | `integration` + `sync` + `api` | [1C / Esale](./1c-esale.md) |
| Didox | outbound (EDI) | `integration` | [Didox](./didox.md) |
| Faktura.uz | bidirectional | `integration` | [Faktura.uz](./faktura-uz.md) |
| Smartup | inbound | `integration` | [Smartup](./smartup.md) |
| Telegram | bidirectional | `onlineOrder`, bot | [Telegram](./telegram.md) |
| Firebase FCM | outbound | `api` push | [FCM](./fcm.md) |
| SMS | outbound | `sms` | [SMS](./sms.md) |
| GPS providers | inbound | `gps3` | [GPS](./gps.md) |

## General principles

- Every integration writes to **`IntegrationLog`** (request, response,
  status, error). Use it as the first stop when debugging.
- All outbound calls go through a queue job — never inline in a request
  handler.
- Idempotency keys live on each external entity (`XML_ID`, `EXT_ID`).
- Time-outs default to **15 s**; retry with exponential backoff up to 1 h.

## Controller map

Verified against `static/data/routes.json` and the live source under
`protected/modules/`. Each row links to the relevant controller.

| Integration | sd-main module | Controllers |
|-------------|---------------|-------------|
| 1C / Esale (JSON) | `api` | `Json1CController`, `Mef1cController` (`protected/modules/api/controllers/`) |
| 1C / Esale (legacy XML) | `api` | `Xml1CController.php.obsolete` — frozen; do not extend |
| Didox | `integration` | `DidoxController` (`protected/modules/integration/controllers/DidoxController.php`) |
| Faktura.uz | `integration` + `orders` | `FakturaController` (under `integration/`) and `FakturaUZController` (under `orders/` — driven by the order workflow) |
| Smartup | `api` + `settings` | `SmartUpController` (`api`), `SmartUpController` (`settings/SmartUpController` for the admin UI), `protected/modules/integration/actions/smartupx/ImportOrdersAction.php` |
| Telegram (bot + WebApp + report bot) | `onlineOrder`, `report`, `api` | `onlineOrder/TelegramController`, `report/TelegramController`, `api/TelegramBotController` |
| Firebase FCM | `api` + components | `api/PushController` (subscribe/send), `FcmV1` component (`protected/components/FcmV1.php`) |
| SMS | `sms` + `api` | `sms/CallbackController` (DLR webhook), `sms/MessageController`, `sms/PackageController`, `api/ScheduledSmsController` |
| GPS providers | `gps3` + `api3` | `gps3/ClientController`, `gps3/DirectiveController`, `api3/GpsController` (mobile-side ingest) |
| TraceIQ (CRPT integration) | `integration` | `TraceiqController` (`protected/modules/integration/controllers/TraceiqController.php`) |

The committed-but-obsolete files (`*.php.obsolete`) in
`protected/modules/api/controllers/` are stale code paths
(`EsaleController`, `OnecController`, `OneController`, `SdocController`,
`HistoryController`, etc.). New work must NOT extend them — use
`Json1CController` / `Mef1cController` for 1C and the modern integration
module for everything else.
