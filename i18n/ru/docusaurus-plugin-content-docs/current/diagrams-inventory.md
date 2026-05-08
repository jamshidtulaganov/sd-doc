---
sidebar_position: 99
title: Инвентарь диаграмм и приоритизация
audience: Tech leads, PM, doc maintainers
summary: Каталог каждого workflow / feature flow по трём проектам, который кандидат на Mermaid-диаграмму, приоритизирован P0/P1/P2. Используйте для планирования авторских батчей.
---

# Инвентарь диаграмм и приоритизация

Сгенерировано из controller-walk трёх репозиториев плюс существующих
doc-страниц. Числа отражают сегодняшнюю реальность, не амбиции.

Эвристика: действие становится кандидатной строкой только когда у него
есть **workflow shape** — multi-table writes, status transitions, queue
или external-call dispatch, signature verification, geofence checks,
cross-project round-trips. Чисто list/view/CRUD-эндпоинты и form-handler
исключены.

## Сводка

- **sd-main** — 95 кандидатных flow (28 P0, 41 P1, 26 P2)
- **sd-billing** — 32 кандидатных flow (12 P0, 12 P1, 8 P2)
- **sd-cs** — 18 кандидатных flow (5 P0, 8 P1, 5 P2)
- **Cross-project integration flow** — 10 flow (10 P0)
- **Всего кандидатов: 155**, из которых 13 уже имеют Mermaid-блок
  в документации.

## Уже сделано

Flow, у которых уже есть inline Mermaid-блок где-то в документации.

| # | Flow | Source doc | Заметки |
|---|------|------------|-------|
| 1 | Approval workflow (client) | `docs/modules/clients.md` | Также в `diagrams/sd-main-features.md#d-01` |
| 2 | Order export (1C / Didox / Faktura) | `docs/modules/integration.md` | `diagrams/sd-main-features.md#d-02` |
| 3 | Report run + Excel export | `docs/modules/report.md` | `diagrams/sd-main-features.md#d-03` |
| 4 | Payment approval | `docs/modules/payment.md` | `diagrams/sd-main-features.md#d-04`; before/after пара в `diagrams/workflows.md#d-01` |
| 5 | SMS dispatch (sequence) | `docs/modules/sms.md` | `diagrams/sd-main-features.md#d-05` |
| 6 | Stocktake | `docs/modules/inventory.md` | `diagrams/sd-main-features.md#d-06` |
| 7 | Audit submission | `docs/modules/audit-adt.md` | `diagrams/sd-main-features.md#d-07` |
| 8 | Goods receipt | `docs/modules/warehouse.md` | `diagrams/sd-main-features.md#d-08` |
| 9 | Online order placement | `docs/modules/onlineOrder.md` | `diagrams/sd-main-features.md#d-09` |
| 10 | Order status machine | `docs/modules/orders.md` | `diagrams/sd-main-features.md#d-10` |
| 11 | Order create (sequence) | `docs/modules/orders.md` | `diagrams/sd-main-features.md#d-11` |
| 12 | Visit + GPS geofence | `docs/modules/gps.md` (link) | `diagrams/sd-main-features.md#d-12` |
| 13 | Defect + return-to-stock | `docs/modules/stock.md` | `diagrams/sd-main-features.md#d-13` |
| 14 | Subscription / licensing | `docs/sd-billing/subscription-flow.md` | `diagrams/sd-billing.md#d-04` |
| 15 | Settlement (cron) | `docs/sd-billing/cron-and-settlement.md` | `diagrams/sd-billing.md#d-05` |
| 16 | Notifications cron (sequence) | `docs/sd-billing/cron-and-settlement.md` | `diagrams/sd-billing.md#d-06` |
| 17 | Click flow (sequence) | `docs/sd-billing/payment-gateways.md` | `diagrams/sd-billing.md#d-07` |
| 18 | Payme flow (sequence) | `docs/sd-billing/payment-gateways.md` | `diagrams/sd-billing.md#d-08` |
| 19 | New-dealer onboarding (HQ) | `docs/sd-cs/sd-main-integration.md` | `diagrams/sd-cs.md#d-02` |
| 20 | Cross-dealer report architecture | `docs/sd-cs/sd-main-integration.md` | `diagrams/sd-cs.md#d-01` |

(Master count выше показывает 13 *уникальных flow* с диаграммами,
уже приземлёнными внутри per-module страниц; остальные выше — это
дубликаты того же flow в разных consolidation-страницах или
архитектурные диаграммы, а не feature-flow.)

## Инвентарь sd-main

### `orders`

Самая важная область sd-main. В основном P0.

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Order create (web) | `AddOrderController::actionCreate` | yes — orders.md | P0 | Operator builds order, prices/limits validated, Order + OrderProduct written, status NEW |
| Order create (mobile) | `api3/OrderController::actionPost` | partial — orders.md | P0 | Agent posts order during visit; geofence + limits check; same pipeline as web |
| Order create (online B2B) | `api4/OrderController` + `onlineOrder/OrderController` | yes — onlineOrder.md | P0 | Customer self-service via api4, optional online-payment redirect |
| Order draft autosave (mobile) | `api3/OrderController::actionPostDraft` / `actionGetDraft` | no | P1 | Mobile saves draft to server so it survives app close |
| Order edit | `EditController::actionDetails` / `actionStatus` / `actionSubstatus` / `actionDateLoad` | no | P1 | Operator edits lines, dates, expeditor; logs OrderStatusHistory |
| Order status transition | `OrderStateController::actionChange` | yes — orders.md state machine | P0 | Status moves with side effects: stock reserve / release / export trigger |
| Order status batch transition | `EditController::actionStatusBatch` | no | P1 | Bulk status change with per-row failure handling |
| Order cancel | `OrderStateController::actionCancelState` | no | P1 | Cancel after dispatch — restock and notify |
| Order reject + comment | `OrderStateController::actionRejectComment` | no | P1 | Whole-order reject at delivery; reason captured |
| Defect on delivery | `EditController::actionPartialDefect` + `api3/DefectController::actionPost` | yes — stock.md | P0 | Per-line defect with photo evidence, return-to-stock |
| Order replace | `OrderReplaceController` + `RecoveryOrderController::actionReplace` | no | P1 | Replace a delivered order (e.g. wrong product), preserving history |
| Order recovery / restoration | `RecoveryOrderController::actionCreate` / `actionUpdate` | no | P2 | Restore a deleted order with audit trail |
| Order Excel import | `ImportOrderController` | no | P1 | CSV/XLSX batch order creation; per-row validation |
| Order print (invoice) | `InvoiceController` | no | P2 | Render templated invoice/waybill; logs print event |
| Faktura.uz UZ EDI submit | `FakturaUZController` | yes — integration.md | P0 | Submit signed e-invoice on Loaded/Delivered; persist response |
| Expeditor load planning | `ExpeditorLoadNeoController` | no | P1 | Group orders for an expeditor's daily load |
| Bonus order linkage | `OrderBonusController` | no | P1 | Promo bonus orders linked back via BONUS_ORDER_ID |
| Movement between filials | `OrderStateController::actionMovementFilials` | no | P1 | Cross-filial transfer of an order |
| Make-purchase shortcut | `OrderStateController::actionMakePurchase` | no | P2 | Convert an order into a purchase doc |
| Cleanup / archival | `CleanOrdersController` | no | P2 | Bulk archive of stale orders; admin only |

### `clients`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Client approval (Pending → Active) | `ApprovalController::actionSave` | yes — clients.md | P0 | Manager reviews pending client, approves / rejects, optional 1C export |
| Field-created client (mobile) | `api3/ClientController` | no | P0 | Agent submits new client during visit; goes to ClientPending |
| Client revise (debt reconciliation) | `ReviseController` | no | P1 | Reconcile client receivables vs payments; writes reconciliation record |
| Client transactions ledger | `TransactionController` | no | P1 | Per-client running ledger (orders, payments, returns) |
| Tara documents (returnable packaging) | `TaraController` / `TaradocController` | no | P1 | Tara doc lifecycle and per-client tara balance |
| Stock-base management | `StockBaseController` | no | P2 | Per-client stock base for consigned inventory |
| Client computation (rollup) | `ComputationController` | no | P2 | Recompute aggregate fields (debt, last visit) |
| Client SMS dispatch | `SendingSmsController` | no | P2 | Bulk send SMS to a client cohort |
| Inventorisation per client | `InventorizationController` | no | P1 | Client-level stocktake on consigned goods |
| Shipper finance | `ShipperFinansController` | no | P2 | Shipper-side reconciliation |
| Contragent (counterparty) | `ContragentController` | no | P2 | Manage parent/related counterparties |

### `agents`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Agent CRUD + activation | `AgentController` | no | P1 | Create/edit/deactivate agent; cascades to Car, KPI, route |
| Agent visit (mobile, with geofence) | `VisitingController` + `api3/VisitController::actionPost` | yes — sd-main-features.md#d-12 | P0 | Agent checks in at outlet; geofence verified; visit row written |
| Visit confirmation (post-check) | `api3/VisitController::actionPostCheck` | no | P0 | Server-side recheck of visit data after sync |
| Daily KPI compute | `KpiNewController` | no | P1 | Plan-vs-actual rollup per agent for the day |
| Limit enforcement (credit / discount) | `LimitController` + `LimitReportController` | no | P0 | Validate order against agent's credit and discount caps |
| Reception (cash receipt) | `ReceptionController` | no | P1 | Agent-side cash reception; feeds payment pipeline |
| Task assignment | `TaskNewController` | no | P1 | Assign tasks (calls/visits) to an agent for the day |
| Supervayzer dashboard | `SupervayzerController` | no | P1 | Supervisor monitors team performance |

### `audit` + `adt`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Audit submission (mobile) | `audit/PollResultController` + `api3/Auditor*` | yes — audit-adt.md | P0 | Agent answers poll, marks facing, photos uploaded, score computed |
| Photo report submission | `PhotoReportController` | no | P1 | Photo-only audit; categorised, uploaded, indexed |
| Audit definition (form builder) | `audit/PollController` | no | P1 | Define poll questions, variants, target SKUs |
| Auditor monthly report | `adt/MonthlyController` | no | P2 | Per-auditor monthly compliance scorecard |
| Storecheck (price + facing) | `audit/FacingController` + `adt/StoreCheckController` | no | P1 | Per-SKU shelf check, price capture |
| ADT poll setup | `adt/AdtPollController` + `adt/PollController` | no | P1 | Configurable advanced audit poll definition |
| ADT visit ingest | `adt/VisitController::actionUpdatePoll` / `actionUpdateAudit` | no | P1 | Ingest mobile-side audit submissions into ADT tables |
| ADT user assignment | `adt/AdtAuditController::actionSetUsers` | no | P2 | Pin auditors to a specific audit definition |
| Compliance scoring rollup | `audit/DashboardController` | no | P2 | Aggregate score per outlet across audits |

### `inventory`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Create stocktake doc | `AddController::actionIndex` / `actionBatch` | yes — inventory.md | P0 | Manager opens stocktake doc, optional batch (multi-warehouse) |
| Mobile barcode scan | `ScanController` + `api3/InventoryController::actionSet` | partial — inventory.md | P0 | Operator scans SKU; per-scan row + photo |
| Reconciliation (deltas) | `EditController::actionInventory` | no | P0 | Compute deltas vs Stock; produce adjustment doc |
| Approve + post adjustments | `StatusController::actionEdit` / `actionBulkEdit` | no | P0 | Manager approves; deltas post to stock |
| Photo evidence per item | `PhotoController::actionAdd` | no | P1 | Attach photos for damaged/short items |
| Bulk delete (stale docs) | `DeleteController::actionMultiple` | no | P2 | Admin bulk-deletes stale stocktakes |

### `warehouse`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Goods receipt (web) | `AddController` | yes — warehouse.md | P0 | Add doc; stock += count; integration log per receipt |
| Stock transfer (between warehouses) | `ExchangeController` | no | P0 | Move between warehouses inside one filial; atomic stock op |
| Inter-filial movement | `FilialMovementController` | no | P0 | Two-leg transfer doc between filials |
| Pick & pack for order | `EditController` | no | P1 | Reserve and load lines for fulfilment |
| Receipt API ingest | `ApiController` | no | P1 | External 1C / supplier system pushes receipts |

### `stock`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Add return | `AddReturnController` | yes — stock.md | P0 | Return-to-stock from defect / reject; uses StockService |
| Buy / purchase | `BuyController` + `PurchaseController` | no | P1 | Inbound purchase from supplier; stock += count |
| Exchange between stores | `ExchangeStoresController` | no | P1 | Move stock between retail stores |
| Excretion (write-off) | `ExcretionController` | no | P1 | Damage / theft permanent removal with reason |
| VS exchange (van-sales) | `VsExchangeController` + `VsExchangeDownloadController` | no | P1 | Van-sales stock exchange document |
| VS return | `VsReturnController` + `VsReturnDownloadController` | no | P1 | Van-sales return-to-warehouse |
| Store corrector | `StoreCorrectorController` | no | P2 | Manual stock correction with audit trail |
| Stock reservation atomic op | `StockService::reserveForOrder` (called from order pipeline) | no | P0 | Atomic decrement available + increment reserved in one transaction |
| Plan product | `PlanProductController` | no | P2 | Per-product stock plan vs actual |

### `payment` + `pay`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Payment record + cashier approval | `payment/ApprovalController::actionSave` | yes — payment.md | P0 | Agent records payment, cashier approves/rejects, applies to debt + cashbox |
| Reassign payment to other order | `payment/ApprovalController::actionUnlinkOrder` | no | P1 | Operator re-routes a misplaced payment |
| Update payment delivery | `payment/ApprovalController::actionUpdatePaymentDeliver` | no | P1 | Mark which delivery a payment was tied to |
| Click web-pay | `pay/ClickController::actionIndex` | no | P0 | Customer pays via Click in-app; HMAC verify; insert Payment |
| Payme web-pay | `pay/PaymeController::actionIndex` | no | P0 | Customer pays via Payme JSON-RPC |
| Apelsin web-pay | `pay/ApelsinController::actionIndex` | no | P1 | Customer pays via Apelsin gateway |
| api4 online payment | `api4/OnlinePaymentController` | no | P0 | B2B portal initiates online payment redirect |

### `finans`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Cashbox displacement (move money) | `CashboxDisplacementController::actionSave` | no | P0 | Move money between cashboxes; double-entry |
| Cancel cashbox displacement | `CashboxDisplacementController::actionCancelDisplacement` | no | P1 | Reverse a cashbox displacement; create offset record |
| Payment transfer (reassign) | `PaymentTransferController::actionCreate` / `actionChangeStatus` | no | P0 | Reassign payment to different cashbox/order with approval |
| P&L computation | `PnlController` (`actionGetConsumptions`, `actionGetBadDebts`) | no | P1 | Income / expense / margin per period |
| Pivot P&L compute + save | `PivotPnlController::actionSaveReport` / `actionLoadByProduct` | no | P1 | Slice-and-dice P&L; report-template persistence |
| Agent P&L | `AgentPnlController::actionLoad` | no | P1 | Per-agent profitability rollup |
| Consumption (expense) booking | `ConsumptionController::actionCredit` / `actionSaveReport` | no | P1 | Operational expense entry + reporting |

### `gps` / `gps2` / `gps3`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| GPS sample ingest | `gps/BackendController::actionLast` / `api3/GpsController::actionIndex` | no | P0 | Mobile posts GPS samples ~30 s; persist + index |
| Offline GPS replay | `api3/GpsController::actionOffline` | no | P1 | Bulk replay of buffered samples after reconnect |
| Visit geofence verify | `gps/OrdersGpsController` (consumed by Visit) | yes — sd-main-features.md#d-12 | P0 | Per-visit check that lat/lng is within client radius |
| Live monitoring (web) | `gps/MonitoringController` / `gps2/MonitoringController` / `gps3/ClientController::actionFetchVisits` | no | P1 | Real-time map of agents in a filial |
| Trip playback | `gps/TrackingController::actionRoute` | no | P1 | Replay agent's day on map |
| Out-of-zone reject | `gps/BackendController::actionReject` | no | P0 | Flag + reject visits outside radius for review |
| Route directive (gps3) | `gps3/DirectiveController::actionDirectivePreloader` | no | P2 | Push route updates to gps3 view |

### `integration`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Order export to 1C / Didox / Faktura | `ExportController` (via `ExportInvoiceJob`) | yes — integration.md | P0 | On Loaded/Delivered, dispatch job per provider; backoff on retry |
| Didox e-invoice submit | `DidoxController` | no | P0 | Sign + submit e-invoice; persist Didox response |
| Faktura.uz e-VAT submit | `FakturaController` | no | P0 | EIMZO sign + submit; capture state |
| TraceIQ inbound | `TraceiqController::actionGetPurchases` / `actionGetPurchaseDetails` | no | P1 | Pull trace-purchase data from TraceIQ; upsert |
| Generic 1C catalog import | `ImportController` | no | P0 | Inbound product/category/price; upsert into local |
| Idokon import view | `ViewController::actionIdokon` | no | P2 | Browse Idokon-source records |
| Integration log browser | `ListController` / `GetController` | no | P2 | UI to browse failed jobs and re-trigger |

### `api` (sd-main outbound proxies + 1C bridges)

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Buy packages (call to sd-billing) | `api/LicenseController::actionBuyPackages` | partial — sd-billing/subscription-flow.md | P0 | sd-main posts package buy to sd-billing; receives subscription |
| License delete | `api/LicenseController::actionDelete` | no | P0 | sd-billing notifies sd-main to revoke a licence |
| License pay | `api/LicenseController::actionPay` | no | P0 | Manual licence payment fallback |
| Exchange license | `api/LicenseController::actionExchange` | no | P1 | Swap one package for another within balance |
| 1C JSON order ingest | `api/Json1CController::actionGetOrders` | no | P1 | 1C pulls orders in JSON form |
| Mef1c product/client ingest | `api/Mef1cController::actionSetProducts` / `actionSetClients` / `actionSetPrices` | no | P1 | Mef1c-side push of catalog deltas |
| Mef1c finans push | `api/Mef1cController::actionSetFinans` | no | P1 | Push finance entries from 1C |
| Smartup orders sync | `api/SmartUpController::actionSetOrders` / `actionGetOrders` | no | P1 | Bidirectional Smartup ERP order sync |
| Smartup auth | `api/SmartUpController::actionSaveAuth` / `actionRemoveAuth` | no | P2 | Manage Smartup credentials per tenant |
| Web push registration + send | `api/PushController::actionSave` / `actionSend` | no | P1 | Register service worker; trigger send |
| Cron visit aggregation | `api/CronVisitController::actionWrite` / `actionReWrite` | no | P1 | Daily batch aggregation of visits |
| Telegram bot webhook | `api/TelegramBotController::actionIndex` | no | P1 | Handle inbound Telegram updates |
| Scheduled SMS dispatch (cron) | `api/ScheduledSmsController::actionSend` | no | P1 | Send scheduled SMS batches; mark delivered |
| Notification ingest + ack | `api/NotificationController::actionAcquainted` | no | P2 | Mark a notification as seen |

### `onlineOrder`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Place order via portal | `onlineOrder/OrderController` + `api4/CreateController` | yes — onlineOrder.md | P0 | Customer submits cart; goes through standard order pipeline |
| Online payment redirect | `onlineOrder/PaymentController` | no | P0 | Hand off to Click/Payme/Paynet for online payment |
| Telegram bot webhook | `onlineOrder/TelegramController` | no | P1 | Customer interacts via Telegram; bot translates to order |
| Telegram WebApp host | `onlineOrder/WebAppController` + `WebappBotController` | no | P1 | Embedded SPA inside Telegram for full ordering |
| Scheduled report email | `onlineOrder/ScheduledReportController` | no | P2 | Periodic emailed report digests for B2B customer |

### `sms`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| SMS send (event-trigger) | `MessageController::actionSend` (via SendSmsJob) | yes — sms.md | P0 | Trigger event → enqueue → provider; persist |
| SMS delivery callback (DLR) | `CallbackController::actionItem` | partial — sms.md sequence | P0 | Provider posts DLR; update SmsMessage status |
| SMS template define + check | `TemplateController::actionCreate` / `actionChecking` | no | P1 | Author template; pre-flight validation |
| SMS package buy | `PackageController::actionBuying` + `ViewController::actionBuyingPackage` | no | P1 | Tenant buys SMS package via sd-billing |
| Bulk message send | `MessageController::actionSend` | no | P1 | Cohort send for marketing campaign |

### `dashboard`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Tile read-through cache | `BillingController` / `KpiController` etc. | no | P1 | Read tile from redis_app; fall back to SQL aggregate; cache 60 s |
| Drill-down → report | tile click → matching report controller | no | P1 | Click a tile, jump to filtered report |
| KPI v2 daily | `KpiController::actionDaily` / `actionAjaxOrderDetails` | no | P1 | Day-level KPI rollup with breakdowns |
| Cashier income tile | `KassaIncomeController` | no | P2 | Today's cashier income summary |
| Notifications panel | `NotificationController` | no | P2 | Compute pending notifications for current user |

### `report`

80+ отчётов — одна диаграмма на отчёт была бы расточительной. Опишите
один канонический "report run" flow плюс диаграммы для нескольких отчётов
с нетривиальными computation-пайпами.

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Canonical report run (HTML + Excel) | `BaseReport` | yes — report.md | P0 | Filter form → SQL aggregate → DataTables view → PHPExcel export |
| Bonus accumulation rollup | `BonusAccumulationController` | no | P1 | Multi-month bonus rollup with quarterly settle |
| RFM segmentation | `RfmController` | no | P1 | Compute Recency/Frequency/Monetary tiers |
| Plan-vs-fact expeditor | `PlanExpeditorController` | no | P1 | Expeditor performance against plan |
| Photo report rollup | `PhotoReportController` / `ParentPhotoReportController` | no | P2 | Aggregate photo reports across audits |
| Bonus payout (real bonus) | `RealBonusController` | no | P1 | Compute payable bonus per agent / period |
| Expeditor daily report | `ExpeditorDailyReportController` | no | P2 | Daily summary per expeditor |
| Telegram report bot | `TelegramController` | no | P1 | Push scheduled reports to Telegram channel |

### `planning`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Monthly plan setup | `Monthly2Controller::actionPulseSave` / `actionData` | no | P1 | Define monthly plan per agent / category |
| Daily plan tracking | `DailyController::actionAgent` / `actionTotal` / `actionPercent` | no | P1 | Day-level plan vs actual live update |
| Outlet plan setup | `OutletController::actionSave` / `actionSetup` | no | P1 | Per-outlet plan; rolls into agent plan |
| Recommendation engine | `RecommendationController` | no | P2 | Recommend products to push at next visit |

### `rating`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Rating poll vote | `PollController::actionVote` / `actionComment` | no | P1 | End-customer votes on a rating; comment captured |
| Rating CRUD admin | `IndexController::actionCreateUpdateRating` / `actionDeleteRating` | no | P2 | Admin manages rating questions |

### `markirovka`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Markirovka API ingest | `markirovka/ApiController` | no | P1 | Ingest UZ markirovka codes per SKU; validate |

### `team` / `staff` / `access`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Activate / deactivate user | `team/UserController::actionActive` | no | P1 | Toggle active flag; cascade to sessions |
| Auditor activate | `team/AuditorController::actionActive` | no | P1 | Specialised auditor activation path |
| Bind user to role | `access/BackendController::actionBindUser` / `actionBindAssignments` | no | P0 | RBAC: assign permission group to user; reload authitem cache |
| Reload assignments | `access/BackendController::actionReloadAssignments` | no | P1 | Force authitem hierarchy reload after change |

### `vs` (van-sales)

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| VS create order | `vs/CreateOrderController` | no | P1 | Van-sales-specific order create flow |
| VS edit order | `vs/EditOrderController` | no | P1 | Edit van-sales order (different rules vs standard) |

### `partners`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Partner list (sd-main) | `partners/ListController` | no | P2 | Single-screen partner list; minimal logic |

### `doctor` / `neakb` (legacy / специализированное)

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Coverage compute | `doctor/CoverageController` | no | P2 | Coverage % per agent / period |
| AKB outlet compute | `doctor/AkbController` | no | P2 | Active customer base computation |
| Forecast | `doctor/ForecastController` | no | P2 | Sales forecast per agent |
| Strike computation | `doctor/StrikeController` | no | P2 | Consecutive-miss flag for outlets |
| Personal dashboard | `doctor/PersonalController` | no | P2 | Personal day view for agent |

## Инвентарь sd-billing

### `api` (gateway + S2S)

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Click prepare/confirm | `ClickController::actionIndex` | yes — payment-gateways.md | P0 | Two-phase HMAC-signed prepare/confirm; idempotent insert |
| Payme JSON-RPC | `PaymeController::actionIndex` | yes — payment-gateways.md | P0 | CheckPerform / Create / PerformTransaction; HMAC verify |
| Paynet SOAP | `PaynetController::actionIndex` | partial — payment-gateways.md | P0 | SOAP gateway; insert PaynetTransaction + Payment |
| License buy packages | `LicenseController::actionBuyPackages` | yes — subscription-flow.md | P0 | sd-main calls; validation, Subscription rows, Payment(license), Diler.refresh |
| License batch buy | `LicenseController::actionIndexBatch` | no | P0 | Batch variant of buyPackages; per-row failure isolation |
| License delete | `LicenseController::actionDeleteOne` | no | P0 | Revoke a single subscription |
| License exchange | `LicenseController::actionExchange` | no | P1 | Swap subscription for another within balance |
| License revise | `LicenseController::actionRevise` / `actionDistrRevise` | no | P1 | Reconcile licence usage between distributor and dealer |
| Payments list | `LicenseController::actionPayments` | no | P2 | Read-only payments list |
| Bonus packages grant | `LicenseController::actionBonusPackages` | no | P1 | Grant free seats; mark is_bonus |
| Min-amount check | `LicenseController::actionCheckMin` | no | P1 | Anti-abuse threshold validation |
| 1C cashless add | `Api1CController::actionAddCashless` | no | P1 | 1C posts a cashless payment for a dealer |
| 1C subscriptions read | `Api1CController::actionGetSubscriptions` | no | P2 | 1C pulls dealer's active subscriptions |
| Host status report (sd-main → sd-billing) | `HostController::actionAuth` / `actionActiveHosts` | no | P0 | sd-main reports its server status; sd-billing tracks per-host activity |
| SMS package buy | `SmsController::actionBuySmsPackage` | no | P0 | sd-main buys SMS package; debits Diler.BALANS |
| SMS template create + check | `SmsController::actionCreateTemplate` / `actionCheckingTemplates` | no | P1 | Pre-vet template before allowing send |
| SMS send + forward | `SmsController::actionSend` / `actionSendingForward` | no | P0 | Tenant-side trigger sends via central SMS |
| SMS delivery callback | `SmsController::actionCallback` | no | P0 | Provider DLR callback updates SmsMessage |
| App auth (sd-main) | `AppController::actionAuth` / `actionExecute` | no | P0 | Fixed-user session for sd-main → sd-billing API |
| Quest endpoints | `QuestController::actionDetail` | no | P2 | Custom quest API (specialised) |

### `operation`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Manual payment entry | `operation/PaymentController::actionCreateOrUpdate` | partial — payment-gateways.md | P0 | Operator records P2P / cash / cashless payment; triggers Diler.refresh |
| Subscription CRUD | `operation/SubscriptionController` | no | P1 | Admin edit of dealer subscriptions |
| SubscriptionSMPro CRUD | `operation/SubscriptionSMProController` | no | P2 | SM-Pro tier subscription |
| Package CRUD | `operation/PackageController` | no | P2 | Define purchasable packages |
| PackageSMPro CRUD | `operation/PackageSMProController` | no | P2 | SM-Pro packages |
| Tariff CRUD | `operation/TariffController` | no | P2 | Tariff definitions per country |
| Blacklist toggle | `operation/BlacklistController` | no | P1 | Block dealer / IP / phone from purchases |
| Notification compose + send | `operation/NotificationController::actionSend` / `actionPost` | no | P1 | Compose ops notification; enqueue to dealers |
| Relation manage | `operation/RelationController` | no | P2 | Distributor ↔ dealer agreement edit |

### `dashboard`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Distributor payment create/update | `DistrPaymentController::actionCreateAjax` / `actionUpdateAjax` | no | P0 | Manual distributor payment entry; settles toward dealers |
| Manual payment entry | `dashboard/PaymentController::actionCreateAjax` / `actionUpdateAjax` | no | P0 | Same as operation/Payment but from a different screen |
| Reset / fix server | `ResetController::actionFixServer` / `actionDeleteServer` | no | P1 | Wipe / reset server entry for a dealer |
| Give discount | `FixController::actionGiveDiscount` / `actionGdProgress` | no | P1 | One-off discount applied to a dealer |
| Write-server (push licence file) | `FixController::actionWriteServer` / `actionCheckStatusServer` | no | P0 | Manually push licence file to dealer's sd-main |
| Add operation / add types | `FixController::actionAddOperation` / `actionAddTypes` | no | P2 | One-off ops fix (add a missing operation row) |
| Diler computation refresh | `ComputationController` (called by various) | no | P1 | Recompute BALANS, FREE_TO, MONTHLY for one Diler |
| Distr computation | `DistrComputationController` | no | P1 | Distributor-side computation pipeline |
| Server request (sd-main asks for status) | `ServerController::actionRequest` / `actionCreated` | no | P1 | sd-billing accepts server-status update from sd-main |
| Setting persist | `SettingController` | no | P2 | Dashboard settings save |

### `cashbox`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Cashbox transfer (between desks) | `cashbox/TransferController::actionAdd` / `actionCreateAjax` | no | P0 | Move money between cash desks; double-entry payment |
| Consumption (expense) | `cashbox/ConsumptionController::actionCreateAjax` | no | P1 | Record expense from cash desk |

### `notification`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| In-app notification send | `notification/ViewController::actionSend` | no | P1 | Insert notification row; notify recipient |
| Notification ack | `notification/ViewController::actionTally` | no | P2 | Mark notification as read |

### `partner` (self-service)

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Partner sees their dealers | `partner/DealerController::actionDealer` | no | P1 | Partner-scoped dealer list; access-checked |
| Partner sees subscriptions | `partner/SubscriptionController::actionDealer` | no | P1 | Partner-scoped subscription list |
| Partner sees payments | `partner/PaymentController::actionDealer` | no | P1 | Partner-scoped payment list |

### `report`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Telegram bot report digest | `report/TgBotController` | no | P1 | Hourly/daily report push to Telegram |
| Churn report | `report/ChurnController` | no | P1 | Compute churn cohort and surface KPI |
| Active customers | `report/ActiveCustomersController` | no | P1 | Active dealer count over time |
| PL report | `report/PLController` | no | P1 | sd-billing P&L roll-up |
| Pivot report runner | `report/PivotController` | no | P2 | Generic pivot UI |

### `dbservice`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Run DB maintenance task | `dbservice/ServiceController::actionIndex` | no | P2 | Ad-hoc data fix scripts; admin only |

### Cron-команды (single-tenant)

| Feature / flow | Source | Existing diagram? | Priority | One-line sketch |
|----------------|--------|-------------------|----------|-----------------|
| `notify` cron drain | `commands/NotifyCommand` (every minute) | yes — cron-and-settlement.md | P0 | Drain d0_notify_cron; route to Telegram or license-delete |
| `settlement` cron | `commands/SettlementCommand` (daily 01:00) | yes — cron-and-settlement.md | P0 | Distributor ↔ dealer monthly debt computation; double-entry Payment rows |
| `botLicenseReminder` cron | `commands/BotLicenseReminderCommand` (daily 09:00) | no | P0 | Notify dealers 7/3/1 days before expiry |
| `cleanner` cron | `commands/CleannerCommand` (Sat 22:00) | no | P1 | Weekly cleanup of stale subscriptions etc. |
| `pradata` cron (HTTP pull) | external curl from salesdoc.io (05:30/05:40/05:50) | no | P1 | External instance pulls pre-computed data via HTTP |

## Инвентарь sd-cs

### `api` (S2S-эндпоинты + интеграторы)

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Cislink generate + upload | `api/CislinkController::actionGenerate` / `actionUpload` | no | P1 | Generate Cislink-format export and upload via SFTP |
| Cislink status poll | `api/CislinkController::actionStatus` / `actionLog` | no | P2 | Check sync status; browse log |
| Isellmore upload | `api/IsellmoreController::actionUploadToISM` / `actionUpload2` | no | P1 | Push HQ-side stocks/sales to Isellmore |
| Isellmore generate | `api/IsellmoreController::actionGenerate` | no | P1 | Generate Isellmore export payload |
| Isellmore checksum | `api/IsellmoreController::actionChecksum` | no | P2 | Verify upload integrity |
| Lianeksstock receipt/sales/return | `api/LianeksstockController::actionSales` / `actionReceipt` / `actionReturn` | no | P1 | Lianeks stock-feed exchange |
| Pradata generate + upload | `api/PradataController::actionGenerate` / `actionUpload` | no | P1 | HQ pre-compute → upload to upstream |
| Operator: fix prices | `api/OperatorController::actionFixPrices` | no | P2 | Mass-correct prices in `cs_*` |
| Operator: cleaner | `api/OperatorController::actionCleaner` | no | P2 | Ad-hoc admin cleanup tool |
| Telegram report cron | `api/TelegramReportController::actionCron` | no | P1 | Daily HQ Telegram digest push |
| Billing status pull | `api/BillingController::actionStatus` | no | P1 | Pull billing status from sd-billing for HQ summary |

### `report` + `pivot` (cross-dealer)

Весь модуль — это канонический паттерн "swap dealer connection in a loop";
одна диаграмма для паттерна + несколько для нетривиальных отчётов.

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Cross-dealer report (canonical) | base pattern in any `report/*Controller` | yes — sd-cs/sd-main-integration.md | P0 | DealerRegistry → loop swap connection → narrow SELECT → PHP fold → cache |
| Cross-dealer pivot report | `pivot/SaleController` / `pivot/RfmController` | no | P0 | Heavier pivot variant of canonical pattern |
| AKB / OKB analyse | `report/AkbController` / `report/AnalyzeAkbController` / `report/OkbController` | no | P1 | Active vs total client base over period |
| Plan vs fact (HQ) | `report/PlanController` / `report/PlanProductController` | no | P1 | HQ-level plan vs actual roll-up |
| Bonus sale / summary bonus | `report/BonusSaleController` / `report/SummaryBonusController` | no | P1 | HQ bonus rollup |
| Photo gallery (HQ) | `report/PhotoController` | no | P2 | HQ photo gallery across dealers |
| Movement | `report/MovementController` | no | P2 | Stock movement HQ rollup |
| Licence | `report/LicenceController` | no | P1 | HQ-level licence usage and renewal status |
| Log (cs_dblog) | `report/LogController` | no | P2 | Audit log of cross-DB queries |

### `dashboard`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| HQ daily KPI tile | `dashboard/DailyController::actionGetData` / `actionGetDataSale` | no | P1 | Fetch HQ daily KPI; same swap-dealer pattern under the hood |
| Supervayzer monitor | `dashboard/SupervayzerController` | no | P2 | HQ supervisor dashboard |

### `directory`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| Dealer registry CRUD | `directory/DealerController` | yes — sd-main-integration.md (onboarding) | P0 | Add/edit dealer DSN + capability flags |
| HQ catalog CRUD (brand/segment etc.) | `directory/AdtBrandController`, `directory/AdtSegmentController`, etc. | no | P2 | Master catalog edited centrally |
| Country category | `directory/CountryController` / `directory/ClientCategoryController` | no | P2 | Country-level reference data |

### `user` / `api3`

| Feature / flow | Source (controller / action) | Existing diagram? | Priority | One-line sketch |
|----------------|------------------------------|-------------------|----------|-----------------|
| HQ user login | `user/LoginController::actionIndex` | no | P1 | Login against cs_user; multi-DB session |
| Set / get user access | `user/DefaultController::actionSetAccess` / `actionGetAccess` | no | P1 | Manage HQ user permissions |
| User cron sync | `user/CroneController::actionIndex` | no | P2 | Periodic user data sync |
| api3 manager endpoint | `api3/ManagerController::actionIndex` | no | P2 | HQ-side mobile/assistant endpoint (single action today) |

## Cross-project integration flow

Это самые leverage-диаграммы для авторства — каждая из них охватывает 2 или
3 проекта и о ней первым делом спрашивают новые инженеры.

| # | Flow | Path | Existing diagram? | Priority | One-line sketch |
|---|------|------|-------------------|----------|-----------------|
| X1 | Buy packages (full round-trip) | sd-main `api/license/buyPackages` → sd-billing `api/license/buyPackages` → Subscription + Payment(license) → Diler.refresh → Server.STATUS push back to sd-main | partial — sd-billing/subscription-flow.md | P0 | Dealer's sd-main posts package buy; sd-billing validates, writes Subscription + Payment, refreshes Diler, pushes licence file back |
| X2 | License renewal + expiry notify | sd-billing `botLicenseReminder` cron → Telegram + SMS → optionally `Diler.deleteLicense()` → sd-main reads new licence | no | P0 | Days-to-expiry tier triggers notify; on expiry the licence file flips |
| X3 | Online gateway (Click) end-to-end | Click → sd-billing `api/click` (prepare + confirm) → Payment(clickonline) → BALANS += summa → Diler.refresh → Server STATUS=SENT → sd-main licence refresh | yes — payment-gateways.md (sd-billing side) | P0 | Customer pays; gateway hits sd-billing; balance grows; new licence pushed to dealer |
| X4 | Online gateway (Payme) end-to-end | similar to X3 but Payme JSON-RPC | yes — payment-gateways.md | P0 | Equivalent flow with Payme; idempotency keyed on PaymeTransaction |
| X5 | Online gateway (Paynet) end-to-end | similar to X3 with SOAP | partial — payment-gateways.md | P0 | Equivalent flow with Paynet via paynetuz extension |
| X6 | Settlement → distribute → notify | sd-billing `cron settlement` → Payment(distribute) pair → LogDistrBalans → Telegram summary | yes — cron-and-settlement.md | P0 | Daily distributor↔dealer netting; double-entry payments; ops notified |
| X7 | Phone directory sync | sd-billing → sd-main `api/billing/phone` | no | P0 | sd-billing pushes phone-directory updates to sd-main on change |
| X8 | sd-cs cross-dealer report | sd-cs `report/*` → swap `Yii::app()->dealer` → query each dealer DB → PHP fold → cache | yes — sd-main-integration.md | P0 | Canonical multi-DB read pattern: HQ reads from N dealer DBs read-only |
| X9 | New-dealer onboarding (full chain) | contract → sd-billing `Diler` row → licence file → sd-main provisioned → DSN → DealerRegistry in cs_* → smoke report | yes — sd-main-integration.md | P0 | End-to-end provisioning chain across all three projects |
| X10 | SMS round-trip (sd-main → sd-billing → provider → callback) | sd-main `sms/MessageController::actionSend` → sd-billing `api/sms/send` → Eskiz/Mobizon → callback (`api/sms/callback`) → status flows back to sd-main | partial — sms.md sequence | P0 | Tenant SMS goes through central SMS service for cost rollup; DLR rounds back to dealer |

## Рекомендуемый порядок авторства

### Первый батч (P0, наибольший leverage) — 30 flow

1. Order create (web) — уже сделано; обновить против orders.md
2. Order create (mobile) — уже частично
3. Order status transition diagram (полный state machine) — уже сделано
4. Defect on delivery — уже сделано; рассмотреть подтяжку
5. Order export (1C / Didox / Faktura) — уже сделано
6. Buy packages full round-trip (X1)
7. License renewal + expiry notify (X2)
8. Click full round-trip (X3)
9. Payme full round-trip (X4)
10. Paynet full round-trip (X5)
11. Settlement → distribute → notify (X6) — уже сделано
12. Phone directory sync (X7)
13. SMS round-trip across projects (X10)
14. New-dealer onboarding (X9) — уже сделано
15. sd-cs cross-dealer report (X8) — уже сделано
16. Stock reservation atomic op (sd-main)
17. Cashbox displacement / Payment transfer (sd-main finans)
18. Cashbox transfer (sd-billing)
19. Manual payment entry (sd-billing operation/dashboard)
20. Distributor payment create/update (sd-billing)
21. Write-server / push licence file (sd-billing FixController)
22. License delete (sd-billing → sd-main)
23. Visit + GPS geofence — уже сделано; верифицировать против реальности gps3
24. Out-of-zone reject — выявляет sub-flow
25. Goods receipt — уже сделано
26. Stock transfer + inter-filial movement (две диаграммы)
27. Stocktake reconciliation + post adjustments — уже сделано
28. Audit submission — уже сделано
29. RBAC bind user / reload assignments
30. SMS DLR callback (sd-main + sd-billing parity)

### Второй батч (P1 supporting) — 41 flow

Сгруппировано по owner-у модуля, чтобы авторство можно было делать в
параллельных батчах:

- **orders** — Edit, Status batch, Cancel, Reject + comment, Replace, Excel import, Bonus order, Movement between filials, Expeditor load planning
- **clients** — Field-created (mobile), Revise, Transactions ledger, Tara docs, Inventorisation, Stock-base
- **agents** — Daily KPI compute, Limit enforcement, Reception, Task assignment, Supervayzer dashboard
- **finans** — P&L, Pivot P&L save, Agent P&L, Consumption booking
- **inventory** — Photo evidence
- **stock** — Buy/purchase, Exchange between stores, Excretion, VS exchange + return
- **integration** — TraceIQ inbound, Generic 1C catalog import
- **sd-billing api** — License batch buy, License revise, Bonus packages, SMS package buy, SMS send, SMS DLR callback, Min-amount check
- **sd-billing operation** — Subscription CRUD, Blacklist toggle, Notification compose + send
- **sd-billing dashboard** — Diler computation refresh, Distr computation, Server-status request, Reset server, Give discount
- **sd-billing cron** — botLicenseReminder, cleanner, pradata
- **sd-cs api** — Cislink generate, Isellmore upload, Lianeksstock, Pradata, Telegram report cron, Billing status pull
- **sd-cs reports** — AKB / OKB analyse, Plan vs fact, Bonus sale / summary bonus, Licence usage
- **report (sd-main)** — Bonus accumulation rollup, RFM, Plan-vs-fact expeditor, Real bonus payout, Telegram report bot

### Третий батч (P2 edge cases) — 26+ flow

Bulk-импорты, архив, dbservice, ретраи, settings-панели, single-action
контроллеры, legacy-flagged модули (`doctor`, `neakb`, `manager`,
sync-obsolete). Это nice-to-have для полноты, и нужны диаграммы только
когда underlying logic нетривиален; CRUD-only записи могут оставаться
текстовыми.

## Как использовать инвентарь

- **PM** — выбирайте следующий батч, скимая P0/P1. Cross-project
  X-строки — наибольший внешний leverage.
- **Tech leads** — подтверждайте, что приоритеты отражают текущий sprint
  focus; переопределяйте отдельные строки в комментариях PR.
- **Doc maintainers** — когда Mermaid-блок приземлится внутри source-страницы
  модуля, измените ячейку строки "Existing diagram?" — пусть цитирует
  doc + section anchor, затем переместите строку из backlog-батча в
  таблицу "Уже сделано" в начале.
- **Engineers, пишущие диаграммы** — см.
  [Стандарты дизайна воркфлоу](./team/workflow-design.md) для 12
  принципов. Парьтесь с одной из существующих диаграмм в
  `docs/diagrams/sd-main-features.md`, чтобы скопировать styling cookbook.

## Заметки о том, чего *нет* в инвентаре

- **Pure CRUD** — `directory/*`, `partner/View*`, settings-формы,
  классические list/edit/delete действия. Нет ценности диаграммы за
  пределами одного предложения.
- **Внутренние хелперы** — `actionGetData`, `actionFetch*`, AJAX
  form-preloader. Они служат parent-flow и должны быть нарисованы
  (если вообще) внутри этого parent.
- **Тестовые эндпоинты** — `actionTest`, контроллеры `*Test.php`. Не
  цель для авторства.
- **Obsolete-файлы** — всё, заканчивающееся на `.obsolete`. Исключены
  напрямую.
- **Legacy-поколения** — действия `gps` и `gps2` перечислены только там,
  где они всё ещё в production у некоторых тенантов; новые диаграммы
  должны таргетить `gps3`.
