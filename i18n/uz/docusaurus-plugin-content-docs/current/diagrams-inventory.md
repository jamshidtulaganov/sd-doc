---
sidebar_position: 99
title: Diagramma inventarizatsiyasi va prioritetlash
audience: Tech leadlar, PM, hujjat maintainerlari
summary: Mermaid diagrammasi uchun nomzod bo'lgan uchta loyiha bo'ylab har bir workflow / xususiyat oqimining kataloggi, P0/P1/P2 ga prioritet qilingan. Mualliflik partiyalarini rejalashtirish uchun ishlating.
---

# Diagramma inventarizatsiyasi va prioritetlash

Uchta reponing controller-walk i va mavjud hujjat sahifalaridan
yaratilgan. Raqamlar bugungi haqiqatni aks ettiradi, intilishni emas.

Heuristik: harakat faqat **workflow shakli** ga ega bo'lganda nomzod
qator bo'ladi — bir nechta jadval yozuvlari, status o'tishlari, navbat
yoki tashqi-chaqiruv jo'natish, imzo tekshirish, geofence tekshiruvlari,
loyihalararo round-trip lar. Sof ro'yxat/ko'rinish/CRUD endpointlari va
forma handlerlari chiqariladi.

## Xulosa

- **sd-main** — 95 nomzod oqim (28 P0, 41 P1, 26 P2)
- **sd-billing** — 32 nomzod oqim (12 P0, 12 P1, 8 P2)
- **sd-cs** — 18 nomzod oqim (5 P0, 8 P1, 5 P2)
- **Loyihalararo integratsiya oqimlari** — 10 oqim (10 P0)
- **Jami nomzodlar: 155**, ulardan 13 tasi hujjatlarda allaqachon
  Mermaid blokiga ega.

## Allaqachon bajarilgan

Hujjatlarda biror joyda inline Mermaid blokiga ega oqimlar.

| # | Oqim | Manba hujjat | Izohlar |
|---|------|--------------|---------|
| 1 | Tasdiqlash workflow (mijoz) | `docs/modules/clients.md` | Shuningdek `diagrams/sd-main-features.md#d-01` da |
| 2 | Buyurtma eksporti (1C / Didox / Faktura) | `docs/modules/integration.md` | `diagrams/sd-main-features.md#d-02` |
| 3 | Hisobot ishi + Excel eksporti | `docs/modules/report.md` | `diagrams/sd-main-features.md#d-03` |
| 4 | To'lov tasdig'i | `docs/modules/payment.md` | `diagrams/sd-main-features.md#d-04`; oldin/keyin juftlik `diagrams/workflows.md#d-01` da |
| 5 | SMS jo'natish (sequence) | `docs/modules/sms.md` | `diagrams/sd-main-features.md#d-05` |
| 6 | Inventarizatsiya | `docs/modules/inventory.md` | `diagrams/sd-main-features.md#d-06` |
| 7 | Audit jo'natish | `docs/modules/audit-adt.md` | `diagrams/sd-main-features.md#d-07` |
| 8 | Tovar qabul qilish | `docs/modules/warehouse.md` | `diagrams/sd-main-features.md#d-08` |
| 9 | Onlayn buyurtma joylashtirish | `docs/modules/onlineOrder.md` | `diagrams/sd-main-features.md#d-09` |
| 10 | Buyurtma status mashinasi | `docs/modules/orders.md` | `diagrams/sd-main-features.md#d-10` |
| 11 | Buyurtma yaratish (sequence) | `docs/modules/orders.md` | `diagrams/sd-main-features.md#d-11` |
| 12 | Tashrif + GPS geofence | `docs/modules/gps.md` (havola) | `diagrams/sd-main-features.md#d-12` |
| 13 | Defekt + zaxiraga qaytarish | `docs/modules/stock.md` | `diagrams/sd-main-features.md#d-13` |
| 14 | Obuna / litsenziya | `docs/sd-billing/subscription-flow.md` | `diagrams/sd-billing.md#d-04` |
| 15 | Settlement (cron) | `docs/sd-billing/cron-and-settlement.md` | `diagrams/sd-billing.md#d-05` |
| 16 | Eslatmalar cron (sequence) | `docs/sd-billing/cron-and-settlement.md` | `diagrams/sd-billing.md#d-06` |
| 17 | Click oqimi (sequence) | `docs/sd-billing/payment-gateways.md` | `diagrams/sd-billing.md#d-07` |
| 18 | Payme oqimi (sequence) | `docs/sd-billing/payment-gateways.md` | `diagrams/sd-billing.md#d-08` |
| 19 | Yangi-diler onboarding (HQ) | `docs/sd-cs/sd-main-integration.md` | `diagrams/sd-cs.md#d-02` |
| 20 | Dilerlar bo'ylab hisobot arxitekturasi | `docs/sd-cs/sd-main-integration.md` | `diagrams/sd-cs.md#d-01` |

(Yuqoridagi master hisob har bir modul sahifa ichida allaqachon kelgan
diagrammalarga ega 13 ta *unikal oqim* ni ko'rsatadi; yuqoridagi
qolganlari turli birlashma sahifalarida bir xil oqimning
takrorlanishlari yoki xususiyat oqimlari emas, balki arxitektura
diagrammalari.)

## sd-main inventarizatsiyasi

### `orders`

sd-main dagi yagona eng muhim domen. Asosan P0.

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Buyurtma yaratish (web) | `AddOrderController::actionCreate` | ha — orders.md | P0 | Operator buyurtmani quradi, narxlar/cheklovlar tekshiriladi, Order + OrderProduct yoziladi, status NEW |
| Buyurtma yaratish (mobil) | `api3/OrderController::actionPost` | qisman — orders.md | P0 | Agent tashrif vaqtida buyurtma jo'natadi; geofence + cheklov tekshiruvi; web bilan bir xil quvur |
| Buyurtma yaratish (onlayn B2B) | `api4/OrderController` + `onlineOrder/OrderController` | ha — onlineOrder.md | P0 | Mijoz api4 orqali o'z-o'ziga xizmat, ixtiyoriy onlayn-to'lov yo'naltirish |
| Buyurtma qoralama avtosaqlash (mobil) | `api3/OrderController::actionPostDraft` / `actionGetDraft` | yo'q | P1 | Mobil qoralamani serverga saqlaydi, shunda ilovani yopilganda ham qoladi |
| Buyurtma tahrirlash | `EditController::actionDetails` / `actionStatus` / `actionSubstatus` / `actionDateLoad` | yo'q | P1 | Operator qatorlar, sanalar, ekspeditorni tahrirlaydi; OrderStatusHistory ga loglaydi |
| Buyurtma status o'tishi | `OrderStateController::actionChange` | ha — orders.md state machine | P0 | Status yon ta'sirlar bilan ko'chadi: stock zaxira / bo'shatish / eksport trigger |
| Buyurtma status partiya o'tishi | `EditController::actionStatusBatch` | yo'q | P1 | Qator boshiga muvaffaqiyatsizlik bilan ommaviy status o'zgarishi |
| Buyurtmani bekor qilish | `OrderStateController::actionCancelState` | yo'q | P1 | Jo'natilgandan keyin bekor qilish — qayta zaxiralash va xabar berish |
| Buyurtmani rad etish + sharh | `OrderStateController::actionRejectComment` | yo'q | P1 | Yetkazib berishda butun-buyurtma rad etish; sabab olinadi |
| Yetkazib berishda defekt | `EditController::actionPartialDefect` + `api3/DefectController::actionPost` | ha — stock.md | P0 | Foto dalillar bilan qator boshiga defekt, zaxiraga qaytarish |
| Buyurtmani almashtirish | `OrderReplaceController` + `RecoveryOrderController::actionReplace` | yo'q | P1 | Yetkazib berilgan buyurtmani almashtirish (masalan, noto'g'ri mahsulot), tarixni saqlash |
| Buyurtma tiklash / tiklash | `RecoveryOrderController::actionCreate` / `actionUpdate` | yo'q | P2 | O'chirilgan buyurtmani audit izlari bilan tiklash |
| Buyurtma Excel import | `ImportOrderController` | yo'q | P1 | CSV/XLSX partiyali buyurtma yaratish; qator boshiga validatsiya |
| Buyurtma chop etish (faktura) | `InvoiceController` | yo'q | P2 | Shablonli faktura/waybill ni render qilish; chop etish hodisasini loglaydi |
| Faktura.uz UZ EDI jo'natish | `FakturaUZController` | ha — integration.md | P0 | Loaded/Delivered da imzolangan e-faktura jo'natish; javobni saqlash |
| Ekspeditor yuk rejalashtirish | `ExpeditorLoadNeoController` | yo'q | P1 | Ekspeditorning kunlik yuki uchun buyurtmalarni guruhlash |
| Bonus buyurtma bog'lanishi | `OrderBonusController` | yo'q | P1 | Promo bonus buyurtmalari BONUS_ORDER_ID orqali qaytib bog'lanadi |
| Filiallar o'rtasida ko'chish | `OrderStateController::actionMovementFilials` | yo'q | P1 | Buyurtmaning filiallararo ko'chirilishi |
| Sotib olishni soddalashtirish | `OrderStateController::actionMakePurchase` | yo'q | P2 | Buyurtmani xarid hujjatiga aylantirish |
| Tozalash / arxivlash | `CleanOrdersController` | yo'q | P2 | Eskirgan buyurtmalarning ommaviy arxivlanishi; faqat admin |

### `clients`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Mijoz tasdig'i (Pending → Active) | `ApprovalController::actionSave` | ha — clients.md | P0 | Menejer kutilayotgan mijozni ko'rib chiqadi, tasdiqlaydi / rad etadi, ixtiyoriy 1C eksporti |
| Maydonda yaratilgan mijoz (mobil) | `api3/ClientController` | yo'q | P0 | Agent tashrif vaqtida yangi mijozni jo'natadi; ClientPending ga boradi |
| Mijoz revizyasi (qarzni yarashtirish) | `ReviseController` | yo'q | P1 | Mijoz qarzlarini to'lovlarga qarshi yarashtiradi; yarashish yozuvini yozadi |
| Mijoz tranzaksiyalari ledger | `TransactionController` | yo'q | P1 | Mijoz boshiga ishlayotgan ledger (buyurtmalar, to'lovlar, qaytishlar) |
| Tara hujjatlari (qaytariladigan qadoq) | `TaraController` / `TaradocController` | yo'q | P1 | Tara hujjati hayotiy davri va mijoz boshiga tara balansi |
| Stock-bazani boshqarish | `StockBaseController` | yo'q | P2 | Konsignatsiya inventari uchun mijoz boshiga stock bazasi |
| Mijoz hisoblash (rollup) | `ComputationController` | yo'q | P2 | Aggregat maydonlarni qayta hisoblash (qarz, oxirgi tashrif) |
| Mijoz SMS jo'natish | `SendingSmsController` | yo'q | P2 | Mijoz kogortasiga ommaviy SMS yuborish |
| Mijoz boshiga inventarizatsiya | `InventorizationController` | yo'q | P1 | Konsignatsiya tovarlarida mijoz darajasidagi inventarizatsiya |
| Yetkazuvchi moliyasi | `ShipperFinansController` | yo'q | P2 | Yetkazuvchi tomonidan yarashish |
| Kontragent | `ContragentController` | yo'q | P2 | Ota/bog'liq kontragentlarni boshqarish |

### `agents`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Agent CRUD + faollashtirish | `AgentController` | yo'q | P1 | Agentni yaratish/tahrirlash/o'chirish; Car, KPI, marshrutga kaskadlanadi |
| Agent tashrif (mobil, geofence bilan) | `VisitingController` + `api3/VisitController::actionPost` | ha — sd-main-features.md#d-12 | P0 | Agent dunyokda check-in qiladi; geofence tekshiriladi; tashrif qatori yoziladi |
| Tashrif tasdig'i (post-check) | `api3/VisitController::actionPostCheck` | yo'q | P0 | Tashrif ma'lumotlarini sync dan keyin server tomonidan qayta tekshirish |
| Kunlik KPI hisoblash | `KpiNewController` | yo'q | P1 | Kun uchun agent boshiga reja-vs-haqiqat rollupi |
| Cheklov ijrosi (kredit / chegirma) | `LimitController` + `LimitReportController` | yo'q | P0 | Buyurtmani agent kredit va chegirma cheklovlariga qarshi tekshirish |
| Qabul qilish (naqd qabul) | `ReceptionController` | yo'q | P1 | Agent tomondagi naqd qabul qilish; to'lov quvuriga ozuqa beradi |
| Vazifa tayinlash | `TaskNewController` | yo'q | P1 | Vazifalarni (qo'ng'iroqlar/tashriflar) kun uchun agentga tayinlash |
| Supervayzer dashboardi | `SupervayzerController` | yo'q | P1 | Supervayzer jamoa unumdorligini kuzatadi |

### `audit` + `adt`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Audit jo'natish (mobil) | `audit/PollResultController` + `api3/Auditor*` | ha — audit-adt.md | P0 | Agent so'rovnomaga javob beradi, facing ni belgilaydi, fotolar yuklanadi, ball hisoblanadi |
| Foto hisoboti jo'natish | `PhotoReportController` | yo'q | P1 | Faqat-foto audit; toifalanadi, yuklanadi, indekslanadi |
| Audit ta'rifi (forma quruvchisi) | `audit/PollController` | yo'q | P1 | So'rovnoma savollari, variantlari, target SKU larni aniqlash |
| Auditor oylik hisoboti | `adt/MonthlyController` | yo'q | P2 | Auditor boshiga oylik muvofiqlik balli |
| Storecheck (narx + facing) | `audit/FacingController` + `adt/StoreCheckController` | yo'q | P1 | SKU boshiga javon tekshiruvi, narx olish |
| ADT so'rovnoma sozlash | `adt/AdtPollController` + `adt/PollController` | yo'q | P1 | Sozlanadigan kengaytirilgan audit so'rovnomasi ta'rifi |
| ADT tashrif kiritish | `adt/VisitController::actionUpdatePoll` / `actionUpdateAudit` | yo'q | P1 | Mobil tomondagi audit jo'natishlarini ADT jadvallariga kiritish |
| ADT foydalanuvchi tayinlash | `adt/AdtAuditController::actionSetUsers` | yo'q | P2 | Auditorlarni ma'lum audit ta'rifiga qadash |
| Muvofiqlik balli rollupi | `audit/DashboardController` | yo'q | P2 | Auditlar bo'ylab dunyokpa boshiga aggregat ball |

### `inventory`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Inventarizatsiya hujjatini yaratish | `AddController::actionIndex` / `actionBatch` | ha — inventory.md | P0 | Menejer inventarizatsiya hujjatini ochadi, ixtiyoriy partiya (multi-ombor) |
| Mobil shtrix-kod skanerlash | `ScanController` + `api3/InventoryController::actionSet` | qisman — inventory.md | P0 | Operator SKU ni skanerlaydi; skan boshiga qator + foto |
| Yarashish (deltalar) | `EditController::actionInventory` | yo'q | P0 | Stock ga qarshi deltalarni hisoblash; tuzatish hujjatini ishlab chiqarish |
| Tasdiqlash + tuzatishlarni postlash | `StatusController::actionEdit` / `actionBulkEdit` | yo'q | P0 | Menejer tasdiqlaydi; deltalar stockga postlanadi |
| Element boshiga foto dalil | `PhotoController::actionAdd` | yo'q | P1 | Buzilgan/kam elementlar uchun fotolar biriktirish |
| Ommaviy o'chirish (eskirgan hujjatlar) | `DeleteController::actionMultiple` | yo'q | P2 | Admin eskirgan inventarizatsiyalarni ommaviy o'chiradi |

### `warehouse`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Tovar qabul qilish (web) | `AddController` | ha — warehouse.md | P0 | Hujjat qo'shish; stock += son; har bir qabul uchun integration log |
| Stock o'tkazish (omborlar o'rtasida) | `ExchangeController` | yo'q | P0 | Bitta filial ichida omborlar o'rtasida ko'chish; atomik stock op |
| Filiallararo ko'chish | `FilialMovementController` | yo'q | P0 | Filiallar o'rtasida ikki-oyoqli ko'chish hujjati |
| Buyurtma uchun pick & pack | `EditController` | yo'q | P1 | Bajarish uchun qatorlarni zaxiralash va yuklash |
| Qabul API kiritish | `ApiController` | yo'q | P1 | Tashqi 1C / supplier tizim qabullarni pushlaydi |

### `stock`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Qaytarish qo'shish | `AddReturnController` | ha — stock.md | P0 | Defekt / rad etishdan zaxiraga qaytarish; StockService dan foydalanadi |
| Sotib olish / xarid | `BuyController` + `PurchaseController` | yo'q | P1 | Suppliyerdan kelayotgan xarid; stock += son |
| Do'konlar o'rtasida almashish | `ExchangeStoresController` | yo'q | P1 | Chakana do'konlar o'rtasida stock ko'chish |
| Excretion (hisobdan chiqarish) | `ExcretionController` | yo'q | P1 | Sabab bilan zarar / o'g'irlikning doimiy olib tashlanishi |
| VS exchange (van-sales) | `VsExchangeController` + `VsExchangeDownloadController` | yo'q | P1 | Van-sales stock almashish hujjati |
| VS qaytarish | `VsReturnController` + `VsReturnDownloadController` | yo'q | P1 | Van-sales omborga qaytarish |
| Do'kon korrektor | `StoreCorrectorController` | yo'q | P2 | Audit izi bilan qo'lda stock korrektsiyasi |
| Stock zaxira atomik op | `StockService::reserveForOrder` (buyurtma quvuridan chaqiriladi) | yo'q | P0 | Bitta tranzaksiyada available kamaytirish + reserved oshirish atomik |
| Plan mahsulot | `PlanProductController` | yo'q | P2 | Mahsulot boshiga stock rejasi vs haqiqat |

### `payment` + `pay`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| To'lov yozuvi + kassir tasdig'i | `payment/ApprovalController::actionSave` | ha — payment.md | P0 | Agent to'lovni qayd qiladi, kassir tasdiqlaydi/rad etadi, qarz + kassaga qo'llaniladi |
| To'lovni boshqa buyurtmaga qayta tayinlash | `payment/ApprovalController::actionUnlinkOrder` | yo'q | P1 | Operator noto'g'ri joylashtirilgan to'lovni qayta yo'naltiradi |
| To'lov yetkazib berishni yangilash | `payment/ApprovalController::actionUpdatePaymentDeliver` | yo'q | P1 | To'lov qaysi yetkazib berishga bog'langanligini belgilash |
| Click web-pay | `pay/ClickController::actionIndex` | yo'q | P0 | Mijoz Click orqali ilova ichida to'laydi; HMAC tekshirish; Payment kiritish |
| Payme web-pay | `pay/PaymeController::actionIndex` | yo'q | P0 | Mijoz Payme JSON-RPC orqali to'laydi |
| Apelsin web-pay | `pay/ApelsinController::actionIndex` | yo'q | P1 | Mijoz Apelsin gateway orqali to'laydi |
| api4 onlayn to'lov | `api4/OnlinePaymentController` | yo'q | P0 | B2B portal onlayn to'lov yo'naltirishni boshlaydi |

### `finans`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Kassa ko'chirish (pulni ko'chirish) | `CashboxDisplacementController::actionSave` | yo'q | P0 | Kassalar o'rtasida pulni ko'chirish; double-entry |
| Kassa ko'chirishni bekor qilish | `CashboxDisplacementController::actionCancelDisplacement` | yo'q | P1 | Kassa ko'chirishni qaytarish; offset yozuvi yaratish |
| To'lov o'tkazish (qayta tayinlash) | `PaymentTransferController::actionCreate` / `actionChangeStatus` | yo'q | P0 | Tasdiqlash bilan to'lovni boshqa kassa/buyurtmaga qayta tayinlash |
| P&L hisoblash | `PnlController` (`actionGetConsumptions`, `actionGetBadDebts`) | yo'q | P1 | Davr boshiga daromad / xarajat / marja |
| Pivot P&L hisoblash + saqlash | `PivotPnlController::actionSaveReport` / `actionLoadByProduct` | yo'q | P1 | P&L ni kesib-kesib; hisobot-shablonni saqlash |
| Agent P&L | `AgentPnlController::actionLoad` | yo'q | P1 | Agent boshiga foyda rollupi |
| Iste'mol (xarajat) yozish | `ConsumptionController::actionCredit` / `actionSaveReport` | yo'q | P1 | Operatsion xarajat kiritish + hisobot |

### `gps` / `gps2` / `gps3`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| GPS namunasi kiritish | `gps/BackendController::actionLast` / `api3/GpsController::actionIndex` | yo'q | P0 | Mobil GPS namunalarini ~30 s da postlaydi; saqlash + indekslash |
| Offline GPS qayta o'ynash | `api3/GpsController::actionOffline` | yo'q | P1 | Qayta ulanishdan keyin buferlangan namunalarning ommaviy qayta o'ynashi |
| Tashrif geofence tekshirish | `gps/OrdersGpsController` (Visit tomonidan iste'mol qilinadi) | ha — sd-main-features.md#d-12 | P0 | Tashrif boshiga lat/lng mijoz radiusi ichida ekanligini tekshirish |
| Jonli kuzatish (web) | `gps/MonitoringController` / `gps2/MonitoringController` / `gps3/ClientController::actionFetchVisits` | yo'q | P1 | Filialdagi agentlarning real vaqtli xaritasi |
| Sayohat qayta o'ynash | `gps/TrackingController::actionRoute` | yo'q | P1 | Agentning kunini xaritada qayta o'ynash |
| Zonadan tashqari rad etish | `gps/BackendController::actionReject` | yo'q | P0 | Radius dan tashqari tashriflarni ko'rib chiqish uchun belgilash + rad etish |
| Marshrut direktivasi (gps3) | `gps3/DirectiveController::actionDirectivePreloader` | yo'q | P2 | gps3 ko'rinishiga marshrut yangilanishlarini push qilish |

### `integration`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Buyurtma 1C / Didox / Faktura ga eksport | `ExportController` (`ExportInvoiceJob` orqali) | ha — integration.md | P0 | Loaded/Delivered da provayder boshiga ish jo'natish; qayta urinishda backoff |
| Didox e-invoice jo'natish | `DidoxController` | yo'q | P0 | E-invoice ni imzolash + jo'natish; Didox javobini saqlash |
| Faktura.uz e-VAT jo'natish | `FakturaController` | yo'q | P0 | EIMZO imzolash + jo'natish; holatini olish |
| TraceIQ kiruvchi | `TraceiqController::actionGetPurchases` / `actionGetPurchaseDetails` | yo'q | P1 | TraceIQ dan trace-purchase ma'lumotlarini tortish; upsert |
| Generik 1C katalog import | `ImportController` | yo'q | P0 | Mahsulot/kategoriya/narx kelishi; localga upsert |
| Idokon import ko'rinishi | `ViewController::actionIdokon` | yo'q | P2 | Idokon-source yozuvlarini ko'rib chiqish |
| Integration log brauzeri | `ListController` / `GetController` | yo'q | P2 | Muvaffaqiyatsiz ishlarni ko'rib chiqish va qayta-trigger qilish UI |

### `api` (sd-main chiqaruvchi proksilari + 1C ko'priklari)

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Paketlarni sotib olish (sd-billing ga chaqiruv) | `api/LicenseController::actionBuyPackages` | qisman — sd-billing/subscription-flow.md | P0 | sd-main paketni sotib olishni sd-billing ga postlaydi; obunani oladi |
| Litsenziyani o'chirish | `api/LicenseController::actionDelete` | yo'q | P0 | sd-billing sd-main ga litsenziyani bekor qilishni xabar beradi |
| Litsenziya to'lash | `api/LicenseController::actionPay` | yo'q | P0 | Qo'lda litsenziya to'lashning fallback i |
| Litsenziyani almashtirish | `api/LicenseController::actionExchange` | yo'q | P1 | Balans ichida bir paketni boshqasiga almashtirish |
| 1C JSON buyurtma kiritish | `api/Json1CController::actionGetOrders` | yo'q | P1 | 1C JSON shaklida buyurtmalarni tortadi |
| Mef1c mahsulot/mijoz kiritish | `api/Mef1cController::actionSetProducts` / `actionSetClients` / `actionSetPrices` | yo'q | P1 | Mef1c-tomondan katalog deltalarini push qilish |
| Mef1c moliya pushi | `api/Mef1cController::actionSetFinans` | yo'q | P1 | 1C dan moliyaviy yozuvlarni push qilish |
| Smartup buyurtmalar sync | `api/SmartUpController::actionSetOrders` / `actionGetOrders` | yo'q | P1 | Ikki tomonlama Smartup ERP buyurtma sync |
| Smartup auth | `api/SmartUpController::actionSaveAuth` / `actionRemoveAuth` | yo'q | P2 | Tenant boshiga Smartup hisobga olish ma'lumotlarini boshqarish |
| Web push ro'yxatga olish + jo'natish | `api/PushController::actionSave` / `actionSend` | yo'q | P1 | Service worker ni ro'yxatga olish; jo'natishni trigger qilish |
| Cron tashrif aggregatsiyasi | `api/CronVisitController::actionWrite` / `actionReWrite` | yo'q | P1 | Tashriflarning kunlik partiya aggregatsiyasi |
| Telegram bot webhook | `api/TelegramBotController::actionIndex` | yo'q | P1 | Kiruvchi Telegram yangilanishlarini boshqarish |
| Rejalashtirilgan SMS jo'natish (cron) | `api/ScheduledSmsController::actionSend` | yo'q | P1 | Rejalashtirilgan SMS partiyalarini jo'natish; yetkazilgan deb belgilash |
| Eslatma kiritish + ack | `api/NotificationController::actionAcquainted` | yo'q | P2 | Eslatmani ko'rilgan deb belgilash |

### `onlineOrder`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Portal orqali buyurtma berish | `onlineOrder/OrderController` + `api4/CreateController` | ha — onlineOrder.md | P0 | Mijoz savatni jo'natadi; standart buyurtma quvuridan o'tadi |
| Onlayn to'lov yo'naltirish | `onlineOrder/PaymentController` | yo'q | P0 | Onlayn to'lov uchun Click/Payme/Paynet ga topshirish |
| Telegram bot webhook | `onlineOrder/TelegramController` | yo'q | P1 | Mijoz Telegram orqali o'zaro ta'sirlashadi; bot uni buyurtmaga tarjima qiladi |
| Telegram WebApp host | `onlineOrder/WebAppController` + `WebappBotController` | yo'q | P1 | To'liq buyurtma berish uchun Telegram ichidagi joylashtirilgan SPA |
| Rejalashtirilgan hisobot email | `onlineOrder/ScheduledReportController` | yo'q | P2 | B2B mijoz uchun davriy email orqali yuborilgan hisobot xulosalari |

### `sms`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| SMS jo'natish (hodisa-trigger) | `MessageController::actionSend` (SendSmsJob orqali) | ha — sms.md | P0 | Hodisani trigger qilish → navbatga qo'yish → provayder; saqlash |
| SMS yetkazib berish callback (DLR) | `CallbackController::actionItem` | qisman — sms.md sequence | P0 | Provayder DLR ni postlaydi; SmsMessage statusini yangilaydi |
| SMS shablon aniqlash + tekshirish | `TemplateController::actionCreate` / `actionChecking` | yo'q | P1 | Shablon mualliflik; oldindan validatsiya |
| SMS paket sotib olish | `PackageController::actionBuying` + `ViewController::actionBuyingPackage` | yo'q | P1 | Tenant SMS paketni sd-billing orqali sotib oladi |
| Ommaviy xabar jo'natish | `MessageController::actionSend` | yo'q | P1 | Marketing kampaniyasi uchun kogortga jo'natish |

### `dashboard`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Tile read-through kesh | `BillingController` / `KpiController` va h.k. | yo'q | P1 | redis_app dan tile o'qish; SQL aggregatga fallback; 60 s kesh |
| Drill-down → hisobot | tile bosish → mos hisobot controlleriga | yo'q | P1 | Tile ga bosish, filtrlangan hisobotga sakrash |
| KPI v2 kunlik | `KpiController::actionDaily` / `actionAjaxOrderDetails` | yo'q | P1 | Buzilishlar bilan kun darajasidagi KPI rollupi |
| Kassir daromad tile | `KassaIncomeController` | yo'q | P2 | Bugungi kassir daromad xulosasi |
| Eslatmalar paneli | `NotificationController` | yo'q | P2 | Joriy foydalanuvchi uchun kutilayotgan eslatmalarni hisoblash |

### `report`

80+ hisobotlar — har bir hisobot uchun bir diagramma isrof bo'lardi.
Bitta kanonik "hisobot ishi" oqimini va ahamiyatsiz hisoblash
quvurlariga ega bir nechta hisobotlar uchun diagrammalar muallif
qiling.

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Kanonik hisobot ishi (HTML + Excel) | `BaseReport` | ha — report.md | P0 | Filtr forma → SQL aggregat → DataTables ko'rinishi → PHPExcel eksport |
| Bonus to'planish rollupi | `BonusAccumulationController` | yo'q | P1 | Choraklik settle bilan ko'p oylik bonus rollupi |
| RFM segmentatsiyasi | `RfmController` | yo'q | P1 | Recency/Frequency/Monetary darajalarini hisoblash |
| Reja-vs-haqiqat ekspeditor | `PlanExpeditorController` | yo'q | P1 | Rejaga qarshi ekspeditor unumdorligi |
| Foto hisoboti rollup | `PhotoReportController` / `ParentPhotoReportController` | yo'q | P2 | Auditlar bo'ylab foto hisobotlarini aggregatsiyalash |
| Bonus to'lash (real bonus) | `RealBonusController` | yo'q | P1 | Agent / davr boshiga to'lanadigan bonusni hisoblash |
| Ekspeditor kunlik hisoboti | `ExpeditorDailyReportController` | yo'q | P2 | Ekspeditor boshiga kunlik xulosa |
| Telegram hisobot bot | `TelegramController` | yo'q | P1 | Rejalashtirilgan hisobotlarni Telegram kanaliga push qilish |

### `planning`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Oylik reja sozlash | `Monthly2Controller::actionPulseSave` / `actionData` | yo'q | P1 | Agent / kategoriya boshiga oylik rejani aniqlash |
| Kunlik reja kuzatuv | `DailyController::actionAgent` / `actionTotal` / `actionPercent` | yo'q | P1 | Kun darajasidagi reja vs haqiqat jonli yangilanish |
| Dunyokpa reja sozlash | `OutletController::actionSave` / `actionSetup` | yo'q | P1 | Dunyokpa boshiga reja; agent rejasiga rolllanadi |
| Tavsiya dvigateli | `RecommendationController` | yo'q | P2 | Keyingi tashrifda push qilish kerak bo'lgan mahsulotlarni tavsiya qilish |

### `rating`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Reyting so'rovnoma ovoz | `PollController::actionVote` / `actionComment` | yo'q | P1 | Oxirgi-mijoz reytingda ovoz beradi; sharh olinadi |
| Reyting CRUD admin | `IndexController::actionCreateUpdateRating` / `actionDeleteRating` | yo'q | P2 | Admin reyting savollarini boshqaradi |

### `markirovka`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Markirovka API kiritish | `markirovka/ApiController` | yo'q | P1 | SKU boshiga UZ markirovka kodlarini kiritish; tekshirish |

### `team` / `staff` / `access`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Foydalanuvchini faollashtirish / o'chirish | `team/UserController::actionActive` | yo'q | P1 | Faol bayrog'ini almashtirish; sessiyalarga kaskadlanadi |
| Auditorni faollashtirish | `team/AuditorController::actionActive` | yo'q | P1 | Maxsus auditor faollashtirish yo'li |
| Foydalanuvchini rolga bog'lash | `access/BackendController::actionBindUser` / `actionBindAssignments` | yo'q | P0 | RBAC: ruxsat guruhini foydalanuvchiga tayinlash; authitem keshini qayta yuklash |
| Tayinlashlarni qayta yuklash | `access/BackendController::actionReloadAssignments` | yo'q | P1 | O'zgartirishdan keyin authitem iyerarxiyasini majburlab qayta yuklash |

### `vs` (van-sales)

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| VS buyurtma yaratish | `vs/CreateOrderController` | yo'q | P1 | Van-sales ga xos buyurtma yaratish oqimi |
| VS buyurtma tahrirlash | `vs/EditOrderController` | yo'q | P1 | Van-sales buyurtmasini tahrirlash (standart bilan boshqacha qoidalar) |

### `partners`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Hamkor ro'yxati (sd-main) | `partners/ListController` | yo'q | P2 | Bitta ekranli hamkor ro'yxati; minimal mantiq |

### `doctor` / `neakb` (legacy / maxsus)

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Qamrov hisoblash | `doctor/CoverageController` | yo'q | P2 | Agent / davr boshiga qamrov % |
| AKB dunyokpa hisoblash | `doctor/AkbController` | yo'q | P2 | Faol mijoz bazasini hisoblash |
| Bashorat | `doctor/ForecastController` | yo'q | P2 | Agent boshiga sotuv bashorati |
| Strike hisoblash | `doctor/StrikeController` | yo'q | P2 | Dunyokplar uchun ketma-ket-o'tkazib yuborish bayrog'i |
| Shaxsiy dashboard | `doctor/PersonalController` | yo'q | P2 | Agent uchun shaxsiy kun ko'rinishi |

## sd-billing inventarizatsiyasi

### `api` (gateway + S2S)

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Click prepare/confirm | `ClickController::actionIndex` | ha — payment-gateways.md | P0 | Ikki bosqichli HMAC-imzolangan prepare/confirm; idempotent kiritish |
| Payme JSON-RPC | `PaymeController::actionIndex` | ha — payment-gateways.md | P0 | CheckPerform / Create / PerformTransaction; HMAC tekshirish |
| Paynet SOAP | `PaynetController::actionIndex` | qisman — payment-gateways.md | P0 | SOAP gateway; PaynetTransaction + Payment kiritish |
| Litsenziya paketlarni sotib olish | `LicenseController::actionBuyPackages` | ha — subscription-flow.md | P0 | sd-main chaqiradi; validatsiya, Subscription qatorlari, Payment(license), Diler.refresh |
| Litsenziya partiya sotib olish | `LicenseController::actionIndexBatch` | yo'q | P0 | buyPackages partiya varianti; qator boshiga muvaffaqiyatsizlik izolyatsiyasi |
| Litsenziyani o'chirish | `LicenseController::actionDeleteOne` | yo'q | P0 | Bitta obunani bekor qilish |
| Litsenziya almashtirish | `LicenseController::actionExchange` | yo'q | P1 | Balans ichida obunani boshqasiga almashtirish |
| Litsenziya revize | `LicenseController::actionRevise` / `actionDistrRevise` | yo'q | P1 | Distributor va diler o'rtasidagi litsenziya foydalanishini yarashtirish |
| To'lovlar ro'yxati | `LicenseController::actionPayments` | yo'q | P2 | Faqat-o'qish to'lovlar ro'yxati |
| Bonus paketlarini berish | `LicenseController::actionBonusPackages` | yo'q | P1 | Bepul o'rinlar berish; is_bonus belgilash |
| Min-summa tekshirish | `LicenseController::actionCheckMin` | yo'q | P1 | Anti-suiiste'mol chegara validatsiyasi |
| 1C cashless qo'shish | `Api1CController::actionAddCashless` | yo'q | P1 | 1C diler uchun cashless to'lovni postlaydi |
| 1C obunalarni o'qish | `Api1CController::actionGetSubscriptions` | yo'q | P2 | 1C dilerning faol obunalarini tortadi |
| Host status hisoboti (sd-main → sd-billing) | `HostController::actionAuth` / `actionActiveHosts` | yo'q | P0 | sd-main o'z server holatini xabar beradi; sd-billing host boshiga faollikni kuzatadi |
| SMS paket sotib olish | `SmsController::actionBuySmsPackage` | yo'q | P0 | sd-main SMS paketni sotib oladi; Diler.BALANS dan debetlanadi |
| SMS shablon yaratish + tekshirish | `SmsController::actionCreateTemplate` / `actionCheckingTemplates` | yo'q | P1 | Jo'natishga ruxsat berishdan oldin shablonni oldindan tekshirish |
| SMS jo'natish + yo'naltirish | `SmsController::actionSend` / `actionSendingForward` | yo'q | P0 | Tenant tomonidan trigger qilingan, markaziy SMS orqali jo'natadi |
| SMS yetkazib berish callback | `SmsController::actionCallback` | yo'q | P0 | Provayder DLR callback i SmsMessage ni yangilaydi |
| App auth (sd-main) | `AppController::actionAuth` / `actionExecute` | yo'q | P0 | sd-main → sd-billing API uchun fixed-foydalanuvchi sessiya |
| Quest endpointlari | `QuestController::actionDetail` | yo'q | P2 | Maxsus quest API (maxsuslashtirilgan) |

### `operation`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Qo'lda to'lov kiritish | `operation/PaymentController::actionCreateOrUpdate` | qisman — payment-gateways.md | P0 | Operator P2P / naqd / cashless to'lovni qayd qiladi; Diler.refresh ni triggerlaydi |
| Obuna CRUD | `operation/SubscriptionController` | yo'q | P1 | Diler obunalarini admin tomonidan tahrirlash |
| SubscriptionSMPro CRUD | `operation/SubscriptionSMProController` | yo'q | P2 | SM-Pro darajasidagi obuna |
| Paket CRUD | `operation/PackageController` | yo'q | P2 | Sotib olinadigan paketlarni aniqlash |
| PackageSMPro CRUD | `operation/PackageSMProController` | yo'q | P2 | SM-Pro paketlari |
| Tarif CRUD | `operation/TariffController` | yo'q | P2 | Mamlakat boshiga tarif ta'riflari |
| Blacklist almashtirish | `operation/BlacklistController` | yo'q | P1 | Diler / IP / telefonni xaridlardan bloklash |
| Eslatma yozish + jo'natish | `operation/NotificationController::actionSend` / `actionPost` | yo'q | P1 | Ops eslatmasini yozish; dilerlar uchun navbatga qo'yish |
| Aloqa boshqarish | `operation/RelationController` | yo'q | P2 | Distributor ↔ diler shartnomasini tahrirlash |

### `dashboard`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Distributor to'lov yaratish/yangilash | `DistrPaymentController::actionCreateAjax` / `actionUpdateAjax` | yo'q | P0 | Qo'lda distributor to'lovi kirish; dilerlarga qarab yarashtiradi |
| Qo'lda to'lov kiritish | `dashboard/PaymentController::actionCreateAjax` / `actionUpdateAjax` | yo'q | P0 | operation/Payment bilan bir xil, lekin boshqa ekrandan |
| Reset / fix server | `ResetController::actionFixServer` / `actionDeleteServer` | yo'q | P1 | Diler uchun server kirishini tozalash / qayta tiklash |
| Chegirma berish | `FixController::actionGiveDiscount` / `actionGdProgress` | yo'q | P1 | Dilerga bir martalik chegirma qo'llaniladi |
| Write-server (litsenziya faylini push qilish) | `FixController::actionWriteServer` / `actionCheckStatusServer` | yo'q | P0 | Dilerning sd-main iga litsenziya faylini qo'lda push qilish |
| Operatsiya / turlar qo'shish | `FixController::actionAddOperation` / `actionAddTypes` | yo'q | P2 | Bir martalik ops tuzatish (yetishmayotgan operatsiya qatorini qo'shish) |
| Diler hisoblash yangilash | `ComputationController` (turli joylardan chaqiriladi) | yo'q | P1 | Bitta Diler uchun BALANS, FREE_TO, MONTHLY ni qayta hisoblash |
| Distr hisoblash | `DistrComputationController` | yo'q | P1 | Distributor tomondagi hisoblash quvuri |
| Server so'rovi (sd-main holat so'raydi) | `ServerController::actionRequest` / `actionCreated` | yo'q | P1 | sd-billing sd-main dan server-status yangilanishini qabul qiladi |
| Sozlama saqlash | `SettingController` | yo'q | P2 | Dashboard sozlamalarini saqlash |

### `cashbox`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Kassa o'tkazish (stollar o'rtasida) | `cashbox/TransferController::actionAdd` / `actionCreateAjax` | yo'q | P0 | Kassa stollari o'rtasida pul ko'chirish; double-entry to'lov |
| Iste'mol (xarajat) | `cashbox/ConsumptionController::actionCreateAjax` | yo'q | P1 | Kassa stolidan xarajatni qayd qilish |

### `notification`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Ilova ichi eslatma jo'natish | `notification/ViewController::actionSend` | yo'q | P1 | Eslatma qatorini kiritish; oluvchini xabardor qilish |
| Eslatma ack | `notification/ViewController::actionTally` | yo'q | P2 | Eslatmani o'qilgan deb belgilash |

### `partner` (o'z-o'ziga xizmat)

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Hamkor o'z dilerlarini ko'radi | `partner/DealerController::actionDealer` | yo'q | P1 | Hamkor-scoped diler ro'yxati; kirish-tekshirilgan |
| Hamkor obunalarni ko'radi | `partner/SubscriptionController::actionDealer` | yo'q | P1 | Hamkor-scoped obuna ro'yxati |
| Hamkor to'lovlarni ko'radi | `partner/PaymentController::actionDealer` | yo'q | P1 | Hamkor-scoped to'lov ro'yxati |

### `report`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Telegram bot hisobot xulosasi | `report/TgBotController` | yo'q | P1 | Soatlik/kunlik hisobotni Telegram ga push qilish |
| Churn hisoboti | `report/ChurnController` | yo'q | P1 | Churn kogortini hisoblash va KPI ni yuzaga chiqarish |
| Faol mijozlar | `report/ActiveCustomersController` | yo'q | P1 | Vaqt o'tishi bilan faol diler hisobi |
| PL hisoboti | `report/PLController` | yo'q | P1 | sd-billing P&L roll-up |
| Pivot hisobot ishga tushiruvchi | `report/PivotController` | yo'q | P2 | Generik pivot UI |

### `dbservice`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| DB ta'minoti vazifasini ishga tushirish | `dbservice/ServiceController::actionIndex` | yo'q | P2 | Ad-hoc ma'lumot tuzatish skriptlari; faqat admin |

### Cron buyruqlari (single-tenant)

| Xususiyat / oqim | Manba | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|-------|-------------------|-----------|-------------------|
| `notify` cron drain | `commands/NotifyCommand` (har minutda) | ha — cron-and-settlement.md | P0 | d0_notify_cron ni drain qilish; Telegram yoki license-delete ga yo'naltirish |
| `settlement` cron | `commands/SettlementCommand` (kunlik 01:00) | ha — cron-and-settlement.md | P0 | Distributor ↔ diler oylik qarz hisoblash; double-entry Payment qatorlari |
| `botLicenseReminder` cron | `commands/BotLicenseReminderCommand` (kunlik 09:00) | yo'q | P0 | Muddati tugashidan 7/3/1 kun oldin dilerlarga xabar berish |
| `cleanner` cron | `commands/CleannerCommand` (Shanba 22:00) | yo'q | P1 | Eskirgan obunalar va h.k. ning haftalik tozalash |
| `pradata` cron (HTTP pull) | salesdoc.io dan tashqi curl (05:30/05:40/05:50) | yo'q | P1 | Tashqi instansiya HTTP orqali oldindan hisoblangan ma'lumotlarni tortadi |

## sd-cs inventarizatsiyasi

### `api` (S2S endpointlari + integratorlar)

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Cislink yaratish + yuklash | `api/CislinkController::actionGenerate` / `actionUpload` | yo'q | P1 | Cislink-formatli eksportni yaratish va SFTP orqali yuklash |
| Cislink status pollingi | `api/CislinkController::actionStatus` / `actionLog` | yo'q | P2 | Sync holatini tekshirish; logni ko'rib chiqish |
| Isellmore yuklash | `api/IsellmoreController::actionUploadToISM` / `actionUpload2` | yo'q | P1 | HQ tomondagi stocklar/sotuvlarni Isellmore ga push qilish |
| Isellmore yaratish | `api/IsellmoreController::actionGenerate` | yo'q | P1 | Isellmore eksport payloadini yaratish |
| Isellmore checksum | `api/IsellmoreController::actionChecksum` | yo'q | P2 | Yuklash yaxlitligini tekshirish |
| Lianeksstock qabul/sotuvlar/qaytish | `api/LianeksstockController::actionSales` / `actionReceipt` / `actionReturn` | yo'q | P1 | Lianeks stock-feed almashish |
| Pradata yaratish + yuklash | `api/PradataController::actionGenerate` / `actionUpload` | yo'q | P1 | HQ oldindan hisoblash → upstream ga yuklash |
| Operator: narxlarni tuzatish | `api/OperatorController::actionFixPrices` | yo'q | P2 | `cs_*` da narxlarni ommaviy-tuzatish |
| Operator: cleaner | `api/OperatorController::actionCleaner` | yo'q | P2 | Ad-hoc admin tozalash vositasi |
| Telegram hisobot cron | `api/TelegramReportController::actionCron` | yo'q | P1 | Kunlik HQ Telegram xulosasi pushi |
| Billing status pull | `api/BillingController::actionStatus` | yo'q | P1 | HQ xulosasi uchun sd-billing dan billing holatini tortish |

### `report` + `pivot` (dilerlar bo'ylab)

Butun modul kanonik "loopda diler ulanishini almashtirish" patterni;
pattern uchun bir diagramma + ahamiyatsiz hisobotlar uchun bir nechta.

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Dilerlar bo'ylab hisobot (kanonik) | har qanday `report/*Controller` dagi asosiy pattern | ha — sd-cs/sd-main-integration.md | P0 | DealerRegistry → loop swap connection → narrow SELECT → PHP fold → cache |
| Dilerlar bo'ylab pivot hisobot | `pivot/SaleController` / `pivot/RfmController` | yo'q | P0 | Kanonik patternning og'irroq pivot varianti |
| AKB / OKB tahlil | `report/AkbController` / `report/AnalyzeAkbController` / `report/OkbController` | yo'q | P1 | Davr bo'yicha faol vs umumiy mijoz bazasi |
| Reja vs haqiqat (HQ) | `report/PlanController` / `report/PlanProductController` | yo'q | P1 | HQ darajasidagi reja vs haqiqat roll-up |
| Bonus sotuvi / xulosa bonusi | `report/BonusSaleController` / `report/SummaryBonusController` | yo'q | P1 | HQ bonus rollupi |
| Foto galereya (HQ) | `report/PhotoController` | yo'q | P2 | Dilerlar bo'ylab HQ foto galereyasi |
| Movement | `report/MovementController` | yo'q | P2 | Stock movement HQ rollupi |
| Litsenziya | `report/LicenceController` | yo'q | P1 | HQ darajasidagi litsenziya foydalanishi va yangilash holati |
| Log (cs_dblog) | `report/LogController` | yo'q | P2 | Cross-DB so'rovlarining audit logi |

### `dashboard`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| HQ kunlik KPI tile | `dashboard/DailyController::actionGetData` / `actionGetDataSale` | yo'q | P1 | HQ kunlik KPI ni olish; xuddi shu swap-dealer pattern ostida |
| Supervayzer monitor | `dashboard/SupervayzerController` | yo'q | P2 | HQ supervayzer dashboardi |

### `directory`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| Diler registri CRUD | `directory/DealerController` | ha — sd-main-integration.md (onboarding) | P0 | Diler DSN va imkoniyat bayrog'ini qo'shish/tahrirlash |
| HQ katalog CRUD (brand/segment va h.k.) | `directory/AdtBrandController`, `directory/AdtSegmentController` va h.k. | yo'q | P2 | Master katalog markaziy tahrirlanadi |
| Mamlakat kategoriyasi | `directory/CountryController` / `directory/ClientCategoryController` | yo'q | P2 | Mamlakat darajasidagi ma'lumotnoma ma'lumotlari |

### `user` / `api3`

| Xususiyat / oqim | Manba (controller / action) | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|------------------|------------------------------|-------------------|-----------|-------------------|
| HQ foydalanuvchi login | `user/LoginController::actionIndex` | yo'q | P1 | cs_user ga qarshi login; multi-DB sessiya |
| Foydalanuvchi kirishini sozlash / olish | `user/DefaultController::actionSetAccess` / `actionGetAccess` | yo'q | P1 | HQ foydalanuvchi ruxsatlarini boshqarish |
| Foydalanuvchi cron sync | `user/CroneController::actionIndex` | yo'q | P2 | Davriy foydalanuvchi ma'lumotlarini sync |
| api3 menejer endpointi | `api3/ManagerController::actionIndex` | yo'q | P2 | HQ tomondagi mobil/yordamchi endpointi (bugun bitta harakat) |

## Loyihalararo integratsiya oqimlari

Bu mualliflik qilish uchun eng yuqori-leverage diagrammalari — har biri
2 yoki 3 loyihaga qamrab oladi va yangi muhandislar avval qaysi
haqida so'rashadi.

| # | Oqim | Yo'l | Mavjud diagramma? | Prioritet | Bir-qatorli eskiz |
|---|------|------|-------------------|-----------|-------------------|
| X1 | Paketlarni sotib olish (to'liq round-trip) | sd-main `api/license/buyPackages` → sd-billing `api/license/buyPackages` → Subscription + Payment(license) → Diler.refresh → Server.STATUS sd-main ga qaytarib pushlanadi | qisman — sd-billing/subscription-flow.md | P0 | Diler sd-main paketni sotib olishni postlaydi; sd-billing tekshiradi, Subscription + Payment yozadi, Diler.refresh qiladi, litsenziya faylini qaytarib pushlaydi |
| X2 | Litsenziyani yangilash + muddati tugaganligi haqida xabar berish | sd-billing `botLicenseReminder` cron → Telegram + SMS → ixtiyoriy ravishda `Diler.deleteLicense()` → sd-main yangi litsenziyani o'qiydi | yo'q | P0 | Muddat-tugaguncha-kunlar darajasi xabar berishni triggerlaydi; muddati tugaganda litsenziya fayli aylanadi |
| X3 | Onlayn gateway (Click) uchidan uchigacha | Click → sd-billing `api/click` (prepare + confirm) → Payment(clickonline) → BALANS += summa → Diler.refresh → Server STATUS=SENT → sd-main litsenziyasi yangilanishi | ha — payment-gateways.md (sd-billing tomoni) | P0 | Mijoz to'laydi; gateway sd-billing ga uradi; balans o'sadi; yangi litsenziya dilerga pushlanadi |
| X4 | Onlayn gateway (Payme) uchidan uchigacha | X3 ga o'xshash, lekin Payme JSON-RPC | ha — payment-gateways.md | P0 | PaymeTransaction da kalitlangan idempotentlik bilan ekvivalent oqim |
| X5 | Onlayn gateway (Paynet) uchidan uchigacha | X3 ga o'xshash SOAP bilan | qisman — payment-gateways.md | P0 | paynetuz kengaytmasi orqali Paynet bilan ekvivalent oqim |
| X6 | Settlement → tarqatish → xabar berish | sd-billing `cron settlement` → Payment(distribute) juftligi → LogDistrBalans → Telegram xulosasi | ha — cron-and-settlement.md | P0 | Kunlik distributor↔diler nettingi; double-entry to'lovlar; ops xabar oladi |
| X7 | Telefon katalogi sync | sd-billing → sd-main `api/billing/phone` | yo'q | P0 | sd-billing o'zgarganda sd-main ga telefon-katalog yangilanishlarini push qiladi |
| X8 | sd-cs dilerlar bo'ylab hisobot | sd-cs `report/*` → swap `Yii::app()->dealer` → har bir diler DB ga so'rov → PHP fold → kesh | ha — sd-main-integration.md | P0 | Kanonik multi-DB o'qish patterni: HQ N diler DB lardan faqat-o'qish o'qiydi |
| X9 | Yangi-diler onboarding (to'liq zanjir) | shartnoma → sd-billing `Diler` qatori → litsenziya fayli → sd-main provisioned → DSN → cs_* dagi DealerRegistry → smoke hisoboti | ha — sd-main-integration.md | P0 | Uchta loyiha bo'ylab uchidan uchigacha provisioning zanjiri |
| X10 | SMS round-trip (sd-main → sd-billing → provayder → callback) | sd-main `sms/MessageController::actionSend` → sd-billing `api/sms/send` → Eskiz/Mobizon → callback (`api/sms/callback`) → status sd-main ga qaytadi | qisman — sms.md sequence | P0 | Tenant SMS xarajat rollupi uchun markaziy SMS xizmati orqali o'tadi; DLR dilerga qaytadi |

## Tavsiya etilgan mualliflik tartibi

### Birinchi partiya (P0, eng yuqori-leverage) — 30 oqim

1. Buyurtma yaratish (web) — allaqachon bajarilgan; faqat orders.md ga qarshi yangilash
2. Buyurtma yaratish (mobil) — allaqachon qisman
3. Buyurtma status o'tish diagrammasi (to'liq state machine) — allaqachon bajarilgan
4. Yetkazib berishda defekt — allaqachon bajarilgan; mahkamlashni ko'rib chiqish
5. Buyurtma eksporti (1C / Didox / Faktura) — allaqachon bajarilgan
6. Paketlarni sotib olish to'liq round-trip (X1)
7. Litsenziyani yangilash + muddati tugashi haqida xabar (X2)
8. Click to'liq round-trip (X3)
9. Payme to'liq round-trip (X4)
10. Paynet to'liq round-trip (X5)
11. Settlement → tarqatish → xabar berish (X6) — allaqachon bajarilgan
12. Telefon katalogi sync (X7)
13. Loyihalar bo'ylab SMS round-trip (X10)
14. Yangi-diler onboarding (X9) — allaqachon bajarilgan
15. sd-cs dilerlar bo'ylab hisobot (X8) — allaqachon bajarilgan
16. Stock zaxira atomik op (sd-main)
17. Kassa ko'chirish / To'lov o'tkazish (sd-main finans)
18. Kassa o'tkazish (sd-billing)
19. Qo'lda to'lov kiritish (sd-billing operation/dashboard)
20. Distributor to'lov yaratish/yangilash (sd-billing)
21. Write-server / litsenziya faylini push qilish (sd-billing FixController)
22. Litsenziyani o'chirish (sd-billing → sd-main)
23. Tashrif + GPS geofence — allaqachon bajarilgan; gps3 haqiqatiga qarshi tekshirish
24. Zonadan tashqari rad etish — sub-oqimni yuzaga chiqaradi
25. Tovar qabul qilish — allaqachon bajarilgan
26. Stock o'tkazish + filiallararo ko'chish (ikki diagramma)
27. Inventarizatsiya yarashishi + tuzatishlarni postlash — allaqachon bajarilgan
28. Audit jo'natish — allaqachon bajarilgan
29. RBAC foydalanuvchini bog'lash / tayinlashlarni qayta yuklash
30. SMS DLR callback (sd-main + sd-billing parityligi)

### Ikkinchi partiya (P1 qo'llab-quvvatlovchi) — 41 oqim

Modul egasi bo'yicha guruhlangan, shunda mualliflik parallel
partiyalarda bajarilishi mumkin:

- **orders** — Tahrirlash, Status partiyasi, Bekor qilish, Rad etish + sharh, Almashtirish, Excel import, Bonus buyurtma, Filiallar o'rtasida ko'chish, Ekspeditor yuk rejalashtirish
- **clients** — Maydonda yaratilgan (mobil), Revize, Tranzaksiyalar ledger, Tara hujjatlari, Inventarizatsiya, Stock-baza
- **agents** — Kunlik KPI hisoblash, Cheklov ijrosi, Qabul qilish, Vazifa tayinlash, Supervayzer dashboardi
- **finans** — P&L, Pivot P&L saqlash, Agent P&L, Iste'mol yozish
- **inventory** — Foto dalil
- **stock** — Sotib olish/xarid, Do'konlar o'rtasida almashish, Excretion, VS exchange + qaytarish
- **integration** — TraceIQ kiruvchi, Generik 1C katalog import
- **sd-billing api** — Litsenziya partiya sotib olish, Litsenziya revize, Bonus paketlari, SMS paket sotib olish, SMS jo'natish, SMS DLR callback, Min-summa tekshirish
- **sd-billing operation** — Obuna CRUD, Blacklist almashtirish, Eslatma yozish + jo'natish
- **sd-billing dashboard** — Diler hisoblash yangilash, Distr hisoblash, Server-status so'rovi, Reset server, Chegirma berish
- **sd-billing cron** — botLicenseReminder, cleanner, pradata
- **sd-cs api** — Cislink yaratish, Isellmore yuklash, Lianeksstock, Pradata, Telegram hisobot cron, Billing status pull
- **sd-cs reports** — AKB / OKB tahlil, Reja vs haqiqat, Bonus sotuv / xulosa bonusi, Litsenziya foydalanish
- **report (sd-main)** — Bonus to'planish rollupi, RFM, Reja-vs-haqiqat ekspeditor, Real bonus to'lash, Telegram hisobot bot

### Uchinchi partiya (P2 chetga holatlari) — 26+ oqim

Ommaviy importlar, arxiv, dbservice, qayta urinishlar, sozlamalar
panellari, bitta-harakatli controllerlar, legacy-belgilangan modullar
(`doctor`, `neakb`, `manager`, sync-obsolete). Bular to'liqlik uchun
yoqimli va faqat ostidagi mantiq odatdan tashqari bo'lganda
diagrammalarni talab qiladi; faqat-CRUD yozuvlari matnli qolishi
mumkin.

## Ushbu inventarizatsiyani qanday ishlatish

- **PM lar** — P0/P1 ga qarab keyingi partiyani tanlang.
  Loyihalararo X-qatorlari eng yuqori tashqi-stakeholder leverage idir.
- **Tech lead lar** — prioritetlarni joriy sprint fokusini aks
  ettirayotganini tasdiqlang; alohida qatorlarni PR sharhlarida
  bekor qiling.
- **Hujjat maintainerlari** — Mermaid bloki modulning manba sahifasi
  ichiga kelganda, qatorning "Mavjud diagramma?" hujayrasini hujjat +
  bo'lim ankerini keltirish uchun o'zgartiring, keyin qatorni backlog
  partiyasidan yuqoridagi "Allaqachon bajarilgan" jadvaliga ko'chiring.
- **Diagrammalarni yozayotgan muhandislar** — 12 tamoyil uchun
  [Workflow dizayn standartlari](./team/workflow-design.md) ga qarang.
  Styling cookbook ni nusxa qilish uchun
  `docs/diagrams/sd-main-features.md` dagi mavjud diagrammalardan biri
  bilan juftlashing.

## Ushbu inventarizatsiyada *yo'q* narsalar haqida izohlar

- **Sof CRUD** — `directory/*`, `partner/View*`, sozlamalar formalari,
  klassik ro'yxat/tahrirlash/o'chirish harakatlari. Bir jumladan
  tashqari diagramma qiymati yo'q.
- **Ichki yordamchilar** — `actionGetData`, `actionFetch*`, AJAX forma
  oldindan yuklovchilar. Ular ota oqimga xizmat qiladi va (agar
  umuman) o'sha ota ichida diagrammalanishi kerak.
- **Test endpointlari** — `actionTest`, `*Test.php` controllerlari.
  Mualliflik maqsadlari emas.
- **Eskirgan fayllar** — `.obsolete` bilan tugaydigan har qanday narsa.
  Butunlay chiqarilgan.
- **Legacy avlodlar** — `gps` va `gps2` harakatlari faqat ba'zi
  tenantlar uchun production da bo'lganda ro'yxatga olinadi; yangi
  diagrammalar `gps3` ga yo'naltirilishi kerak.
