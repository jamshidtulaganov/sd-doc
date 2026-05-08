---
sidebar_position: 1
title: Feature workflows · индекс
slug: /sd-cs/workflows
---

# Feature workflows — каталог

Это индекс каждой фичи (один отчёт, один pivot, одна
directory-страница, один API endpoint) в **sd-cs**. Каждая строка — один
контроллер; строки, выделенные **жирным**, имеют полную страницу workflow,
следующую [style guide](./style.md). Невыделенные строки — заглушки:
их фича существует в коде, но страница workflow ещё не написана.

Если вы новый сотрудник, начните здесь:

1. Прочитайте [обзор sd-cs](../overview.md) и
   [архитектуру](../architecture.md), чтобы изучить модель двух БД.
2. Прочитайте [style guide](./style.md), чтобы понимать, что значат страницы
   workflow.
3. Выберите страницу workflow ниже — или, если у вашей фичи только
   заглушка, набросайте её, используя skill `sd-cs-workflow-author` (живёт в
   `sd-docs/skills/sd-cs-workflow-author/SKILL.md`).

> **Источник**: каждая запись маппится на один файл контроллера в
> `sd-cs/protected/modules/<module>/controllers/` (или
> `sd-cs/protected/controllers/` для двух top-level контроллеров).

## Style и skill

| Страница | Когда читать |
|------|--------------|
| [Style guide](./style.md) | Перед написанием или ревью любой страницы фичи |
| `sd-docs/skills/sd-cs-workflow-author/SKILL.md` | Когда превращаете заглушку в полную страницу (путь к файлу, не на сайте документации) |

## report · single-screen отчёты

30 контроллеров — фильтр-форма, серверная агрегация по видимым
филиалам, грид + Excel-экспорт.

| Фича | Контроллер | Заглушка |
|---------|-----------|-----------|
| **[Sale](./report-sale.md)** | `SellController` | Агрегация по строкам заказов между филиалами, нарезанная по filial / region / territory / group |
| **[Inventory](./report-inventory.md)** | `InventoryController` | Счётчик размещения брендового оборудования + scan timeline |
| Agent | `AgentController` | Per-agent сводка sales / visit |
| Agent visit | `AgentVisitController` | Visit timeline per agent |
| AKB | `AkbController` | Active-customer-base отчёт (single-screen версия AKB pivot) |
| AKB category | `AkbCategoryController` | AKB, нарезанная по product category |
| Analyze AKB | `AnalyzeAkbController` | AKB drift-анализ между двумя периодами |
| Bonus | `BonusController` | Вычисленные бонусы агентов за период |
| Bonus sale | `BonusSaleController` | Продажи, влияющие на расчёт бонуса |
| Classification | `ClassificationController` | Roll-up классификации клиентов |
| Client data | `ClientDataController` | Client master export |
| Debt | `DebtController` | Outstanding receivables по client / agent |
| KPI | `KpiController` | KPI-метрики per agent / supervisor |
| Licence | `LicenceController` | Per-filial licence usage |
| Log | `LogController` | Audit-log viewer |
| Material | `MaterialController` | Marketing-material distribution отчёт |
| Movement | `MovementController` | Stock movement (in / out / transfer) |
| Neon | `NeonController` | Tenant-specific (Neon) отчёт |
| Nmedov | `NmedovController` | Tenant-specific (Nmedov) отчёт |
| OKB | `OkbController` | Total-customer-base отчёт |
| Photo | `PhotoController` | Photo report from agent visits |
| Pivot inventory | `PivotInventoryController` | Pivot-style inventory roll-up |
| Plan | `PlanController` | Plan vs actual на уровне филиала |
| Plan product | `PlanProductController` | Plan vs actual на уровне продукта |
| Planning | `PlanningController` | Plan-creation workflow |
| Purchase | `PurchaseController` | Purchase orders to suppliers |
| Sell | `SellController` | *(см. Sale выше)* |
| Shipper | `ShipperController` | Shipping/delivery roll-up |
| Stock | `StockController` | Stock-on-hand by filial / warehouse |
| Store | `StoreController` | Per-store sales |
| Summary bonus | `SummaryBonusController` | Bonus summary across periods |

## pivot · pivot-таблицы

16 контроллеров — тонкий сервер, NDJSON-style streaming, client-side
pivot UI, сохранённые конфигурации в `cs_pivot_config`.

| Фича | Контроллер | Заглушка |
|---------|-----------|-----------|
| **[AKB / OKB](./pivot-akb.md)** | `AkbController` | Соотношение AKB и OKB, нарезанное по любому разрешённому измерению |
| Consumption | `ConsumptionController` | Product consumption by client |
| Defect | `DefectController` | Defective-product returns |
| Discount | `DiscountController` | Discount usage per client / product |
| Expeditor | `ExpeditorController` | Expeditor performance |
| Lot report | `LotReportController` | Per-lot tracing |
| New discount | `NewDiscountController` | Newer discount-engine pivot |
| New sale | `NewSaleController` | Newer sales-engine pivot |
| Plan visit | `PlanVisitController` | Visit-plan vs actual |
| Purchase | `PurchaseController` | Purchase pivot |
| RFM | `RfmController` | RFM сегментация клиентов |
| Sale | `SaleController` | Sales pivot |
| Sale detail | `SaleDetailController` | Sales pivot at line-item level |
| SKU | `SkuController` | SKU-level sales |
| Transactions | `TransactionsController` | Cash/non-cash transaction pivot |
| User access | `UserAccessController` | Per-user access usage report |

## dashboard · top-level KPI

| Фича | Контроллер | Заглушка |
|---------|-----------|-----------|
| Daily | `DailyController` | Today's sales / visits / coverage at a glance |
| Supervayzer | `SupervayzerController` | Supervisor-scoped daily dashboard |

## directory · master data

54 контроллера — большинство являются CRUD-страницами поверх dealer-global
таблиц `b_demo`, гейтятся ключами доступа `directory.<entity>.*`.

| Группа | Контроллеры |
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

| Фича | Контроллер | Заглушка |
|---------|-----------|-----------|
| Access report | `AccessReportController` | Per-user access exposure для compliance audits |
| Billing | `BillingController` | Endpoint, потребляемый sd-billing |
| Cislink | `CislinkController` | Cislink integration endpoint |
| Isellmore v1 | `IsellmoreController` | Original Isellmore retailer integration |
| Isellmore v2 | `Isellmore2Controller` | Isellmore v2 |
| Isellmore v3 | `Isellmore3Controller` | Isellmore v3 |
| Isellmore v4 | `Isellmore4Controller` | Current Isellmore endpoint |
| Lianeks stock | `LianeksstockController` | Lianeks stock-feed |
| Operator | `OperatorController` | Telco-operator data ingest |
| Pradata | `PradataController` | Pradata integration |
| Telegram report | `TelegramReportController` | Daily reports пушатся через Telegram |
| V2 (multi-purpose) | `V2Controller` | Новый v2 read API; поддерживает выбор филиала по id / xml_id / prefix / domain / host |

## api3 · manager mobile

| Фича | Контроллер | Заглушка |
|---------|-----------|-----------|
| Manager | `ManagerController` | Manager-mobile-app endpoint |

## user · auth & access

| Фича | Контроллер | Заглушка |
|---------|-----------|-----------|
| Default | `DefaultController` | User listing и CRUD |
| Login | `LoginController` | Sign-in / sign-out |
| Role | `RoleController` | Role + access-key management |
| Crone | `CroneController` | User-related cron entrypoint |

## Top-level controllers

| Фича | Контроллер | Заглушка |
|---------|-----------|-----------|
| Site | `SiteController` | Home redirect, error page, generic access-check helper |
| Catalog | `CatalogController` | Public catalog landing page |

## Commands (CLI)

Запускаются через `php yiic`, не по HTTP. Сейчас только заглушки.

| Фича | Команда | Заглушка |
|---------|---------|-----------|
| Isellmore (v1 sync) | `IsellmoreCommand` | Pull-and-merge against Isellmore v1 |
| Isellmore v4 (sync) | `Isellmore4Command` | Pull-and-merge against Isellmore v4 |
| ISM | `IsmCommand` | ISM batch sync |

## Как поддерживается этот индекс

Когда вы пишете или обновляете страницу workflow:

1. Замените заглушку в этом каталоге на ссылку `[**Feature**](./<slug>.md)`
   и однострочную сводку в той же строке.
2. Обновите `sidebars.js` (категория *Feature workflows*), чтобы новая
   страница появилась в сайдбаре.
3. Перезапустите `python3 scripts/render-diagram-gallery.py`, если вы добавили
   диаграмму на страницу.
