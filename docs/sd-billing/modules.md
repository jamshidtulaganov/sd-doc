---
sidebar_position: 3
title: Modules
---

# sd-billing modules

## `api` — inbound integrations

Receives webhooks and machine-to-machine calls from payment gateways,
1C, the SD-app, partner systems, and admin tools.

| Submodule | Purpose |
|-----------|---------|
| `Click` | Click gateway prepare/confirm |
| `Payme` | Payme JSON-RPC |
| `Paynet` | Paynet SOAP (`extensions/paynetuz`) |
| `License` | Hard-coded `TOKEN`-protected endpoints to query/update licences |
| `Sms` | Inbound SMS webhooks (DLR) |
| `Host` | Server status callbacks from `sd-main` |
| `Quest` | Custom quest endpoints |
| `Info` | Public info / health |
| `Maintenance` | Cleaner / migration utilities |

Auth varies per controller:
- `LicenseController::TOKEN` — hard-coded constant.
- `ClickController` — gateway sign verification (`checkSign`).
- `PaymeController` — Payme HMAC verification.
- A few endpoints log in as a fixed user via `new UserIdentity("sd","sd")`
  (e.g. `actionBuyPackages`, `actionExchange`).

API responses use `sendSuccessResponse` / `sendFailResponse` helpers
defined under `application.modules.api.components.*`.

## `dashboard` — internal admin UI

Operations team's primary screen. Lists dealers, distributors,
payments, subscriptions, charts, fixes for stuck records.

## `operation` — domain CRUD

Where most write traffic happens. Owns:

- Packages
- Subscriptions
- Payments
- Tariffs
- Blacklist
- Notifications

## `partner` — self-service portal

Partners (`ROLE_PARTNER`) sign in here to see their dealers and earnings.
Restricted to the `partner` and `directory` modules + `dashboard/dashboard/index`
+ `site/*` by `PartnerAccessService::checkAccess`. (Currently this
check is **commented out** in the base controller — see the security
landmines page.)

## `cashbox`

Cash desks and offline payment sources. Tracks transfers between cash
desks and consumption.

## `report`

Reporting screens — slower aggregates, often PHPExcel export.

## `setting`

App settings + a system log viewer.

## `notification` — in-app

In-app notifications (the bell icon in dashboard).

## `sms`

SMS templates + sending. Provider:

- **Eskiz** (`notify.eskiz.uz`) for UZ
- **Mobizon** for KZ

Hardcoded credentials live in `protected/components/Sms.php` (security
landmine — see the dedicated page).

## `bonus`

Bonus / discount logic. Quarterly rollups.

## `access`

Per-user permission grid: `AccessUser`, `AccessOperation`,
`AccessRelation`. Operations have bit-flag access:

```
DELETE = 8
SHOW   = 4
UPDATE = 2
CREATE = 1
```

`Access::has($operation, $type_access)` is the check; `Access::check()`
throws `CHttpException(403)` on miss. Admins (`ROLE_ADMIN` or
`IS_ADMIN`) short-circuit to allow.

## `directory`

Directories / reference data (cities, countries, currencies, package
types, etc.).

## `dbservice`

DB maintenance utilities — bulk fixes, ad-hoc data migrations,
diagnostic queries.
