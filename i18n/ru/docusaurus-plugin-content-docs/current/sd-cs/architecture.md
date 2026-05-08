---
sidebar_position: 4
title: Архитектура (verified)
---

# sd-cs — Архитектура (verified by running code)

Эти диаграммы отражают **фактическое** поведение развёрнутого sd-cs:
две MySQL-схемы (control + warehouse) и схему per-tenant **филиал**
префикса внутри warehouse-БД. Проверено по
схемам `cs3_demo` / `b_demo` и кодовым путям `BaseModel` /
`V2Controller`.

> Визуальная таксономия следует стандарту
> [Diagram gallery](/docs/diagrams)
> (blue = action, amber = approval, green = success, red = reject,
> grey = external, purple = cron).

## Карта подключения двух БД

`Yii::app()->db` подключается к `cs3_demo` (control plane, 23 таблицы,
префикс `cs_`). `Yii::app()->dealer` подключается к `b_demo` (operational
warehouse, ~1 684 таблицы, префикс `d0_`). Обе сконфигурированы в
`protected/config/db.php`.

```mermaid
flowchart LR
  U[HQ user] --> APP[sd-cs · Yii 1.1]
  APP -->|Yii::app->db| CS[(cs3_demo<br/>prefix cs_<br/>~23 tables)]
  APP -->|Yii::app->dealer| BD[(b_demo<br/>prefix d0_<br/>~1684 tables)]
  APP --> RD[(Redis<br/>sessions + cache)]

  subgraph CS_role [Control plane]
    CS
  end
  subgraph BD_role [Operational warehouse · multi-tenant]
    BD
  end

  class U,APP,RD action
  class CS,BD action
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
```

`cs3_demo` хранит auth, RBAC, geography, plans, telegram-боты, pivot-
конфиги. `b_demo` хранит все операционные данные дилеров, секционированные
по филиалам.

## Кросс-БД сцепление (filial bridge)

**Внешних ключей между двумя схемами нет** — две БД
соединены логически по `filial_id`. Канонический реестр филиалов живёт
в `b_demo.d0_filial`; `cs3_demo` обогащает каждый филиал country /
territory метаданными и per-user ACL`ами.

```mermaid
erDiagram
  CS_COUNTRY ||--o{ CS_REGION : has
  CS_REGION  ||--o{ CS_TERRITORY : has
  CS_TERRITORY ||--o{ CS_FILIAL_DETAIL : describes
  CS_FILIAL_DETAIL }o--|| D0_FILIAL : "filial_id (cross-DB)"
  CS_USER ||--o{ CS_USER_FILIAL : owns
  CS_USER_FILIAL }o--|| D0_FILIAL : "filial_id (cross-DB)"
  CS_FILIAL_GROUP }o--|| D0_FILIAL : "filial_id (cross-DB)"
  CS_USER ||--o{ CS_ACCESS_USER : has
  CS_ACCESS_ROLE ||--o{ CS_ACCESS_USER : grants

  CS_COUNTRY {
    int id PK
    string name
  }
  CS_REGION {
    int id PK
    int country_id FK
  }
  CS_TERRITORY {
    int id PK
    int region_id FK
  }
  CS_FILIAL_DETAIL {
    int id PK
    int filial_id "→ b_demo.d0_filial.id"
    int territory_id FK
    string alt
  }
  CS_USER {
    int id PK
    string login
    string hash
    int role
  }
  CS_USER_FILIAL {
    int user_id FK
    int filial_id "→ b_demo.d0_filial.id"
  }
  CS_FILIAL_GROUP {
    int filial_id "→ b_demo.d0_filial.id"
    int group_id
  }
  CS_ACCESS_ROLE {
    int id PK
    string name
  }
  CS_ACCESS_USER {
    int user_id FK
    int role_id FK
  }
  D0_FILIAL {
    int id PK
    string prefix "f1..fN"
    string domain
    tinyint is_main
    string active "Y/N"
    int sort
  }
```

## Multi-tenant раскладка внутри `b_demo`

`b_demo` смешивает два рода таблиц: dealer-global (без filial-префикса)
и per-filial (`d0_fN_*`). Размер demo: 7 активных филиалов (`f1..f7`),
~227 таблиц на филиал, плюс ~50 dealer-global таблиц.

```mermaid
flowchart TB
  BD[(b_demo)]
  BD --> REG[d0_filial<br/>tenant registry]
  BD --> GLB[Dealer-global tables<br/>d0_product, d0_price,<br/>d0_skidka_*, d0_royalty_*,<br/>d0_knowledge_*, …]
  BD --> F1[d0_f1_* · ~227 tables]
  BD --> F2[d0_f2_* · ~227 tables]
  BD --> F3[d0_f3_* · ~227 tables]
  BD --> FN[d0_fN_* · ~227 tables]

  REG -. defines prefixes .-> F1
  REG -. defines prefixes .-> F2
  REG -. defines prefixes .-> F3
  REG -. defines prefixes .-> FN

  class BD,REG,GLB action
  class F1,F2,F3,FN action
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
```

Per-filial сущности включают `client`, `agent`, `order`, `visit`,
`audit`, `cashbox`, `bonus_*`, `cars`, `catalog_*` и т. д. — каждый филиал
получает свою копию, scoped префиксом `fN_`.

## Перезапись таблицы `setFilial()`

Механизм, позволяющий одному классу модели обращаться к множеству тенантов, живёт
в `protected/components/BaseModel.php` (`tableName()`,
`getFilialTable()`, `setFilial()`). Вызов `setFilial('f3')` переписывает
table-токен с `{{client}}` на `{{f3_client}}`, который Yii
разворачивает, используя `tablePrefix='d0_'` соединения `dealer`,
давая `d0_f3_client`.

```mermaid
flowchart LR
  C[Controller] -->|Model::model->setFilial 'f3'| M[BaseModel instance]
  M --> R[refreshMetaData<br/>reload schema]
  M --> T[tableName returns<br/>'f3_client' instead of 'client']
  T --> Q[Yii::app->dealer<br/>SELECT FROM d0_f3_client]
  Q --> DB[(b_demo.d0_f3_client)]

  class C,M,R,T,Q action
  class DB action
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
```

## Логин → filial scoping → запрос

Сквозной поток запроса: авторизация в `cs3_demo`; data fetch
в `b_demo`, scoped к разрешённым пользователю филиалам через
`cs_user_filial` и (опционально) `country_id`.

```mermaid
sequenceDiagram
  autonumber
  participant U as User (browser)
  participant W as sd-cs web
  participant CS as cs3_demo (db)
  participant BD as b_demo (dealer)

  U->>W: POST /user/login
  W->>CS: SELECT cs_user WHERE login=?
  CS-->>W: row + bcrypt hash
  W->>W: CPasswordHelper::verifyPassword
  W->>CS: cs_access_user / cs_access_role for permissions
  W-->>U: 302 + session cookie (Redis-backed)

  U->>W: GET /report/sale
  W->>CS: cs_user_filial (visible filials)
  W->>BD: SELECT * FROM d0_filial WHERE active='Y'
  Note over W: BaseModel::getOwnFilials()<br/>= cs_user_filial ∩ d0_filial<br/>(optionally filtered by country_id<br/>via cs_filial_detail→cs_territory→cs_region)
  loop for each visible filial prefix fN
    W->>BD: SELECT … FROM d0_fN_<entity>
  end
  W-->>U: aggregated report
```

## Матрица модуль → подключение

Сигнал на уровне кода: ~440 вызовов `Yii::app()->dealer` против ~14
`Yii::app()->db` в `protected/`. Control-DB маленькая и
metadata-формы; dealer-DB — там, где случается работа.

```mermaid
flowchart LR
  USR[user] --> CS_C
  PLAN[plan tables] --> CS_C
  TG[telegram_bot] --> CS_C
  ACL[access_role / access_user] --> CS_C
  PVC[pivot_config] --> CS_C
  GEO[country / region / territory] --> CS_C

  DIR[directory] --> BD_C
  DASH[dashboard] --> BD_C
  REP[report · 30+ reports] --> BD_C
  PIV[pivot] --> BD_C
  API[api · Isellmore v1-4, V2, Cislink, …] --> BD_C
  API3[api3 · manager mobile] --> BD_C

  CS_C[Yii::app->db<br/>cs3_demo / cs_]
  BD_C[Yii::app->dealer<br/>b_demo / d0_ + d0_fN_]

  class USR,PLAN,TG,ACL,PVC,GEO action
  class DIR,DASH,REP,PIV,API,API3 action
  class CS_C,BD_C approval
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
```

## Заметки по сравнению со старым описанием

Страница [Multi-DB connection](./multi-db.md) описывает модель, в которой
sd-cs создаёт short-lived `CDbConnection` объекты на каждого дилера
(много отдельных дилерских БД). Текущее развёртывание использует **одну**
дилерскую БД (`b_demo`) с **внутренней multi-tenancy через filial
префиксы**. Диаграммы выше отражают то, что делает сегодняшний работающий
код; старая заметка оставлена для исторического контекста.
