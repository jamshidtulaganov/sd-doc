---
sidebar_position: 3
title: Modullar
---

# sd-cs modullar

## `user`

Autentifikatsiya va kirish nazorati. HQ foydalanuvchi jadvali, rol
ierarxiyasi va `AccessManager` komponentini boshqaradi.

## `directory`

Markazlashtirilgan boshqariladigan asosiy / spravochnik ma'lumotlari:

- Mamlakat darajasidagi katalog
- Brendlar
- Segmentlar
- Chegirma sxemalari
- Dilerlararo mappinglar

## `report`

Eng katta modul. Har bir hisobot o'z kontrolleri. Misollar:

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
- `NeonController`, `NmedovController` (tenant-ga xos)

## `pivot`

Pivot-jadval hisobotlari — og'irroq agregatsiyalar, ko'pincha maxsus
UI bilan:

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

HQ uchun yuqori darajadagi KPI plitkalari.

## `api`

Tashqi integratorlar yoki yuqori oqim admin asboblari tomonidan
ishlatiladigan server-server endpoint'lari:

- `OperatorController` — admin yordamchi vositalar (narx tuzatish, tozalovchi va h.k.).
- `AccessReportController`
- `BillingController`
- `CislinkController`
- `IsellmoreController` va `Isellmore[2|3|4]Controller`
- `LianeksstockController`
- `PradataController`
- `TelegramReportController`
- `V2Controller`

## `api3`

Hozirda faqat `ManagerController` — HQ tarafi mobil ilovasi yoki
yordamchisi uchun endpoint(lar).
