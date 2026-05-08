---
sidebar_position: 3
title: Модули
---

# Модули sd-cs

## `user`

Авторизация и контроль доступа. Владеет HQ user-таблицей, иерархией ролей
и компонентом `AccessManager`.

## `directory`

Master / справочные данные, управляемые централизованно:

- Country-level каталог
- Бренды
- Сегменты
- Схемы скидок
- Cross-dealer mappings

## `report`

Самый большой модуль. Каждый отчёт — собственный контроллер. Примеры:

- `AgentController`, `AgentVisitController`
- `AkbController`, `AkbCategoryController`, `AnalyzeAkbController`,
  `OkbController`
- `BonusController`, `BonusSaleController`, `SummaryBonusController`
- `ClientDataController`
- `DebtController`
- `InventoryController`, `PivotInventoryController`
- `KpiController`
- `LicenceController`
- `LogController`
- `MaterialController`
- `MovementController`
- `PhotoController`
- `PlanController`, `PlanProductController`, `PlanningController`
- `PurchaseController`
- `SellController`, `ShipperController`
- `StockController`, `StoreController`
- `NeonController`, `NmedovController` (tenant-specific)

## `pivot`

Pivot-table отчёты — более тяжёлые агрегации, часто с кастомным UI:

- `SaleController`, `SaleDetailController`, `NewSaleController`
- `AkbController`
- `ConsumptionController`
- `DefectController`
- `DiscountController`, `NewDiscountController`
- `ExpeditorController`
- `LotReportController`
- `PlanVisitController`
- `PurchaseController`
- `RfmController`
- `SkuController`
- `TransactionsController`
- `UserAccessController`

## `dashboard`

Top-level KPI-плитки для HQ.

## `api`

Server-to-server endpoints, используемые внешними интеграторами или upstream
admin-инструментами:

- `OperatorController` — admin-утилиты (price fix, cleaner и т. п.).
- `AccessReportController`
- `BillingController`
- `CislinkController`
- `IsellmoreController` и `Isellmore[2|3|4]Controller`
- `LianeksstockController`
- `PradataController`
- `TelegramReportController`
- `V2Controller`

## `api3`

Сейчас только `ManagerController` — endpoint(s) для HQ-side mobile
приложения или ассистента.
