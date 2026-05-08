---
sidebar_position: 1
title: Feature workflows · index
slug: /sd-billing/workflows
---

# Feature workflows — catalog

This is the index of every feature (one gateway integration, one admin
screen, one operation form, one report, one cron command) in
**sd-billing**. Each row is one controller; rows linked in **bold**
have a full workflow page that follows the [style guide](./style.md).
Unlinked rows are stubs — their feature exists in code, but the
workflow page hasn't been written yet.

If you're a new employee, start here:

1. Read [sd-billing overview](../overview.md) and
   [auth and access](../auth-and-access.md) to understand the
   single-DB, per-tenant-licence model.
2. Read the [style guide](./style.md) so you know what the workflow
   pages mean.
3. Pick a workflow page below — or, if your assigned feature only has
   a stub, draft it using the `sd-billing-workflow-author` skill
   (lives at `sd-docs/skills/sd-billing-workflow-author/SKILL.md`).

> **Source**: every entry maps to one controller file under
> `sd-billing/protected/modules/<module>/controllers/`.

## Style and skill

| Page | When to read |
|------|--------------|
| [Style guide](./style.md) | Before writing or reviewing any feature page |
| `sd-docs/skills/sd-billing-workflow-author/SKILL.md` | When drafting a stub into a full page (file path, not in the docs site) |

---

## api · gateway webhooks

Receives inbound HTTP calls from payment gateways, external
systems, and admin tools. Auth varies per controller — see
[modules](../modules.md) for details.

| Feature | Controller | Stub line |
|---------|-----------|-----------|
| [Click gateway](./api-click.md) | `ClickController` | Handles Click prepare/confirm callbacks; verifies sign with `ClickTransaction::checkSign()` |
| Payme gateway | `PaymeController` | Payme JSON-RPC endpoint; verifies HMAC before crediting payments |
| Paynet gateway | `PaynetController` | Paynet SOAP integration via `extensions/paynetuz`; processes payment confirmations |
| 1C integration | `Api1CController` | Receives cashless payment records and balance sync from 1C accounting |
| App API | `AppController` | Mobile/app auth endpoint — issues session tokens for the billing app client |
| Host status | `HostController` | Receives active-host pings and token auth calls from `sd-main` instances |
| License endpoints | `LicenseController` | TOKEN-protected endpoints to query and update dealer licences (read by `sd-main` at login) |
| SMS webhook | `SmsController` | Inbound SMS delivery-receipt (DLR) callbacks from Eskiz / Mobizon |
| Info / health | `InfoController` | Public health-check and billing-info endpoint; no auth required |
| Quest | `QuestController` | Custom quest-metric endpoint; returns computed KPIs (price, churn, NPS, …) via basic auth |

---

## operation · subscriptions and payments

Where most write traffic happens. Owns subscription lifecycle,
payment recording, package management, tariffs, and blacklist.

| Feature | Controller | Stub line |
|---------|-----------|-----------|
| [Subscription lifecycle](./operation-subscription.md) | `SubscriptionController` | CRUD for dealer subscriptions; actions: list, create, update, delete, exchange, calculate-bonus |
| [Payment recording](./operation-payment.md) | `PaymentController` | Records incoming payments against a dealer; supports cashbox, distributor, and gateway sources |
| Package management | `PackageController` | CRUD for billing packages (feature bundles with price and duration) |
| Package SMPro | `PackageSMProController` | Variant of package management scoped to the SMPro product line |
| Subscription SMPro | `SubscriptionSMProController` | Subscription management scoped to SMPro dealers |
| Dealer–package relation | `RelationController` | Maps dealers to packages; controls which feature sets a dealer can activate |
| Tariff management | `TariffController` | CRUD for tariff plans linked to packages |
| Blacklist | `BlacklistController` | Adds or removes dealers from the payment/access blacklist |
| Notifications | `NotificationController` | Manages outbound notification rules (expiry warnings, payment receipts) |
| View hub | `ViewController` | Shared view entry-point for operation module pages |

---

## dashboard · admin UI

Operations team's primary screen. Lists dealers, distributors,
payments, subscriptions, charts, and fixes for stuck records.

| Feature | Controller | Stub line |
|---------|-----------|-----------|
| Dashboard home | `DashboardController` | Main admin landing page — KPI tiles, dealer counts, recent payments |
| Dealer admin | `DealerController` | Vue-powered dealer list with search, status filter, tariff and blacklist management |
| Diler (legacy) | `DilerController` | Legacy AJAX-CRUD dealer screen; predecessor to `DealerController` |
| Distributor | `DistrController` | AJAX-CRUD management of distributor records |
| Distributor computation | `DistrComputationController` | Per-distributor settlement computation view (admin-only) |
| Computation (settlement) | `ComputationController` | Triggers and reviews dealer↔distributor balance settlement runs |
| Distributor payments | `DistrPaymentController` | AJAX-CRUD log of payments between distributor and sd-billing |
| Dashboard payment | `PaymentController` | Dashboard-side read-only view of all incoming payments |
| Charts | `ChartController` | Serves aggregated time-series data for dashboard charts |
| Country sale | `CountrysaleController` | AJAX-CRUD for per-country revenue targets |
| Server monitor | `ServerController` | Lists registered `sd-main` servers and their last-seen status |
| Service (dashboard) | `ServiceController` | Upload and manage service-notification files shown in the admin UI |
| Settings | `SettingController` | Admin-UI app settings (feature flags, thresholds, display options) |
| Subscription view | `SubscripController` | Read-only dashboard view of active subscriptions per dealer |
| Fix toolbox | `FixController` | Ad-hoc data-fix commands (give discount, reset state, bulk corrections) |
| Reset | `ResetController` | Resets dealer-specific data or subscription state (admin-only destructive ops) |
| Notification | `NotificationController` | Dashboard view for in-app notification management |

---

## partner · self-service portal

Partners (`ROLE_PARTNER`) sign in here to see their dealers and
earnings. Access is restricted via `PartnerAccessService::checkAccess`
(currently commented out — see security landmines).

| Feature | Controller | Stub line |
|---------|-----------|-----------|
| Partner view hub | `ViewController` | Entry-point; routes partner users to their allowed screens |
| Partner dealers | `DealerController` | Partner-scoped dealer list — shows only the partner's own dealer accounts |
| Partner subscriptions | `SubscriptionController` | Read-only subscription status for the partner's dealers |
| Partner payments | `PaymentController` | Partner's payment history — inbound and outbound |
| Partner report | `ReportController` | Earnings and commission report for the partner |

---

## cashbox · cash desks and flow

Tracks offline cash desks, flow types, transfers between desks,
and consumption records.

| Feature | Controller | Stub line |
|---------|-----------|-----------|
| Cashbox list | `CashboxController` | AJAX-CRUD for cash desk records (name, owner user, balance) |
| Cash desk | `CashDeskController` | Detailed view and operations for a single cash desk |
| Flow type | `FlowTypeController` | Reference list of cash-flow categories (income, expense, transfer, …) |
| Coming type | `ComingTypeController` | Reference list of incoming-payment source types |
| Transfer | `TransferController` | Records cash transfers between desks |
| Consumption | `ConsumptionController` | Records cash outflows (consumption/expense entries) |

---

## report · aggregated reports

Slower aggregate screens, often with PHPExcel export.

| Feature | Controller | Stub line |
|---------|-----------|-----------|
| Active customers | `ActiveCustomersController` | Count of active dealers per country / currency over a period |
| Catchers | `CatchersController` | New-dealer acquisition report by salesman |
| Churn | `ChurnController` | Month-over-month churn rate by salesman or country |
| Client report | `ClientReportController` | Per-client (dealer) usage and payment summary |
| Diler report | `DilerReportController` | Aggregate report across all dealers |
| Feedback | `FeedbackController` | AJAX-CRUD log of NPS / feedback entries |
| Key account | `KeyAccountController` | Key-account dealer performance by salesman |
| Key account period | `KeyAccountReriodController` | Key-account report sliced by custom period |
| P&L | `PLController` | Profit-and-loss statement for a period |
| Pivot | `PivotController` | Multi-dimensional pivot of billing metrics |
| Plan sales | `PlanSalesController` | Sales plan vs actual for the billing sales team |
| Poll report | `PollReportController` | Results of in-app dealer polls |
| Quest report | `QuestController` | Quest-metric report view (mirrors api/Quest data) |
| Region | `RegionController` | Dealer and revenue breakdown by region |
| General report | `ReportController` | Top-level report landing / hub page |
| Revenue | `RevenueController` | Country-level revenue table with currency breakdown |
| Statistic | `StatisticController` | Action-based statistic — currently exposes `potential-churn` endpoint |
| Telegram bot stats | `TgBotController` | Monthly usage statistics for the billing Telegram bot |
| View hub | `ViewController` | Shared view entry-point for report module pages |

---

## bonus · bonus and KPI system

Quarterly rollups, KPI tracking, mentor bonuses, and plan-vs-actual
for the billing sales team.

| Feature | Controller | Stub line |
|---------|-----------|-----------|
| Bonus tier 5 | `Bonus5Controller` | Vue-based bonus computation dashboard for tier-5 salespeople |
| Bonus tier 6 | `Bonus6Controller` | Variant bonus computation for tier-6 salespeople |
| KPI | `KpiController` | Vue KPI score view per salesperson for a given period |
| KPI leaderboard | `KpiLeaderController` | Ranked leaderboard of salesperson KPI scores |
| Mentor | `MentorController` | Monthly mentor bonus computation and review |
| Mentor KPI | `MentorKpiController` | Combined mentor + KPI report for senior salespeople |
| Plan sales | `PlanSalesController` | Per-salesperson sales plan CRUD and progress tracking |
| Quarters | `QuartersController` | AJAX-CRUD for quarterly period definitions used in bonus calc |
| Bonus report | `ReportController` | Aggregate bonus payout summary across all staff |
| Team | `TeamController` | Team composition and assignment for bonus calculation |

---

## setting · app settings and reference data

Application configuration and system reference tables.

| Feature | Controller | Stub line |
|---------|-----------|-----------|
| View hub | `ViewController` | Entry-point for the settings module |
| User management | `UserController` | Admin user CRUD — create, activate, assign roles |
| System log | `SystemLogController` | Filtered viewer of the `d0_system_log` audit trail |
| Classification | `ClassificationController` | CRUD for dealer classification tiers |
| City | `CityController` | Reference CRUD for city records |
| Country | `CountryController` | Reference CRUD for country records |
| Currency | `CurrencyController` | Reference CRUD for supported currencies |

---

## notification · in-app notifications

In-app notification bell. Provides API and UI for creating,
viewing, and sending notifications to dashboard users.

| Feature | Controller | Stub line |
|---------|-----------|-----------|
| Notification API | `ApiController` | JSON actions: get, create, edit, send, delete notifications |
| Notification view | `ViewController` | Renders the notification inbox and tally screens |

---

## sms · SMS packages

SMS credit packages that dealers can purchase; tracks bought
packages and available SMS package definitions.

| Feature | Controller | Stub line |
|---------|-----------|-----------|
| Bought SMS packages | `BoughtController` | Admin list of SMS packages purchased by dealers |
| SMS package catalog | `PackageController` | CRUD for SMS package definitions (credit count, price) |

---

## access · per-user permission grid

Manages the bit-flag permission grid (`CREATE=1, UPDATE=2, SHOW=4,
DELETE=8`) for billing users.

| Feature | Controller | Stub line |
|---------|-----------|-----------|
| User access | `UserController` | View and edit per-user operation permissions |

---

## directory · reference data API

Internal JSON API used by other modules to fetch lookup tables
(dealers, distributors, currencies, countries, cities, …).

| Feature | Controller | Stub line |
|---------|-----------|-----------|
| Directory API | `ApiController` | Exposes `get-dealers`, `get-distributors`, `get-currencies`, `get-countries`, `get-cities` endpoints |

---

## dbservice · DB maintenance utilities

Ad-hoc diagnostic queries, bulk data fixes, and migration helpers
for the operations team.

| Feature | Controller | Stub line |
|---------|-----------|-----------|
| DB service | `ServiceController` | Index + action-list view for running registered DB service operations |

---

## How this index is maintained

When you write or refresh a workflow page:

1. Replace the stub line in this catalog with a `[**Feature**](./<slug>.md)`
   link and a one-line summary in the same row.
2. Update `sidebars.js` (the *Feature workflows* category) so the new
   page shows up in the sidebar.
3. Re-run `python3 scripts/render-diagram-gallery.py` if you added a
   diagram to the page.
