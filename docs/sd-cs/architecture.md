---
sidebar_position: 4
title: Architecture (verified)
---

# sd-cs — Architecture (verified from running code)

These diagrams reflect the **actual** behaviour of the deployed sd-cs:
two MySQL schemas (control + warehouse) and a per-tenant **filial**
prefix scheme inside the warehouse DB. Verified against the
`cs3_demo` / `b_demo` schemas and the `BaseModel` / `V2Controller`
code paths.

> Visual taxonomy follows the
> [Diagram gallery](/docs/diagrams) standard
> (blue = action, amber = approval, green = success, red = reject,
> grey = external, purple = cron).

## Two-DB connection map

`Yii::app()->db` connects to `cs3_demo` (control plane, 23 tables,
prefix `cs_`). `Yii::app()->dealer` connects to `b_demo` (operational
warehouse, ~1 684 tables, prefix `d0_`). Both are configured in
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

`cs3_demo` holds auth, RBAC, geography, plans, telegram bots, pivot
configs. `b_demo` holds all operational dealer data, partitioned per
filial.

## Cross-DB linkage (filial bridge)

There are **no foreign keys across the two schemas** — the two DBs are
joined logically by `filial_id`. The canonical filial registry lives
in `b_demo.d0_filial`; `cs3_demo` enriches each filial with country /
territory metadata and per-user ACLs.

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

## Multi-tenant layout inside `b_demo`

`b_demo` mixes two kinds of tables: dealer-global (no filial prefix)
and per-filial (`d0_fN_*`). Demo size: 7 active filials (`f1..f7`),
~227 tables per filial, plus ~50 dealer-global tables.

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

Per-filial entities include `client`, `agent`, `order`, `visit`,
`audit`, `cashbox`, `bonus_*`, `cars`, `catalog_*`, etc. — each filial
gets its own copy, scoped by the `fN_` prefix.

## `setFilial()` table rewrite

The mechanism that lets one model class address many tenants lives in
`protected/components/BaseModel.php` (`tableName()`,
`getFilialTable()`, `setFilial()`). Calling `setFilial('f3')` rewrites
the table token from `{{client}}` to `{{f3_client}}`, which Yii
expands using the `dealer` connection's `tablePrefix='d0_'`,
producing `d0_f3_client`.

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

## Login → filial scoping → query

End-to-end request flow: auth happens in `cs3_demo`; data fetch
happens in `b_demo`, scoped to the user's allowed filials via
`cs_user_filial` and (optionally) `country_id`.

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

## Module → connection matrix

Code-level signal: ~440 calls to `Yii::app()->dealer` vs ~14 to
`Yii::app()->db` in `protected/`. The control DB is small and
metadata-shaped; the dealer DB is where the work happens.

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

## Notes vs the older description

The page [Multi-DB connection](./multi-db.md) describes a model where
sd-cs constructs short-lived `CDbConnection` objects per dealer
(many separate dealer DBs). The current deployment uses a **single**
dealer DB (`b_demo`) with **internal multi-tenancy via filial
prefixes**. The diagrams above reflect what the running code does
today; the older note is kept for historical context.
