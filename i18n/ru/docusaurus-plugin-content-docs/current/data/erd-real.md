---
sidebar_position: 3
title: Реальный ER (из объявленных связей)
audience: Backend engineers, QA, PM, Data engineers
summary: Авторитетная ER-диаграмма для sd-main, сгенерированная из 93 объявленных relations() в 40 активных Yii-моделях. Сравните с концептуальным ER, чтобы найти неявные связи, которые код должен объявить.
topics: [erd, schema, relations, mermaid, sd-main, real-data]
---

# Реальный ER (из объявленных связей)

Эта страница — **истина из кода** ER. Каждое ребро ниже — реальное
объявление `relations()` в Yii-модели — 93 ребра между 70 сущностями.

Сравните с [Концептуальным ER](./erd.md) (он показывает задуманную модель
домена), чтобы найти разрыв — места, где колонки явно ссылаются друг на
друга, но `relations()` не объявлен.

## Топ связанных сущностей

| Сущность | Рёбер | Домен |
|----------|-------|-------|
| `Product` | 19 | Каталог |
| `User` | 13 | Auth |
| `Client` | 9 | Клиенты |
| `ProductCompetitor` | 8 | Каталог |
| `AdtAuditResult` | 6 | Audit ADT |
| `Visit` | 6 | Visit |
| `Diler` | 6 | Diler |
| `FilialMovementRequest` | 6 | Filial |
| `StructureFilial` | 5 | Other |
| `AdtPoll` | 5 | Audit ADT |
| `AdtPollQuestion` | 5 | Audit ADT |
| `AdtAuditResultData` | 4 | Audit ADT |
| `Order` | 4 | Orders |
| `FilialMovementRequestDetail` | 4 | Filial |
| `Tasks` | 4 | Other |
| `AdtAudit` | 3 | Audit ADT |
| `AdtPollResultData` | 3 | Audit ADT |
| `ProductCategory` | 3 | Catalog |
| `OnlineOrder` | 3 | Other |
| `TaskLog` | 3 | Other |

## Mermaid (полный граф)

:::tip Как читать эту диаграмму
- **90 сущностей, 92 явных ребра `relations()`** отрендерены вместе, чтобы вы могли увидеть всю форму слоя данных в одном виде. Она плотная по дизайну — для focused-изучения используйте per-domain разбивку в [Рёбра по доменам](#edges-by-domain) ниже.
- **Подписи рёбер = колонка внешнего ключа** (например, `AUDIT_ID`, `CLIENT_ID`). Глиф кардинальности несёт направление и опциональность:
  - `||--o{`  один-ко-многим (родитель имеет много)
  - `}o--||`  многие-к-одному (дочерний принадлежит к)
  - `||--o|`  один-к-нулю-или-одному
- Source-of-truth-порядок: рёбра ниже сгруппированы по **домену** (audit, catalog, clients, sales, dealers, structure, inventory, visits, tasks, other). Mermaid автоматически раскладывает отрендеренный граф — source-группировка нужна для мейнтейнеров, не для отрендеренного вывода.
:::

```mermaid
erDiagram
  %% ── Audit & polls ───────────────────────────────────────────
  ADTAUDIT ||--o{ ADTAUDITPRODUCTS : AUDIT_ID
  ADTAUDIT ||--o{ ADTAUDITUSERS : AUDIT_ID
  ADTAUDITPRODUCTS }o--|| PRODUCT : PRODUCT_ID
  ADTAUDITRESULT }o--|| ADTAUDIT : AUDIT_ID
  ADTAUDITRESULT ||--o{ ADTAUDITRESULTDATA : RESULT_ID
  ADTAUDITRESULT }o--|| CLIENT : CLIENT_ID
  ADTAUDITRESULT }o--|| STRUCTUREFILIAL : POSITION_ID
  ADTAUDITRESULT }o--|| VISIT : VISIT_ID
  ADTAUDITRESULTDATA }o--|| ADTAUDITRESULT : RESULT_ID
  ADTAUDITRESULTDATA }o--|| PRODUCT : PRODUCT_ID
  ADTAUDITRESULTDATA }o--|| PRODUCTCOMPETITOR : PRODUCT_ID
  ADTCOMMENTRESULT }o--|| ADTCOMMENT : COMMENT_ID
  ADTCONFIG }o--|| STRUCTUREFILIAL : USER
  ADTPOLL ||--o{ ADTPOLLQUESTION : POLL_ID
  ADTPOLL ||--o{ ADTPOLLBIND : POLL_ID
  ADTPOLL }o--|| USER : CREATE_BY
  ADTPOLLQUESTION }o--|| ADTPOLL : POLL_ID
  ADTPOLLQUESTION ||--o{ ADTPOLLVARIANT : QUES_ID
  ADTPOLLQUESTION ||--o{ ADTPOLLRESULTDATA : QUESTION_ID
  ADTPOLLRESULT }o--|| ADTPOLL : POLL_ID
  ADTPOLLRESULT ||--o{ ADTPOLLRESULTDATA : RESULT_ID
  ADTPOLLRESULTDATA }o--|| ADTPOLLQUESTION : QUESTION_ID

  %% ── Catalog (products + attributes) ─────────────────────────
  PRODUCT }o--|| PRODUCTGROUP : PRODUCT_GROUP_
  PRODUCT }o--|| ADTPACK : PACK
  PRODUCT }o--|| ADTSEGMENT : SEGMENT
  PRODUCT }o--|| ADTBRANDS : BRAND
  PRODUCT }o--|| ADTPRODUCER : PRODUCER
  PRODUCT }o--|| ADTPROPERTY : PROPERTY
  PRODUCT }o--|| USER : CREATE_BY
  PRODUCT }o--|| USER : UPDATE_BY
  PRODUCTCATEGORY }o--|| PRODUCT : PRODUCT_CAT_ID
  PRODUCTCATEGORY }o--|| UNIT : UNIT
  PRODUCTSUBCATEGORY }o--|| PRODUCT : SUB_CAT_ID
  PRODUCTUNIT }o--|| PRODUCT : PRODUCT_ID
  PRODUCTPRICEMARKUP }o--|| PRODUCT : PRODUCT
  PRODUCTCOMPETITOR }o--|| PRODUCTGROUP : PRODUCT_GROUP_
  PRODUCTCOMPETITOR }o--|| ADTPACK : PACK
  PRODUCTCOMPETITOR }o--|| ADTSEGMENT : SEGMENT
  PRODUCTCOMPETITOR }o--|| ADTBRANDS : BRAND
  PRODUCTCOMPETITOR }o--|| ADTPRODUCER : PRODUCER
  PRODUCTCOMPETITOR }o--|| USER : CREATE_BY
  PRODUCTCOMPETITOR }o--|| USER : UPDATE_BY

  %% ── Clients ─────────────────────────────────────────────────
  CLIENT }o--|| CLIENTTYPE : TYPE
  CLIENT }o--|| CLIENTCHANNEL : CHANNEL
  CLIENTPENDING }o--|| REGION : REGION
  CLIENTPENDING }o--|| CITY : CITY
  CONTRAGENT }o--|| CLIENTTYPE : TYPE
  CONTRAGENT }o--|| CLIENTCHANNEL : CHANNEL

  %% ── Sales / orders ──────────────────────────────────────────
  ONLINEORDER }o--|| CONTACT : CONTACT_ID
  ONLINEORDER }o--|| ORDER : ORDER_ID
  ONLINEORDER ||--o{ ONLINEORDERDETAIL : ONLINE_ORDER_I
  ONLINEORDERDETAIL }o--|| PRODUCT : PRODUCT
  ORDERDEFECTDETAIL }o--|| PRODUCT : PRODUCT
  ORDERREPLACEDETAIL }o--|| PRODUCT : PRODUCT
  BONUSORDERDETAIL }o--|| PRODUCT : PRODUCT
  CLIENTKASPITRANSACTION }o--|| ORDER : ORDER_ID
  CLIENTODENGITRANSACTION }o--|| ORDER : ORDER_ID
  CLIENTOPTIMATRANSACTION }o--|| ORDER : ORDER_ID

  %% ── Dealers, users, plans ───────────────────────────────────
  DILER }o--|| USER : DILER_ID
  DILER ||--o{ PLAN : DILER_ID
  DILER ||--o{ CLIENT : DILER_ID
  DILER ||--o{ AGENT : DILER_ID
  DILER ||--o{ PRICETYPE : DILER
  USER }o--|| DILER : DILER_ID
  USER }o--|| AGENT : AGENT_ID

  %% ── Filial / structure / movement ───────────────────────────
  STRUCTUREFILIAL }o--|| USER : USER_ID
  FILIALMOVEMENTREQUEST ||--o{ FILIALMOVEMENTREQUESTDETAIL : REQUEST_ID
  FILIALMOVEMENTREQUEST }o--|| FILIAL : REQUESTER_FILI
  FILIALMOVEMENTREQUEST }o--|| FILIAL : PROVIDER_FILIA
  FILIALMOVEMENTREQUEST }o--|| STORE : STORE_ID
  FILIALMOVEMENTREQUEST }o--|| TRADEDIRECTION : TRADE_ID
  FILIALMOVEMENTREQUESTDETAIL }o--|| FILIALMOVEMENTREQUEST : REQUEST_ID
  FILIALMOVEMENTREQUESTDETAIL }o--|| PRODUCT : PRODUCT_ID
  FILIALMOVEMENTREQUESTDETAIL }o--|| PRODUCTCATEGORY : PRODUCT_CAT_ID

  %% ── Inventory ───────────────────────────────────────────────
  INVENTORYHISTORY }o--|| INVENTORY : INVENTORY_ID
  INVENTORYHISTORY }o--|| INVENTORYTYPE : INV_TYPE_ID
  MUSTBUYRULE ||--o{ MUSTBUYRULEITEM : RULE_ID

  %% ── Visits & field ──────────────────────────────────────────
  VISIT }o--|| CLIENT : CLIENT_ID
  VISIT }o--|| USER : USER_ID
  VISIT }o--|| STRUCTUREFILIAL : POSITION_ID
  VISIT ||--o| ADTNOTERESULT : VISIT_ID
  VISIT ||--o| ADTCOMMENTRESULT : VISIT_ID
  VISITINGAUD }o--|| STRUCTUREFILIAL : AUDITOR_ID
  VISITINGAUD }o--|| CLIENT : CLIENT_ID

  %% ── Tasks ───────────────────────────────────────────────────
  TASKS }o--|| USER : TASK_FROM
  TASKS }o--|| USER : TASK_TO
  TASKS }o--|| CLIENT : CLIENT_ID
  TASKS }o--|| TASKTYPE : TYPE_ID
  TASKLOG }o--|| USER : USER_ID
  TASKLOG }o--|| CLIENT : OLD_VALUE
  TASKLOG }o--|| CLIENT : NEW_VALUE

  %% ── Other ───────────────────────────────────────────────────
  CONSUMPTIONHISTORY }o--|| CONSUMPTION : CONSUMPTION_ID
  TGBOT }o--|| TELEGRAMGROUP : GROUP_ID
```

> **Совет:** если отрендеренный граф сложно прочитать с первого взгляда — это слой данных вам что-то говорит. Используйте таблицу [Топ связанных сущностей](#top-connected-entities) выше, чтобы найти хабы (PRODUCT, USER, CLIENT, DILER, FILIAL) и трассировать наружу от них.

## Рёбра по доменам

| Источник | Тип | Цель | Внешний ключ |
|----------|-----|------|--------------|
| `AdtAudit` | `HAS_MANY` | `AdtAuditProducts` | `AUDIT_ID` |
| `AdtAudit` | `HAS_MANY` | `AdtAuditUsers` | `AUDIT_ID` |
| `AdtAuditProducts` | `BELONGS_TO` | `Product` | `PRODUCT_ID` |
| `AdtAuditResult` | `BELONGS_TO` | `AdtAudit` | `AUDIT_ID` |
| `AdtAuditResult` | `HAS_MANY` | `AdtAuditResultData` | `RESULT_ID` |
| `AdtAuditResult` | `BELONGS_TO` | `Client` | `CLIENT_ID` |
| `AdtAuditResult` | `BELONGS_TO` | `StructureFilial` | `POSITION_ID` |
| `AdtAuditResult` | `BELONGS_TO` | `Visit` | `VISIT_ID` |
| `AdtAuditResultData` | `BELONGS_TO` | `AdtAuditResult` | `RESULT_ID` |
| `AdtAuditResultData` | `BELONGS_TO` | `Product` | `PRODUCT_ID` |
| `AdtAuditResultData` | `BELONGS_TO` | `ProductCompetitor` | `PRODUCT_ID` |
| `AdtCommentResult` | `BELONGS_TO` | `AdtComment` | `COMMENT_ID` |
| `AdtConfig` | `BELONGS_TO` | `StructureFilial` | `USER` |
| `AdtPoll` | `HAS_MANY` | `AdtPollBind` | `POLL_ID` |
| `AdtPoll` | `HAS_MANY` | `AdtPollQuestion` | `POLL_ID` |
| `AdtPoll` | `BELONGS_TO` | `User` | `CREATE_BY` |
| `AdtPollQuestion` | `BELONGS_TO` | `AdtPoll` | `POLL_ID` |
| `AdtPollQuestion` | `HAS_MANY` | `AdtPollResultData` | `QUESTION_ID` |
| `AdtPollQuestion` | `HAS_MANY` | `AdtPollVariant` | `QUES_ID` |
| `AdtPollResult` | `BELONGS_TO` | `AdtPoll` | `POLL_ID` |
| `AdtPollResult` | `HAS_MANY` | `AdtPollResultData` | `RESULT_ID` |
| `AdtPollResultData` | `BELONGS_TO` | `AdtPollQuestion` | `QUESTION_ID` |
| `User` | `BELONGS_TO` | `Agent` | `AGENT_ID` |
| `User` | `BELONGS_TO` | `Diler` | `DILER_ID` |
| `BonusOrderDetail` | `BELONGS_TO` | `Product` | `PRODUCT` |
| `Product` | `BELONGS_TO` | `AdtBrands` | `BRAND` |
| `Product` | `BELONGS_TO` | `AdtPack` | `PACK` |
| `Product` | `BELONGS_TO` | `AdtProducer` | `PRODUCER` |
| `Product` | `BELONGS_TO` | `AdtProperty` | `PROPERTY` |
| `Product` | `BELONGS_TO` | `AdtSegment` | `SEGMENT` |
| `Product` | `BELONGS_TO` | `ProductGroup` | `PRODUCT_GROUP_ID` |
| `Product` | `BELONGS_TO` | `User` | `CREATE_BY` |
| `Product` | `BELONGS_TO` | `User` | `UPDATE_BY` |
| `ProductCategory` | `BELONGS_TO` | `Product` | `PRODUCT_CAT_ID` |
| `ProductCategory` | `BELONGS_TO` | `Unit` | `UNIT` |
| `ProductCompetitor` | `BELONGS_TO` | `AdtBrands` | `BRAND` |
| `ProductCompetitor` | `BELONGS_TO` | `AdtPack` | `PACK` |
| `ProductCompetitor` | `BELONGS_TO` | `AdtProducer` | `PRODUCER` |
| `ProductCompetitor` | `BELONGS_TO` | `AdtSegment` | `SEGMENT` |
| `ProductCompetitor` | `BELONGS_TO` | `ProductGroup` | `PRODUCT_GROUP_ID` |
| `ProductCompetitor` | `BELONGS_TO` | `User` | `CREATE_BY` |
| `ProductCompetitor` | `BELONGS_TO` | `User` | `UPDATE_BY` |
| `ProductPriceMarkup` | `BELONGS_TO` | `Product` | `PRODUCT` |
| `ProductSubCategory` | `BELONGS_TO` | `Product` | `SUB_CAT_ID` |
| `ProductUnit` | `BELONGS_TO` | `Product` | `PRODUCT_ID` |
| `Client` | `BELONGS_TO` | `ClientChannel` | `CHANNEL` |
| `Client` | `BELONGS_TO` | `ClientType` | `TYPE` |
| `ClientKaspiTransaction` | `BELONGS_TO` | `Order` | `ORDER_ID` |
| `ClientOdengiTransaction` | `BELONGS_TO` | `Order` | `ORDER_ID` |
| `ClientOptimaTransaction` | `BELONGS_TO` | `Order` | `ORDER_ID` |
| `ClientPending` | `BELONGS_TO` | `City` | `CITY` |
| `ClientPending` | `BELONGS_TO` | `Region` | `REGION` |
| `Diler` | `HAS_MANY` | `Agent` | `DILER_ID` |
| `Diler` | `HAS_MANY` | `Client` | `DILER_ID` |
| `Diler` | `HAS_MANY` | `Plan` | `DILER_ID` |
| `Diler` | `HAS_MANY` | `PriceType` | `DILER` |
| `Diler` | `BELONGS_TO` | `User` | `DILER_ID` |
| `FilialMovementRequest` | `BELONGS_TO` | `Filial` | `REQUESTER_FILIAL_ID` |
| `FilialMovementRequest` | `BELONGS_TO` | `Filial` | `PROVIDER_FILIAL_ID` |
| `FilialMovementRequest` | `HAS_MANY` | `FilialMovementRequestDetail` | `REQUEST_ID` |
| `FilialMovementRequest` | `BELONGS_TO` | `Store` | `STORE_ID` |
| `FilialMovementRequest` | `BELONGS_TO` | `TradeDirection` | `TRADE_ID` |
| `FilialMovementRequestDetail` | `BELONGS_TO` | `FilialMovementRequest` | `REQUEST_ID` |
| `FilialMovementRequestDetail` | `BELONGS_TO` | `Product` | `PRODUCT_ID` |
| `FilialMovementRequestDetail` | `BELONGS_TO` | `ProductCategory` | `PRODUCT_CAT_ID` |
| `InventoryHistory` | `BELONGS_TO` | `Inventory` | `INVENTORY_ID` |
| `InventoryHistory` | `BELONGS_TO` | `InventoryType` | `INV_TYPE_ID` |
| `OrderDefectDetail` | `BELONGS_TO` | `Product` | `PRODUCT` |
| `OrderReplaceDetail` | `BELONGS_TO` | `Product` | `PRODUCT` |
| `ConsumptionHistory` | `BELONGS_TO` | `Consumption` | `CONSUMPTION_ID` |
| `Contragent` | `BELONGS_TO` | `ClientChannel` | `CHANNEL` |
| `Contragent` | `BELONGS_TO` | `ClientType` | `TYPE` |
| `MustBuyRule` | `HAS_MANY` | `MustBuyRuleItem` | `RULE_ID` |
| `OnlineOrder` | `BELONGS_TO` | `Contact` | `CONTACT_ID` |
| `OnlineOrder` | `HAS_MANY` | `OnlineOrderDetail` | `ONLINE_ORDER_ID` |
| `OnlineOrder` | `BELONGS_TO` | `Order` | `ORDER_ID` |
| `OnlineOrderDetail` | `BELONGS_TO` | `Product` | `PRODUCT` |
| `StructureFilial` | `BELONGS_TO` | `User` | `USER_ID` |
| `TaskLog` | `BELONGS_TO` | `Client` | `OLD_VALUE` |
| `TaskLog` | `BELONGS_TO` | `Client` | `NEW_VALUE` |
| `TaskLog` | `BELONGS_TO` | `User` | `USER_ID` |
| `Tasks` | `BELONGS_TO` | `Client` | `CLIENT_ID` |
| `Tasks` | `BELONGS_TO` | `TaskType` | `TYPE_ID` |
| `Tasks` | `BELONGS_TO` | `User` | `TASK_FROM` |
| `Tasks` | `BELONGS_TO` | `User` | `TASK_TO` |
| `TgBot` | `BELONGS_TO` | `TelegramGroup` | `GROUP_ID` |
| `VisitingAud` | `BELONGS_TO` | `Client` | `CLIENT_ID` |
| `VisitingAud` | `BELONGS_TO` | `StructureFilial` | `AUDITOR_ID` |
| `Visit` | `HAS_ONE` | `AdtCommentResult` | `VISIT_ID` |
| `Visit` | `HAS_ONE` | `AdtNoteResult` | `VISIT_ID` |
| `Visit` | `BELONGS_TO` | `Client` | `CLIENT_ID` |
| `Visit` | `BELONGS_TO` | `StructureFilial` | `POSITION_ID` |
| `Visit` | `BELONGS_TO` | `User` | `USER_ID` |

## Что эта ER НЕ показывает

- **Неявные связи**: колонка с именем `CLIENT_ID` на `Order` явно ссылается на `Client`, даже если `Order::relations()` её не объявляет. Концептуальный ER их показывает.
- **Полиморфные связи**: любая колонка, несущая несколько видов FK (например, `RELATED_TO_ID` + `RELATED_TO_TYPE`), не вписывается в синтаксис Mermaid.
- **Cross-DB-связи**: sd-cs читает из БД sd-main, но связь — в PHP-коде, не в Yii-объявлении `relations()`.

## Процедура обновления

Перезапустите [процедуру обновления](./schema-reference.md#refresh-procedure) на странице schema-reference; этот ER регенерируется из того же JSON.
