---
sidebar_position: 1
title: Funksional ish jarayonlari · indeks
slug: /sd-cs/workflows
---

# Funksional ish jarayonlari — katalog

Bu **sd-cs** dagi har bir xususiyat (bitta hisobot, bitta pivot, bitta
spravochnik sahifasi, bitta API endpoint) indeksi. Har bir satr bitta
kontroller; **qalin** havolali satrlarda [uslub qo'llanmasi](./style.md)
ga rioya qiluvchi to'liq ish jarayoni sahifasi mavjud. Havolasiz satrlar
stub'lar — ularning xususiyati kodda mavjud, ammo ish jarayoni sahifasi
hali yozilmagan.

Yangi xodim bo'lsangiz, bu yerdan boshlang:

1. [sd-cs umumiy ma'lumot](../overview.md) va
   [arxitektura](../architecture.md)'ni o'qing va ikki-DB modelini o'rganing.
2. [Uslub qo'llanmasi](./style.md)ni o'qing va ish jarayoni sahifalari
   nimani anglatishini bilib oling.
3. Quyidan ish jarayoni sahifasini tanlang — yoki sizga belgilangan
   xususiyat faqat stub bo'lsa, `sd-cs-workflow-author` skill'i yordamida
   uni qoralang (joylashuvi:
   `sd-docs/skills/sd-cs-workflow-author/SKILL.md`).

> **Manba**: har bir yozuv `sd-cs/protected/modules/<module>/controllers/`
> ostidagi bitta kontroller fayliga moslashadi (yoki ikki yuqori darajadagi
> kontroller uchun `sd-cs/protected/controllers/`).

## Uslub va skill

| Sahifa | Qachon o'qish kerak |
|------|--------------|
| [Uslub qo'llanmasi](./style.md) | Har qanday xususiyat sahifasini yozish yoki ko'rib chiqishdan oldin |
| `sd-docs/skills/sd-cs-workflow-author/SKILL.md` | Stub'ni to'liq sahifaga aylantirayotganda (fayl yo'li, hujjatlar saytida emas) |

## report · bir ekranli hisobotlar

30 ta kontroller — filtr formasi, ko'rinadigan filiallar bo'yicha
server tarafida agregatsiya, grid + Excel eksport.

| Xususiyat | Kontroller | Stub satri |
|---------|-----------|-----------|
| **[Sale](./report-sale.md)** | `SellController` | Filiallar bo'yicha buyurtma satri agregatsiyasi, filial / hudud / hudud / guruh bo'yicha bo'lingan |
| **[Inventory](./report-inventory.md)** | `InventoryController` | Brendlangan jihoz joylashuvi soni + skanerlash xronikasi |
| Agent | `AgentController` | Agent bo'yicha sotuvlar / tashriflar xulosasi |
| Agent visit | `AgentVisitController` | Agent bo'yicha tashrif xronikasi |
| AKB | `AkbController` | Faol mijoz bazasi hisoboti (AKB pivot'ning bir ekranli versiyasi) |
| AKB category | `AkbCategoryController` | Mahsulot kategoriyasi bo'yicha bo'lingan AKB |
| Analyze AKB | `AnalyzeAkbController` | Ikki davr o'rtasidagi AKB drift tahlili |
| Bonus | `BonusController` | Bir davr uchun hisoblangan agent bonuslari |
| Bonus sale | `BonusSaleController` | Bonus hisobiga hissa qo'shgan sotuvlar |
| Classification | `ClassificationController` | Mijoz tasnifi roll-up |
| Client data | `ClientDataController` | Mijoz master eksporti |
| Debt | `DebtController` | Mijoz / agent bo'yicha kutilayotgan debitorlik |
| KPI | `KpiController` | Agent / supervayzer bo'yicha KPI ko'rsatkichlari |
| Licence | `LicenceController` | Filial bo'yicha litsenziyadan foydalanish |
| Log | `LogController` | Audit-log ko'ruvchisi |
| Material | `MaterialController` | Marketing materiallari tarqatish hisoboti |
| Movement | `MovementController` | Stok harakati (kirim / chiqim / uzatish) |
| Neon | `NeonController` | Tenant-ga xos (Neon) hisobot |
| Nmedov | `NmedovController` | Tenant-ga xos (Nmedov) hisobot |
| OKB | `OkbController` | Umumiy mijoz bazasi hisoboti |
| Photo | `PhotoController` | Agent tashriflaridan foto hisobot |
| Pivot inventory | `PivotInventoryController` | Pivot uslubidagi inventarizatsiya roll-up |
| Plan | `PlanController` | Filial darajasida reja vs haqiqiy |
| Plan product | `PlanProductController` | Mahsulot darajasida reja vs haqiqiy |
| Planning | `PlanningController` | Reja-yaratish ish jarayoni |
| Purchase | `PurchaseController` | Yetkazib beruvchilarga xarid buyurtmalari |
| Sell | `SellController` | *(yuqorida Sale ga qarang)* |
| Shipper | `ShipperController` | Yetkazib berish roll-up |
| Stock | `StockController` | Filial / ombor bo'yicha stok holati |
| Store | `StoreController` | Do'kon bo'yicha sotuvlar |
| Summary bonus | `SummaryBonusController` | Davrlar bo'yicha bonus xulosasi |

## pivot · pivot jadvallar

16 ta kontroller — yupqa server, NDJSON-uslubidagi streaming,
mijoz tarafida pivot UI, `cs_pivot_config` da saqlangan konfiguratsiyalar.

| Xususiyat | Kontroller | Stub satri |
|---------|-----------|-----------|
| **[AKB / OKB](./pivot-akb.md)** | `AkbController` | Har qanday ruxsat etilgan o'lchov bo'yicha bo'lingan AKB va OKB nisbati |
| Consumption | `ConsumptionController` | Mijoz bo'yicha mahsulot iste'moli |
| Defect | `DefectController` | Defektli mahsulot qaytishlari |
| Discount | `DiscountController` | Mijoz / mahsulot bo'yicha chegirma ishlatilishi |
| Expeditor | `ExpeditorController` | Ekspeditor samaradorligi |
| Lot report | `LotReportController` | Lot bo'yicha kuzatuv |
| New discount | `NewDiscountController` | Yangiroq chegirma-mexanizm pivoti |
| New sale | `NewSaleController` | Yangiroq sotuv-mexanizm pivoti |
| Plan visit | `PlanVisitController` | Tashrif rejasi vs haqiqiy |
| Purchase | `PurchaseController` | Xarid pivoti |
| RFM | `RfmController` | Mijozlarning RFM segmentatsiyasi |
| Sale | `SaleController` | Sotuvlar pivoti |
| Sale detail | `SaleDetailController` | Satr darajasidagi sotuvlar pivoti |
| SKU | `SkuController` | SKU darajasidagi sotuvlar |
| Transactions | `TransactionsController` | Naqd/naqdsiz tranzaktsiya pivoti |
| User access | `UserAccessController` | Foydalanuvchi bo'yicha kirish ishlatilishi hisoboti |

## dashboard · yuqori darajadagi KPI'lar

| Xususiyat | Kontroller | Stub satri |
|---------|-----------|-----------|
| Daily | `DailyController` | Bugungi sotuvlar / tashriflar / qamrov bir nigohda |
| Supervayzer | `SupervayzerController` | Supervayzer bo'yicha kundalik dashboard |

## directory · master ma'lumotlar

54 ta kontroller — aksariyati `b_demo` diler-global jadvallari ustidagi
CRUD sahifalari, `directory.<entity>.*` kirish kalitlari bilan
boshqariladi.

| Guruh | Kontrollerlar |
|-------|-------------|
| Audit (ADT) | `AdtAuditController`, `AdtBrandController`, `AdtCommentController`, `AdtPackController`, `AdtParamsController`, `AdtPollController`, `AdtProducerController`, `AdtPropertyController`, `AdtSegmentController` |
| Mahsulotlar | `ProductController`, `ProductCategoryController`, `ProductSubcategoryController`, `ProductGroupController`, `ProductCatGroupController`, `ProductCompetitorController`, `ProductPropertiesController` |
| Mijozlar | `ClientCategoryController`, `ClientChannelController`, `ClientClassController`, `ClientTypeController` |
| Narxlash va promo | `PriceListController`, `PriceTypeController`, `BonusController`, `RoyaltyController`, `RlpBonusController`, `SkidkaController`, `SkidkaManualController` |
| Inventarizatsiya | `InventoryController`, `InventoryGroupController`, `InventoryTypeController` |
| Geografiya | `CountryController`, `RegionController`, `TerritoryController`, `TradeDirectionController` |
| Operatsiyalar | `ShipperController`, `RejectController`, `RejectDefectController`, `OrderCommentController`, `ClosedController`, `KpiTaskTemplateGroupController`, `TaskTypeController`, `PhotoReportCategoryController` |
| Rejalashtirish | `PlanController`, `PlanAgentController`, `PlanProductController` |
| Bilim bazasi | `KnowledgeCategoryController`, `KnowledgePostController` |
| Boshqa | `ApiController`, `CurrencyController`, `DealerController`, `GroupController`, `NotificationController`, `TaraController`, `TelegramBotController`, `UnitController` |

## api · server-server endpoint'lari

| Xususiyat | Kontroller | Stub satri |
|---------|-----------|-----------|
| Access report | `AccessReportController` | Compliance auditlari uchun foydalanuvchi bo'yicha kirish ekspozitsiyasi |
| Billing | `BillingController` | sd-billing iste'mol qiladigan endpoint |
| Cislink | `CislinkController` | Cislink integratsiya endpoint'i |
| Isellmore v1 | `IsellmoreController` | Asl Isellmore retailer integratsiyasi |
| Isellmore v2 | `Isellmore2Controller` | Isellmore v2 |
| Isellmore v3 | `Isellmore3Controller` | Isellmore v3 |
| Isellmore v4 | `Isellmore4Controller` | Hozirgi Isellmore endpoint |
| Lianeks stock | `LianeksstockController` | Lianeks stok-feed |
| Operator | `OperatorController` | Telekom operatori ma'lumot ingest |
| Pradata | `PradataController` | Pradata integratsiyasi |
| Telegram report | `TelegramReportController` | Telegram orqali yuborilgan kundalik hisobotlar |
| V2 (ko'p maqsadli) | `V2Controller` | Yangi v2 read API; id / xml_id / prefiks / domen / host bo'yicha filial tanlovini qo'llab-quvvatlaydi |

## api3 · menejer mobil

| Xususiyat | Kontroller | Stub satri |
|---------|-----------|-----------|
| Manager | `ManagerController` | Menejer mobil ilovasi endpoint'i |

## user · auth va kirish

| Xususiyat | Kontroller | Stub satri |
|---------|-----------|-----------|
| Default | `DefaultController` | Foydalanuvchi ro'yxati va CRUD |
| Login | `LoginController` | Kirish / chiqish |
| Role | `RoleController` | Rol + kirish kaliti boshqaruvi |
| Crone | `CroneController` | Foydalanuvchiga oid cron kirish nuqtasi |

## Yuqori darajadagi kontrollerlar

| Xususiyat | Kontroller | Stub satri |
|---------|-----------|-----------|
| Site | `SiteController` | Bosh sahifa redirect, error sahifasi, umumiy access-check yordamchisi |
| Catalog | `CatalogController` | Ommaviy katalog landing sahifasi |

## Buyruqlar (CLI)

Bular `php yiic` orqali ishlaydi, HTTP orqali emas. Hozircha faqat
stublar.

| Xususiyat | Buyruq | Stub satri |
|---------|---------|-----------|
| Isellmore (v1 sync) | `IsellmoreCommand` | Isellmore v1 ga qarshi pull-and-merge |
| Isellmore v4 (sync) | `Isellmore4Command` | Isellmore v4 ga qarshi pull-and-merge |
| ISM | `IsmCommand` | ISM batch sync |

## Bu indeks qanday saqlanadi

Ish jarayoni sahifasini yozganingizda yoki yangilaganingizda:

1. Bu katalogdagi stub satrini bir xil satrdagi `[**Feature**](./<slug>.md)`
   havola va bir qatorli xulosa bilan almashtiring.
2. `sidebars.js`'ni yangilang (*Feature workflows* kategoriyasi) shunda
   yangi sahifa yon panelda paydo bo'ladi.
3. Agar sahifaga diagramma qo'shgan bo'lsangiz,
   `python3 scripts/render-diagram-gallery.py`'ni qayta ishga tushiring.
