---
sidebar_position: 1
title: Feature workflows · index
slug: /sd-cs/workflows
---

# Feature workflows — catalog

This is the index of every feature (one report, one pivot, one
directory page, one API endpoint) in **sd-cs**. Each row is one
controller; rows linked in **bold** have a full workflow page that
follows the [style guide](./style.md). Unlinked rows are stubs —
their feature exists in code, but the workflow page hasn't been
written yet.

If you're a new employee, start here:

1. Read [sd-cs overview](../overview.md) and
   [architecture](../architecture.md) to learn the two-DB model.
2. Read the [style guide](./style.md) so you know what the workflow
   pages mean.
3. Pick a workflow page below — or, if your assigned feature only has
   a stub, draft it using the `sd-cs-workflow-author` skill (lives at
   `sd-docs/skills/sd-cs-workflow-author/SKILL.md`).

> **Source**: every entry maps to one controller file under
> `sd-cs/protected/modules/<module>/controllers/` (or
> `sd-cs/protected/controllers/` for the two top-level controllers).

## Style and skill

| Page | When to read |
|------|--------------|
| [Style guide](./style.md) | Before writing or reviewing any feature page |
| `sd-docs/skills/sd-cs-workflow-author/SKILL.md` | When drafting a stub into a full page (file path, not in the docs site) |

## report · single-screen reports

30 controllers — filter form, server-side aggregation across visible
filials, grid + Excel export.

| Feature | Controller | Stub line |
|---------|-----------|-----------|
| **[Sale](./report-sale.md)** | `SellController` | Order-line aggregation across filials, sliced by filial / region / territory / group |
| **[Inventory](./report-inventory.md)** | `InventoryController` | Branded-equipment placement count + scan timeline |
| Agent | `AgentController` | Per-agent sales / visit summary |
| Agent visit | `AgentVisitController` | Visit timeline per agent |
| AKB | `AkbController` | Active-customer-base report (single-screen version of the AKB pivot) |
| AKB category | `AkbCategoryController` | AKB sliced by product category |
| Analyze AKB | `AnalyzeAkbController` | AKB drift analysis between two periods |
| Bonus | `BonusController` | Computed agent bonuses for a period |
| Bonus sale | `BonusSaleController` | Sales contributing to bonus computation |
| Classification | `ClassificationController` | Client classification roll-up |
| Client data | `ClientDataController` | Client master export |
| Debt | `DebtController` | Outstanding receivables by client / agent |
| KPI | `KpiController` | KPI metrics per agent / supervisor |
| Licence | `LicenceController` | Per-filial licence usage |
| Log | `LogController` | Audit-log viewer |
| Material | `MaterialController` | Marketing-material distribution report |
| Movement | `MovementController` | Stock movement (in / out / transfer) |
| Neon | `NeonController` | Tenant-specific (Neon) report |
| Nmedov | `NmedovController` | Tenant-specific (Nmedov) report |
| OKB | `OkbController` | Total-customer-base report |
| Photo | `PhotoController` | Photo report from agent visits |
| Pivot inventory | `PivotInventoryController` | Pivot-style inventory roll-up |
| Plan | `PlanController` | Plan vs actual at the filial level |
| Plan product | `PlanProductController` | Plan vs actual at the product level |
| Planning | `PlanningController` | Plan-creation workflow |
| Purchase | `PurchaseController` | Purchase orders to suppliers |
| Sell | `SellController` | *(see Sale above)* |
| Shipper | `ShipperController` | Shipping/delivery roll-up |
| Stock | `StockController` | Stock-on-hand by filial / warehouse |
| Store | `StoreController` | Per-store sales |
| Summary bonus | `SummaryBonusController` | Bonus summary across periods |

## pivot · pivot tables

16 controllers — thin server, NDJSON-style streaming, client-side
pivot UI, saved configurations in `cs_pivot_config`.

| Feature | Controller | Stub line |
|---------|-----------|-----------|
| **[AKB / OKB](./pivot-akb.md)** | `AkbController` | AKB and OKB ratio sliced by any allowed dimension |
| Consumption | `ConsumptionController` | Product consumption by client |
| Defect | `DefectController` | Defective-product returns |
| Discount | `DiscountController` | Discount usage per client / product |
| Expeditor | `ExpeditorController` | Expeditor performance |
| Lot report | `LotReportController` | Per-lot tracing |
| New discount | `NewDiscountController` | Newer discount-engine pivot |
| New sale | `NewSaleController` | Newer sales-engine pivot |
| Plan visit | `PlanVisitController` | Visit-plan vs actual |
| Purchase | `PurchaseController` | Purchase pivot |
| RFM | `RfmController` | RFM segmentation of clients |
| Sale | `SaleController` | Sales pivot |
| Sale detail | `SaleDetailController` | Sales pivot at line-item level |
| SKU | `SkuController` | SKU-level sales |
| Transactions | `TransactionsController` | Cash/non-cash transaction pivot |
| User access | `UserAccessController` | Per-user access usage report |

## dashboard · top-level KPIs

| Feature | Controller | Stub line |
|---------|-----------|-----------|
| Daily | `DailyController` | Today's sales / visits / coverage at a glance |
| Supervayzer | `SupervayzerController` | Supervisor-scoped daily dashboard |

## directory · master data

54 controllers — most are CRUD pages over `b_demo` dealer-global
tables, gated by `directory.<entity>.*` access keys.

| Group | Controllers |
|-------|-------------|
| Audit (ADT) | `AdtAuditController`, `AdtBrandController`, `AdtCommentController`, `AdtPackController`, `AdtParamsController`, `AdtPollController`, `AdtProducerController`, `AdtPropertyController`, `AdtSegmentController` |
| Products | `ProductController`, `ProductCategoryController`, `ProductSubcategoryController`, `ProductGroupController`, `ProductCatGroupController`, `ProductCompetitorController`, `ProductPropertiesController` |
| Clients | `ClientCategoryController`, `ClientChannelController`, `ClientClassController`, `ClientTypeController` |
| Pricing & promo | `PriceListController`, `PriceTypeController`, `BonusController`, `RoyaltyController`, `RlpBonusController`, `SkidkaController`, `SkidkaManualController` |
| Inventory | `InventoryController`, `InventoryGroupController`, `InventoryTypeController` |
| Geography | `CountryController`, `RegionController`, `TerritoryController`, `TradeDirectionController` |
| Operations | `ShipperController`, `RejectController`, `RejectDefectController`, `OrderCommentController`, `ClosedController`, `KpiTaskTemplateGroupController`, `TaskTypeController`, `PhotoReportCategoryController` |
| Planning | `PlanController`, `PlanAgentController`, `PlanProductController` |
| Knowledge base | `KnowledgeCategoryController`, `KnowledgePostController` |
| Misc | `ApiController`, `CurrencyController`, `DealerController`, `GroupController`, `NotificationController`, `TaraController`, `TelegramBotController`, `UnitController` |

## api · server-to-server endpoints

| Feature | Controller | Stub line |
|---------|-----------|-----------|
| Access report | `AccessReportController` | Per-user access exposure for compliance audits |
| Billing | `BillingController` | Endpoint consumed by sd-billing |
| Cislink | `CislinkController` | Cislink integration endpoint |
| Isellmore v1 | `IsellmoreController` | Original Isellmore retailer integration |
| Isellmore v2 | `Isellmore2Controller` | Isellmore v2 |
| Isellmore v3 | `Isellmore3Controller` | Isellmore v3 |
| Isellmore v4 | `Isellmore4Controller` | Current Isellmore endpoint |
| Lianeks stock | `LianeksstockController` | Lianeks stock-feed |
| Operator | `OperatorController` | Telco-operator data ingest |
| Pradata | `PradataController` | Pradata integration |
| Telegram report | `TelegramReportController` | Daily reports pushed via Telegram |
| V2 (multi-purpose) | `V2Controller` | New v2 read API; supports filial selection by id / xml_id / prefix / domain / host |

## api3 · manager mobile

| Feature | Controller | Stub line |
|---------|-----------|-----------|
| Manager | `ManagerController` | Manager-mobile-app endpoint |

## user · auth & access

| Feature | Controller | Stub line |
|---------|-----------|-----------|
| Default | `DefaultController` | User listing and CRUD |
| Login | `LoginController` | Sign-in / sign-out |
| Role | `RoleController` | Role + access-key management |
| Crone | `CroneController` | User-related cron entrypoint |

## Top-level controllers

| Feature | Controller | Stub line |
|---------|-----------|-----------|
| Site | `SiteController` | Home redirect, error page, generic access-check helper |
| Catalog | `CatalogController` | Public catalog landing page |

## Commands (CLI)

These run via `php yiic`, not over HTTP. Stubs only for now.

| Feature | Command | Stub line |
|---------|---------|-----------|
| Isellmore (v1 sync) | `IsellmoreCommand` | Pull-and-merge against Isellmore v1 |
| Isellmore v4 (sync) | `Isellmore4Command` | Pull-and-merge against Isellmore v4 |
| ISM | `IsmCommand` | ISM batch sync |

## How this index is maintained

When you write or refresh a workflow page:

1. Replace the stub line in this catalog with a `[**Feature**](./<slug>.md)`
   link and a one-line summary in the same row.
2. Update `sidebars.js` (the *Feature workflows* category) so the new
   page shows up in the sidebar.
3. Re-run `python3 scripts/render-diagram-gallery.py` if you added a
   diagram to the page.
