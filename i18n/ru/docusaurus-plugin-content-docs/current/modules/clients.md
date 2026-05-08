---
sidebar_position: 3
title: clients
audience: Backend engineers, QA, PM
summary: База клиентов (точек/ритейлеров), договоры, сегменты, снимки долга, гео-координаты и членство в маршрутах.
topics: [clients, crm, b2b, route, geofence]
---

# Модуль `clients`

Управляет **базой клиентов** в sd-main: B2B-точки, ритейлеры,
HoReCa, плюс вспомогательные доменные объекты — договоры, сегменты, долг,
гео-локация и членство в маршрутах.

## Ключевые возможности

| Возможность | Что делает | Роль(и) владельца |
|---------|--------------|---------------|
| CRUD клиента | Создание / редактирование / архивация записей клиента | 1 / 2 / 5 / 9 |
| Клиенты, созданные в поле (мобильный) | Агент отправляет нового клиента во время визита; запись попадает в *Pending* | 4 |
| Утверждение клиента | Менеджер просматривает ожидающие записи; утвердить / отредактировать / отклонить | 1 / 2 / 9 |
| Категории и сегменты | Уровни клиентов по сегменту продаж; влияет на тип цены и скидку | 1 / 9 |
| Договоры | Опциональные коммерческие договоры на клиента (условия, дни оплаты) | 1 / 9 |
| Гео-координаты | `LAT` / `LNG` у каждого клиента; используется `gps` для геофенсинга | 1 / 4 |
| Членство в маршрутах | Клиенты группируются в маршруты, назначенные агентам | 8 / 9 |
| Снимок долга | Расчётное старение дебиторки в отчётах | 6 / 9 |
| Массовый импорт | Импорт CSV / Excel для миграции | 1 |
| Round-trip 1С / Faktura.uz | `XML_ID` + `INN` для исходящего EDI | system |

## Папка

```
protected/modules/clients/
├── controllers/
│   ├── ClientController.php
│   ├── ApiController.php
│   ├── ApprovalController.php
│   ├── AgentRouteController.php
│   ├── ComputationController.php
│   └── …
└── views/
```

## Ключевые сущности

| Сущность | Модель | Замечания |
|--------|-------|-------|
| Клиент | `Client` | Активные точки/клиенты |
| Ожидающий клиент | `ClientPending` | Создан в поле, ожидает утверждения |
| Категория клиента | `ClientCategory` | Ценовой уровень / сегментация |
| Договор | `ContractClient` | Коммерческий договор |
| Маршрут | `Route`, `RouteClient` | Маршруты агентов |
| Снимок долга | `ClientDebt` | Расчётное старение |

## Воркфлоу утверждения

См. **Feature · Client Approval** в
[FigJam · sd-main · Feature Flows](https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU).

```mermaid
flowchart LR
  A["Agent creates client"] --> P["ClientPending"]
  P --> M["Manager review"]
  M -->|approve| C["Client ACTIVE=Y"]
  M -->|reject| R["Rejected, agent notified"]
  C --> X[("Optional 1C export")]
classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
classDef approval fill:#fef3c7,stroke:#92400e,color:#000
classDef success  fill:#dcfce7,stroke:#166534,color:#000
classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
classDef external fill:#f3f4f6,stroke:#374151,color:#000
classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
class A,P action
class M approval
class C success
class R reject
class X external
```

## API

| Эндпоинт | Назначение |
|----------|---------|
| `GET /api3/client/list` | Синхронизация клиентов маршрута на мобильный |
| `POST /api3/client/create` | Клиенты, созданные в поле (ожидающие) |
| `GET /api4/client/list` | Листинг для B2B-портала |

## Права доступа

| Действие | Роли |
|--------|-------|
| Создание | 1 / 2 / 4 (только pending) / 5 |
| Утверждение | 1 / 2 / 9 |
| Редактирование | 1 / 2 / 5 / 9 |
| Архивация | 1 / 2 |

## См. также

- [`agents`](./agents.md) (назначение маршрутов)
- [`gps`](./gps.md) (геофенсинг)
- [`orders`](./orders.md) (клиенты — это покупатели)

## Воркфлоу

### Точки входа

| Триггер | Контроллер / Действие / Задача | Замечания |
|---|---|---|
| Web | `ApprovalController::actionIndex` | Менеджер открывает список проверки ожидающих клиентов |
| Web | `ApprovalController::actionGetData` | Получает строки `client_pending` за диапазон дат |
| Web | `ApprovalController::actionSave` | Массово утверждает ожидающих клиентов, создаёт записи `Client` |
| Web | `ApprovalController::actionDelete` | Отклоняет (удаляет) ожидающих клиентов |
| Web | `ViewController::actionAgentVisitsByWeek` | UI для расписания привязки/отвязки агента |
| Web | `ViewController::actionAttachPriceType` | UI для назначения типа цены клиентам |
| Web | `ViewController::actionSalesCategories` | UI для назначения категории продаж |
| Web API | `ApiController::getAgentVisitsByDay` | Читает `Visiting` + `VisitingMonth` для выбранных клиентов |
| Web API | `ApiController::setAgentVisitsByDay` | Заменяет записи `Visiting` + `VisitingMonth` в транзакции |
| Web API | `ApiController::getPriceType` | Читает `Client.PRICE_TYPE_ID` для выбранных клиентов |
| Web API | `ApiController::setPriceType` | Записывает `Client.PRICE_TYPE_ID` для выбранных клиентов |
| Web API | `ApiController::getSalesCat` | Читает строки `SalesCategory` для выбранных клиентов |
| Web API | `ApiController::setSalesCat` | Заменяет строки `SalesCategory` для выбранных клиентов |
| Mobile (`api3`) | `api3/ClientController::actionAddClient` | Агент отправляет нового клиента; сохраняется как `ClientPending`, когда `verify=true` |
| Mobile (`api3`) | `api3/ClientController::actionPending` | Агент опрашивает свои собственные ожидающие отправки |

### Доменные сущности

```mermaid
erDiagram
    Client {
        string CLIENT_ID PK
        string NAME
        string FIRM_NAME
        string CLIENT_CAT FK
        string CITY FK
        string PRICE_TYPE_ID
        string SALES_CAT
        string ACTIVE
        string CONFIRMED_BY
        string CONFIRMED_AT
    }
    ClientPending {
        int ID PK
        string NAME
        string FIRM_NAME
        string CLIENT_CAT FK
        string WEEK_DAYS
        string WEEK_TYPE
        string CREATE_BY FK
        string CREATE_AT
        string XML_ID
    }
    Visiting {
        string CLIENT_ID FK
        string AGENT_ID FK
        int DAY
        string WEEK_TYPE
        int WEEK_POSITION
    }
    VisitingMonth {
        string CLIENT_ID FK
        string AGENT_ID FK
        int MONTH
        int DAY
    }
    SalesCategory {
        string CLIENT_ID FK
        string CAT_ID FK
    }
    ClientLog {
        string CLIENT_ID FK
        string FIELD
        string OLD_VALUE
        string NEW_VALUE
        string UPDATED_BY
    }
    Client ||--o{ Visiting : "visit schedule"
    Client ||--o{ VisitingMonth : "monthly schedule"
    Client ||--o{ SalesCategory : "sales categories"
    Client ||--o{ ClientLog : "audit log"
    ClientPending ||--o| Client : "promoted to"
```

### Воркфлоу 1.1 — Проверка клиента, созданного в поле

Агент создаёт нового клиента в мобильном приложении. Если в конфиге дистрибьютора `client.verify = true`, запись хранится в `ClientPending`, пока менеджер не утвердит или не отклонит её через web-бэкофис.

```mermaid
sequenceDiagram
    participant Mobile
    participant api3
    participant ApprovalController
    participant DB

    Mobile->>api3: POST /api3/client/addClient (JSON client payload, deviceToken header)
    api3->>DB: SELECT user by deviceToken (user table)
    DB-->>api3: User + Agent row
    api3->>DB: SELECT Client by client_id
    DB-->>api3: null (new client)
    alt agent config verify=true
        api3->>DB: SELECT ClientPending WHERE XML_ID = userId-clientId
        DB-->>api3: null (not duplicate)
        api3->>DB: INSERT client_pending (NAME, FIRM_NAME, ADRESS, LON, LAT, WEEK_DAYS, CREATE_BY, XML_ID)
        DB-->>api3: saved ID
        api3-->>Mobile: {status:1, pending:true, customer_id}
    else verify=false
        api3->>DB: INSERT client (ACTIVE=Y)
        DB-->>api3: CLIENT_ID
        api3-->>Mobile: {status:1, pending:false, customer_id}
    end

    Note over ApprovalController: Manager opens /clients/approval
    Web->>ApprovalController: GET actionGetData?from=&to=
    ApprovalController->>DB: SELECT client_pending JOIN user WHERE CREATE_AT BETWEEN :start AND :end
    DB-->>ApprovalController: pending rows
    ApprovalController-->>Web: JSON list

    Web->>ApprovalController: POST actionSave {clients:[id,...], status:"approved"}
    loop per pending ID
        ApprovalController->>DB: BEGIN TRANSACTION
        ApprovalController->>DB: SELECT ClientPending by PK
        ApprovalController->>DB: INSERT client (ACTIVE=Y, CONFIRMED_BY, CONFIRMED_AT, copies all fields)
        ApprovalController->>DB: INSERT visiting per WEEK_DAYS entry
        ApprovalController->>DB: INSERT client_log (field=visitDays)
        ApprovalController->>DB: INSERT sales_category rows
        ApprovalController->>DB: UPDATE client_photo SET CLIENT_ID=new id
        ApprovalController->>DB: DELETE client_pending
        ApprovalController->>DB: COMMIT
    end
    ApprovalController-->>Web: {success_ids:[...], failed:[...]}
```

### Воркфлоу 1.2 — Привязка / отвязка расписания визитов агента

Менеджер назначает или удаляет слоты визитов агент-клиент (еженедельно по дню недели или ежемесячно по дате). Операция — полная замена: существующие строки `Visiting` и `VisitingMonth` для клиента удаляются и затем вставляются заново внутри транзакции.

```mermaid
sequenceDiagram
    participant Web
    participant ApiController
    participant DB

    Web->>ApiController: GET /clients/api/getAgentVisitsByDay?ids=101-102
    ApiController->>DB: SELECT Visiting WHERE CLIENT_ID IN (101,102)
    ApiController->>DB: SELECT VisitingMonth WHERE CLIENT_ID IN (101,102)
    DB-->>ApiController: weekly + monthly rows
    ApiController-->>Web: {clients:{101:{weekdays:{...}, byDate:[...]}, ...}}

    Note over Web: User edits schedule in agentVisitsByWeek UI

    Web->>ApiController: POST /clients/api/setAgentVisitsByDay {clients:{101:{weekdays:{...}, byDate:[...]}}}
    loop per client ID
        ApiController->>DB: BEGIN TRANSACTION
        ApiController->>DB: DELETE visiting WHERE CLIENT_ID=101
        ApiController->>DB: DELETE visiting_month WHERE CLIENT_ID=101
        loop per weekday entry
            ApiController->>DB: INSERT visiting (CLIENT_ID, AGENT_ID, DAY, WEEK_TYPE, WEEK_POSITION)
        end
        loop per byDate entry
            ApiController->>DB: INSERT visiting_month (CLIENT_ID, AGENT_ID, MONTH, DAY)
        end
        ApiController->>DB: COMMIT
    end
    ApiController-->>Web: {success:[101,...], errors:[]}
```

### Воркфлоу 1.3 — Назначение типа цены и категории продаж

Менеджер массово назначает типы цен или категории продаж одному или нескольким клиентам. Обе операции следуют одному паттерну через действия `ApiController`: получить текущие значения, отредактировать в UI, затем сохранить одной транзакционной записью.

```mermaid
flowchart TD
    A[Web: ViewController::actionAttachPriceType] -- render view --> B[User selects clients + price types]
    B --> C["GET /clients/api/getPriceType?ids=..."]
    C -- "SELECT Client.PRICE_TYPE_ID" --> D[DB: client table]
    D --> E[Current values displayed]
    E --> F{User saves changes}
    F -- "POST /clients/api/setPriceType" --> G["ApiController: priceType/SetAction::run"]
    G --> H[BEGIN TRANSACTION]
    H -- "UPDATE client SET PRICE_TYPE_ID for each CLIENT_ID" --> D
    H --> I{all saves ok?}
    I -- yes --> J[COMMIT]
    I -- no --> K[ROLLBACK: HTTP 500]
    J --> L[Return success + error lists]

    A2[Web: ViewController::actionSalesCategories] -- render view --> B2[User selects clients + categories]
    B2 --> C2["GET /clients/api/getSalesCat?ids=..."]
    C2 -- "SELECT SalesCategory WHERE CLIENT_ID IN" --> D2[DB: sales_category table]
    D2 --> E2[Current values displayed]
    E2 --> F2{User saves changes}
    F2 -- "POST /clients/api/setSalesCat" --> G2["ApiController: salesCat/SetAction::run"]
    G2 --> H2[BEGIN TRANSACTION]
    H2 -- "DELETE sales_category WHERE CLIENT_ID IN" --> D2
    H2 -- "UPDATE Client.SALES_CAT + INSERT sales_category rows" --> D2
    H2 --> I2{all saves ok?}
    I2 -- yes --> J2[COMMIT]
    I2 -- no --> K2[ROLLBACK: HTTP 500]
    J2 --> L2[Return success + error lists]
```

### Межмодульные точки соприкосновения

- Чтения: `agents.Agent` (резолв AGENT_ID из User при утверждении; фильтрация расписания визитов по агенту)
- Чтения: `agents.Visiting` / `VisitingMonth` (отображение расписания в `AgentRouteController::actionGetClients`)
- Записи: `agents.Visiting` / `VisitingMonth` (заменяются при каждом вызове `setAgentVisitsByDay`)
- Записи: `clients.SalesCategory` (заменяются при каждом вызове `setSalesCat`; также пишутся при утверждении)
- Записи: `clients.ClientLog` (запись аудита для поля `visitDays` пишется при `ApprovalController::actionSave`)
- API: `api3/client/addClient` (мобильное создание клиента → `ClientPending`)
- API: `api3/client/pending` (мобильный агент опрашивает свои pending-отправки)
- API: `api4/client/sales-category-list` (B2B-портал читает категории продаж)

### Подводные камни

- `ApprovalController::actionSave` копирует значения полей из `ClientPending` в `Client` через жёстко заданный список атрибутов. Любая новая колонка `ClientPending`, добавленная в будущем, должна также быть добавлена в массив `$attributes` в этом методе, иначе она будет молча отброшена при утверждении.
- `agentVisitsByDay/SetAction` выполняет полное удаление с последующей вставкой. Вызов с пустым `weekdays` и пустым `byDate` для клиента удаляет все назначения визитов для этого клиента без подтверждающего prompt.
- `Client.PRICE_TYPE_ID` и `Client.SALES_CAT` хранятся как строки, разделённые запятыми, в строке `client` в дополнение к нормализованной таблице `sales_category`. Они могут разойтись, если `sales_category` пишется без обновления `Client.SALES_CAT`. `salesCat/SetAction` обновляет оба; прямые правки в БД могут не делать этого.
- Путь `api3/ClientController::actionAddClient` разделяется на две версии кода (`addClientVersion1` / `addClientVersion2`) на основе `$_REQUEST['u'] === 'merch'`. Только версия 1 пишет в `ClientPending`; вариант merch (`addClientVersion2`) имеет свой собственный поток.
- `ApprovalController::actionDelete` требует право `operation.clients.approval.delete`, которое отличается от права на утверждение (`operation.clients.approval`). Неправильно настроенные роли с правом утверждения, но без права удаления, не могут отклонять записи.
