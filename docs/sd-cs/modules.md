---
sidebar_position: 3
title: Modules
---

# sd-cs modules

## `user`

Authentication and access control. Owns the HQ user table, role
hierarchy, and an `AccessManager` component.

## `directory`

Master / reference data managed centrally:

- Country-level catalog
- Brands
- Segments
- Discount schemes
- Cross-dealer mappings

## `report`

The largest module. Each report is its own controller. Examples:

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

Pivot-table reports — heavier aggregations, often with custom UI:

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

Top-level KPI tiles for HQ.

## `api`

Server-to-server endpoints used by external integrators or upstream
admin tools:

- `OperatorController` — admin utilities (price fix, cleaner, etc.).
- `AccessReportController`
- `BillingController`
- `CislinkController`
- `IsellmoreController` and `Isellmore[2|3|4]Controller`
- `LianeksstockController`
- `PradataController`
- `TelegramReportController`
- `V2Controller`

## `api3`

Currently `ManagerController` only — endpoint(s) for an HQ-side mobile
app or assistant.
