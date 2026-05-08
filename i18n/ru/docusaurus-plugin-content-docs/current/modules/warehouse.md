---
sidebar_position: 5
title: warehouse
audience: Backend engineers, QA, PM
summary: Многоскладские операции — приёмки, перемещения, сборка, отгрузка и межфилиальные перемещения.
topics: [warehouse, receipt, transfer, dispatch, multi-warehouse]
---

# Модуль `warehouse`

Многоскладские операции: **приёмки** (товары на вход), **перемещения**
(между складами или филиалами), **сборка / отгрузка** (для заказов)
и **межфилиальные перемещения**.

## Ключевые возможности

| Возможность | Что делает | Роль(и) владельца |
|---------|--------------|---------------|
| Приёмка товара | Добавление нового документа приёмки; остаток += количество | 1 / 2 / 9 / складские сотрудники |
| Типы приёмки | `sales` / `defect` / `reserve` (разные downstream-эффекты) | 1 / 9 |
| Перемещение остатков | Перемещение остатков между двумя складами внутри одного филиала | 1 / 9 |
| Филиальное перемещение | Перемещение остатков между филиалами (межфилиальное) | 1 |
| Сборка и упаковка | Резервирование и загрузка строк под заказ при выполнении | 1 / 9 / складские сотрудники |
| Аудиторский след | У каждого документа есть метки времени create/approve/post | system |
| Синхронизация с 1С | Опциональный исходящий XML/JSON приёмок и перемещений | system |

## Папка

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

## Концепции

- **Склад (Warehouse)** — физическое или логическое место хранения остатков.
- **Документ** — юридический/операционный бумажный след движения остатков
  (приёмка / перемещение / списание / инвентаризация).
- **Строка остатков** — `(warehouse_id, product_id, lot, batch, count)`.
- **Резервирование** — количество, заблокированное `Order` в статусе `Reserved`.

## Ключевой поток функционала — приёмка товара

См. **Feature · Warehouse + Stock + Inventory** в
[FigJam · sd-main · Feature Flows](https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU).

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

## Права доступа

| Действие | Роли |
|--------|-------|
| Создание приёмки | 1 / 2 / 9 |
| Утверждение перемещения | 1 / 2 / 9 |
| Межфилиальное перемещение | 1 |

## См. также

- [`stock`](./stock.md) — чисто количественные операции
- [`inventory`](./inventory.md) — физические инвентаризации
- [`store`](./store.md) — операции на стороне розничного магазина

## Воркфлоу

### Точки входа

| Триггер | Контроллер / Действие / Задача | Замечания |
|---|---|---|
| Web | `AddController::actionIndex` | Создание нового `Store` (склада) — POST JSON |
| Web | `FilialMovementController` через `CreateRequest` | Запрашивающий филиал отправляет межфилиальный запрос на остатки |
| Web | `FilialMovementController` через `ApproveRequest` | Поставляющий филиал утверждает ожидающий запрос и создаёт downstream-документ |
| Web | `FilialMovementController` через `ChangeStatus` | Жизненный цикл Draft → Pending → Cancelled / Rejected |
| Web | `ApiController` через `CreatePurchaseDraftAction` | Mobile/web отправляет черновик закупки на проверку менеджером |
| Web | `ApiController` через `AcceptPurchaseDraftAction` | Менеджер принимает черновик; `PurchaseDraftService::createPurchase` конвертирует в `Purchase` |
| Web | `ApiController` через `CreateAdjustmentAction` | Кладовщик создаёт корректировку остатков (`StoreCorrector`) |

### Доменные сущности

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

### Воркфлоу 1.1 — Жизненный цикл межфилиального запроса на перемещение остатков

Запрашивающий филиал создаёт запрос на остатки, поставляющий филиал утверждает его, и атомарно записывается `PurchaseRefund` (type=movement) или `Order` (type=primary).

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

### Воркфлоу 1.2 — Проверка и приёмка черновика закупки

Черновик закупки отправляется (обычно из мобильного приложения или web) и находится в статусе=pending, пока менеджер не примет или не отклонит его. Приёмка вызывает `PurchaseDraftService::createPurchase`, который пишет канонический `Purchase` + `PurchaseDetail` + `ShipperTransaction` и обновляет цены.

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

### Воркфлоу 1.3 — Корректировка остатков (StoreCorrector)

Кладовщик или складской менеджер записывает ручную корректировку остатков через `CreateAdjustmentAction`. Таблица `StoreCorrector` использует структуру строк родитель/потомок: заголовочная строка имеет `PARENT='0'`, строки деталей ссылаются на неё через `CORRECTOR_ID`.

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

### Межмодульные точки соприкосновения

- Чтения: `models.FilialClient` (поиск виртуального клиента при утверждении primary-типа в `ApproveRequest::createPrimaryDocument`)
- Чтения: `models.PriceType`, `PriceService::getPrices` (резолв цены в `PurchaseDraftService` и `ApproveRequest`)
- Чтения: `models.TradeDirection` (валидация trade-direction в `CreateRequest`)
- Записи: `models.Order` + `models.OrderDetail` (primary-запрос филиала → новый заказ продажи в `ApproveRequest::createPrimaryDocument`)
- Записи: `models.PurchaseRefund` + `models.PurchaseRefundDetail` (запрос на филиальное перемещение → возврат остатков в `ApproveRequest::createMovementDocument`)
- Записи: `models.FilialOrder` через `FilialOrder::createMovement` (мост документа перемещения к запрашивающему филиалу)
- Записи: `models.ShipperTransaction` (запись в книге долгов поставщика в `PurchaseDraftService::createDocument`)
- API: `warehouse/api/get-stock-balance` — вызывается внутренне `ApproveRequest` через `WarehouseService::getStockBalance`

### Подводные камни

- `FilialMovementRequest::STATUS_APPROVED` — терминальный — `ChangeStatus` жёстко блокирует любую дальнейшую смену статуса. Попытка отменить или отклонить утверждённый запрос возвращает `ERROR_CODE_INVALID_STATUS`.
- `ApproveRequest::createMovementDocument` жёстко прописывает `DILER_ID = "d0_1"` и `FILIAL_ID = 1` для `PurchaseRefund`; это сломается в multi-diler развёртываниях.
- `PurchaseDraftService::createPurchase` вызывает `$purchaseModel->tgNotify()` — побочный эффект уведомления Telegram; убедитесь, что токен бота настроен, иначе вызов молча падает, но не откатывает транзакцию.
- `CreateAdjustmentAction.php` найден пустым (1 строка) в текущей ветке (`btx-51207`). Действия list и get корректно ссылаются на `StoreCorrector`, но создание может быть в работе.
- Действие `delete-purchase-draft` намеренно отключено в `ApiController` (закомментировано с пометкой "disabled by now").
- `WarehouseService::getStockBalance` не блокирует строки; возможна гонка между проверкой доступности и вставкой `PurchaseRefund` внутри `ApproveRequest`.
