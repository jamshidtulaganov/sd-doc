---
sidebar_position: 2
title: Domain model
---

# sd-billing domain model

```mermaid
erDiagram
  DISTRIBUTOR ||--o{ DILER : owns
  DILER ||--o{ SUBSCRIPTION : has
  DILER ||--o{ PAYMENT : pays
  DILER ||--|| SERVER : runs
  DILER ||--o| DILER_BONUS : has
  PACKAGE ||--o{ SUBSCRIPTION : referenced_by
  TARIFF ||--o{ TARIFF_PACKAGE : bundles
  PACKAGE ||--o{ TARIFF_PACKAGE : in
  PAYMENT }o--|| CASHBOX : posted_to
  PAYMENT }o--o| CLICK_TRANSACTION : via
  PAYMENT }o--o| PAYME_TRANSACTION : via
  PAYMENT }o--o| PAYNET_TRANSACTION : via
  USER }o--|| ROLE : assigned

  DISTRIBUTOR { string ID PK string NAME float BALANS }
  DILER { int DILER_ID PK string NAME string HOST int STATUS float BALANS float MIN_SUMMA float MIN_LICENSE float CREDIT_LIMIT date CREDIT_DATE date FREE_TO int MONTHLY bool IS_DEMO }
  SUBSCRIPTION { string ID PK int DILER_ID FK int PACKAGE_ID FK date START_FROM date ACTIVE_TO bool IS_DELETED }
  PACKAGE { int PACKAGE_ID PK string NAME string SUBSCRIP_TYPE int TYPE string PACKAGE_TYPE string CLIENT_TYPE float PRICE }
  TARIFF { int ID PK string NAME }
  TARIFF_PACKAGE { int ID PK int TARIFF_ID FK int PACKAGE_ID FK }
  PAYMENT { string ID PK int DILER_ID FK string TYPE float SUMMA datetime DATE int CASHBOX_ID FK }
  CASHBOX { int ID PK string NAME string CURRENCY }
  CLICK_TRANSACTION { string ID PK int PAYMENT_ID FK string SIGN string STATE }
  PAYME_TRANSACTION { string ID PK int PAYMENT_ID FK string STATE }
  PAYNET_TRANSACTION { string ID PK int PAYMENT_ID FK string STATE }
  SERVER { int ID PK int DILER_ID FK string HOST string DB_HOST string DB_USER string DB_PASS string STATUS }
  DILER_BONUS { int DILER_ID PK FK float QUOTA }
  USER { int USER_ID PK string LOGIN int ROLE bool IS_ADMIN }
  ROLE { int ID PK string NAME }
```

## Core entities

### `Distributor`

Wholesale layer above dealers. Responsible for a region of dealers.
Money flows: dealers pay distributors, distributors get a settlement
share.

- Table: `d0_distributor`

### `Diler` (dealer)

The customer record. **The most important entity** — almost every
report and command operates on it.

- Table: `d0_diler`
- Key fields:
  - `STATUS` ∈ `0 NO_ACTIVE / 10 ACTIVE / 20 DELETED / 30 ARCHIVE`
  - `BALANS` — current balance (positive = credit, negative = debt)
  - `MIN_SUMMA`, `MIN_LICENSE` — purchase thresholds
  - `CREDIT_LIMIT`, `CREDIT_DATE` — overdraft window
  - `FREE_TO` — last date a free trial covers
  - `MONTHLY` — special flag (`15 = all packages`)
  - `IS_DEMO` — demo tenant
  - `HOST` — the dealer's actual SD-app server hostname
- Hooks: `Diler::beforeSave` forces `STATUS`, calls `updateServer()` and
  `sendRequest()` when `HOST` changes.

### `Subscription`

A purchased package for a dealer for a date window.

- Table: `d0_subscription`
- Soft-delete via `IS_DELETED`.
- Date window: `[START_FROM, ACTIVE_TO]`.

### `Package`

The license / service catalog item.

- Table: `d0_package`
- `SUBSCRIP_TYPE` enumerates roles the package licenses:
  `admin`, `agent`, `merchant`, `seller`, `bot_report`, `bot_order`,
  `smpro_user`, `smpro_bot`.
- `TYPE` is duration in days: `10 / 20 / 30 / 90 / 180 / 360` (and `1`
  for daily).
- `PACKAGE_TYPE` ∈ `paid / free / demo`.
- `CLIENT_TYPE` ∈ `private / public`.

### `Payment`

One row per money movement.

- Table: `d0_payment`
- `TYPE` ∈ `cash, cashless, p2p, license, distribute, payme, click,
  service, paynet, mbank`.
- DB **triggers** on this table maintain running balances (see
  migration `m221114_070346_create_triggers_to_payment.php`).

### Gateway transaction tables

Each payment gateway has its own transaction table:

| Table / model | Gateway | Notes |
|---------------|---------|-------|
| `d0_click_transaction` / `ClickTransaction` | Click | Sign-checked via `ClickTransaction::checkSign`. Two-phase: prepare → confirm |
| `d0_payme_transaction` / `PaymeTransaction` | Payme | Handled by `api/helpers/PaymeHelper` |
| `d0_paynet_transaction` / `PaynetTransaction` | Paynet | SOAP — `extensions/paynetuz/`, creds in `_constants.php` |

All gateway hits funnel into `Payment` rows of an online type
(`TYPE_PAYMEONLINE / TYPE_CLICKONLINE / TYPE_PAYNETONLINE`) which
increase the dealer's `BALANS`. Then `Diler::deleteLicense()` and
`Diler::refresh()` settle outstanding subscriptions.

### `Server`

The dealer's actual SD-app server (the `sd-main` deployment).

- Table: `d0_server`
- Status flow: `NEW → SENT → OPENED`.
- `Diler.HOST` change triggers `Diler::updateServer()`.

### `Tariff` / `TariffPackage`

Bundles of packages a dealer can subscribe to as one SKU.

### `User` (internal staff)

- Table: `d0_user`
- Roles: `ADMIN(3), MANAGER(4), OPERATOR(5), API(6), SALE(7),
  MENTOR(8), KEY_ACCOUNT(9), PARTNER(10)` plus `IS_ADMIN` super-flag.

## Conventions

See the project's `CLAUDE.md` for the full list. Highlights:

- Tables use `d0_` prefix; in models reference as `{{name}}` so Yii's
  `tablePrefix` is applied.
- Column casing is **mixed by era**: legacy tables (`Diler`, `Payment`,
  `Subscription`, `Package`, `User`) use **UPPER_SNAKE_CASE**; newer
  tables (`d0_notify_cron`, `d0_notify_bot`, `d0_access_user`,
  `d0_server`) use **lower_snake_case**. Don't fight existing
  conventions.
- Russian / Uzbek-Latin comments are common — preserve them.
