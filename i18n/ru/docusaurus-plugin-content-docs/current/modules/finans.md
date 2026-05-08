---
sidebar_position: 9
title: finans
audience: Backend engineers, QA, PM, Finance ops
summary: Финансовый учётный слой в sd-main — P&L, P&L по агентам, сводный P&L, перемещения по кассам, учёт расходов / трат.
topics: [finance, pnl, cashbox, transfer, consumption, expense]
---

# Модуль `finans`

Финансовый учётный слой для sd-main. Агрегирует денежную сторону
бизнеса: P&L, P&L по агентам, движения по кассам, расходы.

## Ключевые возможности

| Возможность | Что делает | Роль(и) владельца |
|---------|--------------|---------------|
| P&L по периодам | Доходы / расходы / маржа за период | 1 / 9 / Finance |
| Сводный P&L | Срезы P&L | 1 / 9 / Finance |
| P&L по агентам | Прибыльность по каждому агенту | 1 / 8 / 9 |
| Перемещение между кассами | Перемещение денег между кассами (например, агент → главная) | 6 / Finance |
| Перенос платежа | Переназначение платежа в другую кассу / заказ | 1 / 6 |
| Учёт расходов / трат | Операционные расходы относительно бюджета | 1 / Finance |

## Папка

```
protected/modules/finans/
└── controllers/
    ├── PnlController.php
    ├── PivotPnlController.php
    ├── AgentPnlController.php
    ├── CashboxDisplacementController.php
    ├── PaymentTransferController.php
    └── ConsumptionController.php
```

## См. также

- [`pay`](./payment.md) — регистрация платежей
- [`payment`](./payment.md) — воркфлоу утверждения платежей

## Воркфлоу

### Точки входа

| Триггер | Контроллер / Действие / Задача | Замечания |
|---|---|---|
| Web — сетка P&L по агентам | `AgentPnlController::actionIndex` | Представление P&L по агенту, отдельно от PnL по филиалу |
| Web | `CashboxDisplacementController::actionIndex` | Рендерит представление списка перемещений между кассами |
| Web (GET) | `CashboxDisplacementController::actionGetDisplacement` | Возвращает отфильтрованные записи перемещений как JSON |
| Web (POST) | `CashboxDisplacementController::actionSave` | Создаёт новое перемещение между кассами + парные строки Consumption |
| Web (GET) | `CashboxDisplacementController::actionCancelDisplacement` | Устанавливает `STATUS=2`, удаляет парные строки Consumption |
| Web (POST) | `PaymentTransferController::actionCreate` | Создаёт документ межфилиального переноса платежа + дебетовый Consumption |
| Web (POST) | `PaymentTransferController::actionChangeStatus` | Продвигает статус PaymentTransfer; при ACCEPTED пишет ClientTransaction или Consumption |
| Web — сетка сводного P&L | `PivotPnlController::actionIndex` | Кросс-таб представление сводного P&L |
| Web (POST) | `ConsumptionController::actionIndex` (POST-ветка) | Добавление, редактирование или удаление строки расходов Consumption |
| Web (POST) | `ConsumptionController::actionCredit` (POST-ветка) | Добавление, редактирование или удаление строки кредита (дохода) Consumption |
| Web | `PnlController::actionIndex` | Строит временную таблицу `pnl` через `Finans::pnlTempTable`, агрегирует в представление P&L |

---

### Доменные сущности

```mermaid
erDiagram
    CashboxDisplacement {
        int ID PK
        int CB_FROM FK
        int CB_TO FK
        decimal SUMMA
        int TO_CURRENCY FK
        string CURRENCY FK
        decimal CO_SUMMA
        decimal RATE
        tinyint STATUS
        datetime DATE
    }
    PaymentTransfer {
        int PAYMENT_TRANSFER_ID PK
        int DOCUMENT_ID
        tinyint OPERATION_ID
        int FILIAL_ID FK
        int CURRENCY_ID FK
        decimal SUMMA
        tinyint STATUS
        string COMMENT
    }
    Consumption {
        int ID PK
        int CAT_PARENT FK
        int CAT_CHILD FK
        decimal SUMMA
        int CURRENCY FK
        int CASHBOX FK
        tinyint TYPE
        tinyint TRANS_TYPE
        int IDEN
        datetime DATE
        tinyint EXCLUDE_PNL
    }
    ConsumptionParent {
        int ID PK
        string NAME
        string XML_ID
        tinyint SYSTEM
    }
    ConsumptionChild {
        int ID PK
        int PARENT FK
        string NAME
        string XML_ID
        tinyint SYSTEM
    }
    Cashbox {
        int ID PK
        string NAME
        int KASSIR FK
        string ACTIVE
    }
    ClientTransaction {
        int CLIENT_TRANS_ID PK
        int CLIENT_ID FK
        int CASHBOX FK
        int CURRENCY FK
        decimal SUMMA
        tinyint TRANS_TYPE
        tinyint TYPE
        datetime DATE
    }

    CashboxDisplacement ||--|| Cashbox : "CB_FROM"
    CashboxDisplacement ||--|| Cashbox : "CB_TO"
    CashboxDisplacement ||--o{ Consumption : "IDEN / TRANS_TYPE=2"
    PaymentTransfer ||--o{ Consumption : "IDEN / TRANS_TYPE=4"
    Consumption }o--|| ConsumptionParent : "CAT_PARENT"
    Consumption }o--|| ConsumptionChild : "CAT_CHILD"
    Consumption }o--|| Cashbox : "CASHBOX"
    ConsumptionChild }o--|| ConsumptionParent : "PARENT"
```

---

### Воркфлоу 1.1 — Перемещение между кассами (внутренний перенос между кассами)

Кассир или финансовый менеджер перемещает средства из одной кассы в другую внутри одного филиала. Контроллер пишет запись `cashbox_displacement` и две парные строки `consumption` — дебет (TYPE=0) из исходной кассы и кредит (TYPE=1) в кассу-получатель — внутри одной DB-транзакции. Отмена удаляет обе строки consumption и помечает перемещение STATUS=2.

```mermaid
sequenceDiagram
    participant Web
    participant CashboxDisplacementController
    participant DB

    Web->>CashboxDisplacementController: POST /finans/cashboxDisplacement/save
    CashboxDisplacementController->>DB: SELECT Cashbox WHERE ID=transferFrom
    DB-->>CashboxDisplacementController: Cashbox record
    CashboxDisplacementController->>DB: SELECT Cashbox WHERE ID=transferTo
    DB-->>CashboxDisplacementController: Cashbox record
    CashboxDisplacementController->>DB: BEGIN TRANSACTION
    CashboxDisplacementController->>DB: INSERT cashbox_displacement
    DB-->>CashboxDisplacementController: new displacement ID
    CashboxDisplacementController->>DB: INSERT consumption TYPE=0 TRANS_TYPE=2 CASHBOX=CB_FROM
    CashboxDisplacementController->>DB: INSERT consumption TYPE=1 TRANS_TYPE=2 CASHBOX=CB_TO
    CashboxDisplacementController->>DB: COMMIT
    DB-->>CashboxDisplacementController: ok
    CashboxDisplacementController-->>Web: JSON success
```

---

### Воркфлоу 1.2 — Межфилиальный перенос платежа (жизненный цикл send → receive)

Филиал-отправитель инициирует перенос платежа в другой филиал. Документ путешествует по статусам (PENDING=2 → ACCEPTED=3 или REJECTED=4 / CANCELLED=5). При создании балансы кассы отправителя дебетуются через `consumption` (TRANS_TYPE=4, TYPE=0). При приёмке получателем средства зачисляются либо как `ClientTransaction` (TRANS_TYPE=3, когда `trans=1`), либо как `consumption` (TYPE=1, TRANS_TYPE=4). Отказ или отмена удаляет дебетовые строки consumption.

```mermaid
flowchart TD
    A[Web: POST /finans/paymentTransfer/create] --> B[PaymentTransferController::actionCreate]
    B --> C{Currency + Filial active?}
    C -- No --> ERR1[fail: reload_page]
    C -- Yes --> D{Cashbox balance sufficient?}
    D -- No --> ERR2[fail: insufficient funds]
    D -- Yes --> E[INSERT payment_transfer STATUS=2 OPERATION_ID=1 sender filial]
    E --> F[INSERT consumption TYPE=0 TRANS_TYPE=4 per payment item]
    F --> G[switchFilialAndSaveTransfer: INSERT payment_transfer STATUS=1 OPERATION_ID=2 receiver filial]
    G --> H[COMMIT - DOCUMENT_ID returned]

    H --> I[Web: POST /finans/paymentTransfer/changeStatus]
    I --> J{status requested?}
    J -- CANCELLED=5 or REJECTED=4 --> K[DELETE consumption WHERE IDEN=DOCUMENT_ID AND TRANS_TYPE=4]
    K --> L[UPDATE payment_transfer STATUS=4 or 5]
    J -- ACCEPTED=3 --> M{trans=1?}
    M -- Yes --> N[INSERT client_transaction TRANS_TYPE=3 then ClientFinans::correct]
    M -- No --> O[INSERT consumption TYPE=1 TRANS_TYPE=4]
    N --> P[UPDATE payment_transfer STATUS=3]
    O --> P
    L --> Q[COMMIT]
    P --> Q
```

---

### Воркфлоу 1.3 — Запись расхода / дохода и включение в P&L

Финансовый персонал записывает операционные расходы (TYPE=0) или доходы кассы (TYPE=1) напрямую через `ConsumptionController`. Каждая строка тегируется фондом (`ConsumptionParent`) и категорией (`ConsumptionChild`). `PnlController::actionIndex` читает `consumption` WHERE `TRANS_TYPE=1 AND EXCLUDE_PNL=0`, чтобы добавить операционные расходы и прочие доходы в итоги P&L после того, как `Finans::pnlTempTable` заполнит временную таблицу `pnl` из данных продаж.

```mermaid
sequenceDiagram
    participant Web
    participant ConsumptionController
    participant PnlController
    participant DB

    Web->>ConsumptionController: POST /finans/consumption/index (name=consum_add)
    ConsumptionController->>DB: CHECK Closed::check_update finans date
    DB-->>ConsumptionController: period open
    ConsumptionController->>DB: INSERT consumption TYPE=0 TRANS_TYPE=1 EXCLUDE_PNL=0
    DB-->>ConsumptionController: saved ID
    ConsumptionController->>DB: TelegramReport::newConsumption async notify
    ConsumptionController-->>Web: redirect GET

    Web->>PnlController: GET /finans/pnl/index with date range
    PnlController->>DB: Finans::pnlTempTable creates pnl temp table
    DB-->>PnlController: pnl temp table ready
    PnlController->>DB: SELECT SUM SUMMA FROM consumption TRANS_TYPE=1 TYPE=0 EXCLUDE_PNL=0
    DB-->>PnlController: rasxod total
    PnlController->>DB: SELECT SUM SUMMA FROM consumption TRANS_TYPE=1 TYPE=1 EXCLUDE_PNL=0
    DB-->>PnlController: prixod total
    PnlController->>DB: SELECT SUM SUMMA FROM client_transaction TRANS_TYPE=8 TYPE=1
    DB-->>PnlController: bad_debt total
    PnlController-->>Web: render pnl/index with aggregated P&L result
```

---

### Межмодульные точки соприкосновения

- Чтения: `pay.ClientTransaction` (TRANS_TYPE IN(3,4,5) — используется для расчёта баланса кассы в `CashboxDisplacementController::getCashboxBalance` и `PaymentTransferController::getCashboxBalance`)
- Записи: `pay.ClientTransaction` (INSERT TRANS_TYPE=3, TYPE=1, когда платёжный перенос принят с флагом `trans=1` — через `PaymentTransferController::savePaymentAsTransaction`)
- Записи: `pay.ClientFinans` (`ClientFinans::correct` вызывается после записи ClientTransaction при приёмке переноса)
- Чтения: `settings.Closed` (проверка блокировки периода через `Closed::model()->check_update('finans', date)` перед любой записью расхода в `ConsumptionController`)
- Чтения: `warehouse.LotDistribution` / `orders.Order` (используется `Finans::pnlTempTable`, когда `ServerSettings::enableLotManagement()` равно true)

---

### Подводные камни

- `CashboxDisplacement` и `PaymentTransfer` оба наследуют `BaseFilial`, поэтому их имена таблиц получают филиальный префикс во время выполнения. Кросс-филиальные запросы в `PaymentTransferController::actionChangeStatus` переключают активный контекст филиала через `BaseFilial::setFilial($prefix)` перед запросом таблицы получателя `payment_transfer` — отказ от обратного переключения может испортить контекст филиала в сессии.
- `Consumption.TRANS_TYPE` критичен для P&L: только строки с `TRANS_TYPE=1` идут в `PnlController`. Строки, написанные перемещением (`TRANS_TYPE=2`) и переносом платежа (`TRANS_TYPE=4`), молча исключаются из агрегации P&L.
- `Consumption.EXCLUDE_PNL=1` — это ручное переопределение, которое удаляет строку из P&L, даже если `TRANS_TYPE=1`. Может быть установлено в путях добавления и редактирования в `ConsumptionController`.
- `PaymentTransferController::actionChangeStatus` пишет в контексты БД и отправителя, и получателя в одном HTTP-запросе. DB-транзакция (`$safeTrans`) покрывает только текущее соединение филиала; вставка в удалённый филиал в `switchFilialAndSaveTransfer` находится вне транзакции и не откатывается при ошибке.
- `ConsumptionController::actionCredit` (доход кассы, TYPE=1) **не** вызывает `TelegramReport::newConsumption`; только записи расходов (TYPE=0 в `actionIndex`) триггерят Telegram-уведомление.
- Расчёт P&L имеет два пути кода, защищённых `ServerSettings::enableLotManagement()`. При включении `Finans::pnlTempTable` использует SQL на основе `LotDistribution`; при отключении откатывается к легаси `Finans::pnlSql`. Оба заполняют одну и ту же временную таблицу `pnl`, но дают **разные числа P&L** на тех же данных. Проверьте, в каком режиме работает целевой инстанс, прежде чем доверять историческим сравнениям.
- `PaymentTransferController::actionChangeStatus` запускает `allowedStatus` дважды — один раз в контексте филиала отправителя (строки ~229–231), один раз в получателе после `BaseFilial::setFilial` (строки ~293–297). Обновление STATUS и удаления Consumption между ними (строки ~237–247) выполняются **до** второй проверки, поэтому может произойти частичная мутация, если проверка на стороне получателя не пройдёт. Воспринимайте две половины как неатомарные.
