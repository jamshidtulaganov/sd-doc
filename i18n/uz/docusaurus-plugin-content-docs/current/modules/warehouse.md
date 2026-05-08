---
sidebar_position: 5
title: warehouse
audience: Backend engineers, QA, PM
summary: Ko'p omborli operatsiyalar — qabul qilish, ko'chirish, terish, jo'natish va filiallar aro harakatlar.
topics: [warehouse, receipt, transfer, dispatch, multi-warehouse]
---

# `warehouse` moduli

Ko'p omborli operatsiyalar: **qabul qilish** (tovarlar kelishi), **ko'chirish** (omborlar yoki filiallar o'rtasida), **terish / jo'natish** (buyurtmalar uchun), va **filiallar aro harakatlar**.

## Asosiy xususiyatlar

| Xususiyat | Nima qiladi | Egasi rol(lar) |
|---------|--------------|---------------|
| Tovar qabul qilish | Yangi qabul hujjati qo'shish; zaxira += miqdor | 1 / 2 / 9 / ombor xodimi |
| Qabul turlari | `sales` / `defect` / `reserve` (turli oqibatlar) | 1 / 9 |
| Zaxira ko'chirish | Bir filial ichida ikki ombor o'rtasida zaxira ko'chirish | 1 / 9 |
| Filial harakati | Filiallar o'rtasida zaxira ko'chirish (filiallar aro) | 1 |
| Terish va paketlash | Buyurtma bajarish vaqtida satrlarni rezerv qilish va yuklash | 1 / 9 / ombor xodimi |
| Audit izi | Har bir hujjatda yaratish/tasdiqlash/post vaqt belgilari bor | tizim |
| 1C sinxronizatsiyasi | Qabul va harakatlarning ixtiyoriy tashqi XML/JSON | tizim |

## Papka

```
protected/modules/warehouse/
├── controllers/
│   ├── AddController.php
│   ├── EditController.php
│   ├── ListController.php
│   ├── ViewController.php
│   ├── ExchangeController.php           # transfer
│   ├── FilialMovementController.php     # inter-filial
│   └── ApiController.php
└── views/
```

## Tushunchalar

- **Ombor (Warehouse)** — jismoniy yoki mantiqiy zaxira joylashuvi.
- **Hujjat (Document)** — zaxira harakatining huquqiy/operatsion qog'oz izi (qabul / ko'chirish / hisobdan chiqarish / inventarizatsiya).
- **Zaxira qatori (Stock row)** — `(warehouse_id, product_id, lot, batch, count)`.
- **Rezervatsiya (Reservation)** — `Reserved` statusidagi `Order` tomonidan bloklangan miqdor.

## Asosiy xususiyat oqimi — Tovar qabul qilish

[FigJam · sd-main · Feature Flows](https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU) ichida **Feature · Warehouse + Stock + Inventory** ga qarang.

```mermaid
flowchart LR
  S(["Open Add doc"]) --> WT["Pick warehouse + type"]
  WT --> ADD["Scan/pick lines"]
  ADD --> SAV["Save doc"]
  SAV --> POST["Stock += count"]
  POST --> SYNC[("Optional 1C sync")]

  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000

  class S,WT,ADD,SAV,POST action
  class SYNC external
```

## Ruxsatlar

| Amal | Rollar |
|--------|-------|
| Qabul yaratish | 1 / 2 / 9 |
| Ko'chirishni tasdiqlash | 1 / 2 / 9 |
| Filiallar aro harakat | 1 |

## Shuningdek qarang

- [`stock`](./stock.md) — sof miqdor operatsiyalari
- [`inventory`](./inventory.md) — jismoniy inventarizatsiya hisoblari
- [`store`](./store.md) — chakana do'kon tomonidagi operatsiyalar

## Workflow'lar

### Kirish nuqtalari

| Trigger | Controller / Action / Job | Izohlar |
|---|---|---|
| Web | `AddController::actionIndex` | Yangi `Store` (ombor) yaratish — POST JSON |
| Web | `FilialMovementController` via `CreateRequest` | So'rovchi filial filiallar aro zaxira so'rovini yuboradi |
| Web | `FilialMovementController` via `ApproveRequest` | Ta'minotchi filial kutilayotgan so'rovni tasdiqlaydi va keyingi hujjat yaratadi |
| Web | `FilialMovementController` via `ChangeStatus` | Draft → Pending → Cancelled / Rejected hayot davri |
| Web | `ApiController` via `CreatePurchaseDraftAction` | Mobil/web menejer ko'rib chiqishi uchun xarid qoralamasini yuboradi |
| Web | `ApiController` via `AcceptPurchaseDraftAction` | Menejer qoralamani qabul qiladi; `PurchaseDraftService::createPurchase` `Purchase` ga aylantiradi |
| Web | `ApiController` via `CreateAdjustmentAction` | Ombor xodimi zaxira tuzatishini (`StoreCorrector`) yaratadi |

### Soha entitylari

```mermaid
erDiagram
    FilialMovementRequest {
        int ID PK
        int REQUESTER_FILIAL_ID FK
        int PROVIDER_FILIAL_ID FK
        int TYPE "1=movement 2=primary"
        int STATUS "1=draft 2=pending 3=approved 4=rejected 5=cancelled"
        string RESULT_DOC_ID FK
        int STORE_ID FK
        int TRADE_ID FK
    }
    FilialMovementRequestDetail {
        int ID PK
        int REQUEST_ID FK
        string PRODUCT_ID FK
        float QUANTITY
        float APPROVED_QUANTITY
        float PRICE
    }
    PurchaseDraft {
        int ID PK
        int STORE_ID FK
        int SHIPPER_ID FK
        int PRICE_TYPE_ID FK
        int STATUS "1=pending 2=confirmed 3=rejected 4=deleted"
        json DETAILS
    }
    Purchase {
        string PURCHASE_ID PK
        int STORE_ID FK
        int SHIPPER_ID FK
        int STATUS
        float SUMMA
    }
    StoreCorrector {
        string CORRECTOR_ID PK
        string STORE_ID FK
        string PRODUCT_ID FK
        float COUNT
        int TYPE "1=inventory 2=adjustment"
        string PARENT "0 = header row"
    }
    FilialMovementRequest ||--o{ FilialMovementRequestDetail : "has lines"
    PurchaseDraft ||--|| Purchase : "accepted into"
    StoreCorrector ||--o{ StoreCorrector : "parent/child lines"
```

### Workflow 1.1 — Filiallar aro zaxira harakati so'rovi hayot davri

So'rovchi filial zaxira so'rovini yaratadi, ta'minotchi filial uni tasdiqlaydi va `PurchaseRefund` (type=movement) yoki `Order` (type=primary) atomik tarzda yoziladi.

```mermaid
sequenceDiagram
    participant Web
    participant FilialMovementController
    participant CreateRequest
    participant ChangeStatus
    participant ApproveRequest
    participant WarehouseService
    participant DB

    Web->>FilialMovementController: POST /warehouse/filial-movement/create-request
    FilialMovementController->>CreateRequest: run()
    CreateRequest->>CreateRequest: validateProviderFilialId()
    CreateRequest->>CreateRequest: validateAndConvertType()
    CreateRequest->>CreateRequest: validateItems() — lookup Product, TradeDirection
    CreateRequest->>DB: INSERT filial_movement_request STATUS=1 (draft)
    CreateRequest->>DB: INSERT filial_movement_request_detail x N
    CreateRequest-->>Web: {request_id}

    Web->>FilialMovementController: POST /warehouse/filial-movement/change-status {status:"pending"}
    FilialMovementController->>ChangeStatus: run()
    ChangeStatus->>ChangeStatus: validateStatusChange() draft to pending
    ChangeStatus->>ChangeStatus: validateAccess() requester filial only
    ChangeStatus->>DB: UPDATE filial_movement_request STATUS=2

    Web->>FilialMovementController: POST /warehouse/filial-movement/approve-request
    FilialMovementController->>ApproveRequest: run()
    ApproveRequest->>ApproveRequest: validateProviderAccess() provider filial only
    ApproveRequest->>WarehouseService: getStockBalance(store_id)
    ApproveRequest->>ApproveRequest: validateStockAvailability()
    alt TYPE_MOVEMENT
        ApproveRequest->>DB: INSERT purchase_refund TYPE=movement
        ApproveRequest->>DB: INSERT purchase_refund_detail x N
        ApproveRequest->>DB: INSERT filial_order via FilialOrder::createMovement()
    else TYPE_PRIMARY
        ApproveRequest->>DB: INSERT order via FilialClient virtual client
        ApproveRequest->>DB: INSERT order_detail x N
    end
    ApproveRequest->>DB: UPDATE filial_movement_request STATUS=3, RESULT_DOC_ID
    ApproveRequest-->>Web: {request_id, result_doc_id}
```

### Workflow 1.2 — Xarid qoralamasini ko'rib chiqish va qabul qilish

Xarid qoralamasi yuboriladi (odatda mobil ilova yoki web dan) va menejer qabul qilmaguncha yoki rad etmaguncha status=pending da qoladi. Qabul qilish `PurchaseDraftService::createPurchase` ni chaqiradi, u esa kanonik `Purchase` + `PurchaseDetail` + `ShipperTransaction` ni yozadi va narxlarni yangilaydi.

```mermaid
flowchart TD
    A(["Web: POST /warehouse/api/create-purchase-draft"]) --> B[CreatePurchaseDraftAction::run]
    B --> C{Date within close date?}
    C -- No --> ERR1[send ERROR_CODE_OUT_OF_CLOSE_DATE]
    C -- Yes --> D["setPriceType — validate PriceType.TYPE=1"]
    D --> E["setWarehouse — Store.ACTIVE=Y, VAN_SELLING=0, STORE_TYPE in 1/5"]
    E --> F["setSupplier — Shipper.ACTIVE=Y"]
    F --> G[preparePurchaseItems — aggregate by product/lot/price]
    G --> H[INSERT purchase_draft STATUS=1 DETAILS=json_encode items]

    H --> I(["Web: POST /warehouse/api/accept-purchase-draft ids"])
    I --> J[AcceptPurchaseDraftAction::run]
    J --> K[PurchaseDraftService::createPurchase per draft]
    K --> L[INSERT purchase STATUS=3]
    K --> M[INSERT purchase_detail x N]
    K --> N[INSERT shipper_transaction SUMMA negative]
    K --> O["PriceService::setPrices purchase price_type"]
    O --> P{selling_price_type_id set?}
    P -- Yes --> Q["PriceService::setPrices selling price_type"]
    P -- No --> R[UPDATE purchase_draft STATUS=2 confirmed]
    Q --> R

    H --> S(["Web: POST /warehouse/api/reject-purchase-draft ids"])
    S --> T[RejectPurchaseDraftAction::run]
    T --> U[UPDATE purchase_draft STATUS=3 rejected]
```

### Workflow 1.3 — Zaxira tuzatish (StoreCorrector)

Ombor xodimi yoki ombor menejeri `CreateAdjustmentAction` orqali qo'lda zaxira tuzatishini qayd etadi. `StoreCorrector` jadvali parent/child qator strukturasidan foydalanadi: sarlavha qatorida `PARENT='0'`, detal qatorlari unga `CORRECTOR_ID` orqali murojaat qiladi.

```mermaid
sequenceDiagram
    participant Web
    participant ApiController
    participant CreateAdjustmentAction
    participant DB

    Web->>ApiController: POST /warehouse/api/create-adjustment
    ApiController->>CreateAdjustmentAction: run()
    CreateAdjustmentAction->>CreateAdjustmentAction: authenticate() authorize(operation.stock.corrector)
    CreateAdjustmentAction->>DB: SELECT store WHERE STORE_ID — validate warehouse exists
    CreateAdjustmentAction->>DB: INSERT store_corrector PARENT=0 TYPE header row
    loop each product line
        CreateAdjustmentAction->>DB: INSERT store_corrector PARENT=corrector_id detail line
    end
    CreateAdjustmentAction-->>Web: {corrector_id}

    Web->>ApiController: GET /warehouse/api/list-adjustments?from=&to=
    ApiController->>CreateAdjustmentAction: ListAdjustmentsAction::run()
    Note over CreateAdjustmentAction,DB: JOIN store_corrector header + detail rows, GROUP BY CORRECTOR_ID
    CreateAdjustmentAction->>DB: SELECT store_corrector AS doc JOIN store_corrector AS det
    DB-->>Web: [{id, warehouse_id, date, quantity, summa}]
```

### Modullar aro tutash nuqtalari

- O'qiydi: `models.FilialClient` (`ApproveRequest::createPrimaryDocument` da primary-type tasdiqlash davomida virtual mijoz qidiruvi)
- O'qiydi: `models.PriceType`, `PriceService::getPrices` (`PurchaseDraftService` va `ApproveRequest` da narx aniqlash)
- O'qiydi: `models.TradeDirection` (`CreateRequest` da savdo yo'nalishini tasdiqlash)
- Yozadi: `models.Order` + `models.OrderDetail` (`ApproveRequest::createPrimaryDocument` da filial primary so'rovi → yangi savdo buyurtmasi)
- Yozadi: `models.PurchaseRefund` + `models.PurchaseRefundDetail` (`ApproveRequest::createMovementDocument` da filial harakati so'rovi → zaxira refund)
- Yozadi: `models.FilialOrder` `FilialOrder::createMovement` orqali (harakat hujjatini so'rovchi filialga ulaydi)
- Yozadi: `models.ShipperTransaction` (`PurchaseDraftService::createDocument` da yetkazib beruvchi qarz ledger yozuvi)
- API'lar: `warehouse/api/get-stock-balance` — `ApproveRequest` tomonidan `WarehouseService::getStockBalance` orqali ichki chaqiriladi

### Tuzoqlar

- `FilialMovementRequest::STATUS_APPROVED` terminal — `ChangeStatus` har qanday keyingi status o'zgartirishni qattiq bloklaydi. Tasdiqlangan so'rovni bekor qilish yoki rad etishga urinish `ERROR_CODE_INVALID_STATUS` ni qaytaradi.
- `ApproveRequest::createMovementDocument` `PurchaseRefund` ga `DILER_ID = "d0_1"` va `FILIAL_ID = 1` ni qattiq kodlaydi; bu ko'p-diler joylashtirishlarda buziladi.
- `PurchaseDraftService::createPurchase` `$purchaseModel->tgNotify()` ni chaqiradi — Telegram bildirishnoma yon ta'siri; bot tokeni sozlanganligiga ishonch hosil qiling, aks holda chaqiruv jim ravishda muvaffaqiyatsiz bo'ladi, lekin tranzaksiyani rollback qilmaydi.
- `CreateAdjustmentAction.php` joriy branchda (`btx-51207`) bo'sh (1 qator) topildi. Ro'yxat va get action'lari `StoreCorrector` ga to'g'ri murojaat qiladi, lekin yaratish work-in-progress bo'lishi mumkin.
- `delete-purchase-draft` action `ApiController` da ataylab o'chirilgan ("disabled by now" izohi bilan).
- `WarehouseService::getStockBalance` qatorlarni qulflamaydi; `ApproveRequest` ichidagi mavjudlik tekshiruvi va `PurchaseRefund` insert orasida poyga sharti mumkin.
