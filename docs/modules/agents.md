---
sidebar_position: 4
title: agents
audience: Backend engineers, QA, PM
summary: Sales agents (the field force) — profiles, plans, KPIs, vehicles, credit and discount limits.
topics: [agents, kpi, plans, limits, mobile, route]
---

# `agents` module

Sales agents (the field force) plus their plans, KPIs, vehicles, and
limits. The web admin controls how the field force is structured;
agents themselves work from the mobile app via api3.

## Key features

| Feature | What it does | Owner role(s) |
|---------|--------------|---------------|
| Agent CRUD | Create / edit / deactivate agents | 1 / 2 / 9 |
| Agent settings | Per-agent toggles (cash collection, discount caps, etc.) | 1 / 9 |
| Monthly plan | Target volumes / counts per period | 1 / 9 |
| KPI v1 / v2 | Plan-vs-actual reports per agent | 8 / 9 |
| Credit limit | Max debt the agent can accept on an order | 1 / 9 |
| Discount limit | Max discount the agent can apply | 1 / 9 |
| Vehicle assignment | Each agent links to a `Car` | 1 / 9 |
| Paket / bundles | Pre-defined product bundles agents can sell | 1 / 9 |
| Route assignment | Day-of-week routes mapped to clients | 8 / 9 |

## Folder

```
protected/modules/agents/
├── controllers/
│   ├── AgentController.php
│   ├── CarController.php
│   ├── KpiController.php
│   ├── KpiNewController.php   # v2 — prefer for new screens
│   └── LimitController.php
└── views/
```

## Key entities

| Entity | Model |
|--------|-------|
| Agent | `Agent` |
| Agent settings | `AgentSettings` |
| Agent plan | `AgentPlan` |
| Agent paket | `AgentPaket` |
| Car | `Car` |
| KPI | various `Kpi*` models |

## Plans & KPI

Agent plans are managed monthly. `KpiController` reports actual vs.
plan numbers; `KpiNewController` is the rewrite — new projects should
prefer it.

## Limits

`LimitController` enforces credit and discount limits. Limits are
checked **at order creation** and **at approval**. An agent that
exceeds either limit forces the order into manager-approval state.

## Mobile (api3)

The agent mobile app calls api3:

- [`POST /api3/login/index`](../api/api-v3-mobile/index.md#login)
- [`POST /api3/visit/index`](../api/api-v3-mobile/index.md#visits)
- `GET /api3/agent/route` — today's clients
- `GET /api3/kpi/index` — agent's own KPI tile

## Key feature flow — Visit & GPS

See **Feature · Visit & GPS geofence** in
[FigJam · sd-main · Feature Flows](https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU).

```mermaid
flowchart LR
  CK(["Tap Check-in"]) --> POS["Read GPS"]
  POS --> POST["POST /api3/visit"]
  POST --> RAD{"Distance to client ≤ geofence radius?"}
  RAD -->|yes| OK["Visit OK"]
  RAD -->|no| WARN["Flagged out_of_zone"]
  OK --> WORK["Audits, orders, payments"]
  WARN --> WORK
  WORK --> CO(["Check-out"])
classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
classDef approval fill:#fef3c7,stroke:#92400e,color:#000
classDef success  fill:#dcfce7,stroke:#166534,color:#000
classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
classDef external fill:#f3f4f6,stroke:#374151,color:#000
classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
class CK,POS,POST,WORK,CO action
class OK success
class WARN reject
```

## Visit post-check (server-side recheck of synced visits)

After the mobile app uploads visits via `api3/VisitController::actionPost`,
it follows up with `actionPostCheck`
(`protected/modules/api3/controllers/VisitController.php:97`). The
endpoint re-fetches the canonical `Visit` row by
`(AGENT_ID, CLIENT_ID, day)`, applies the device-side `startTime` /
`endTime` to `CHECK_IN_TIME` / `CHECK_OUT_TIME`, sets `VISITED=1`,
and calls `Visit::sync_end_method` to close the agent's session.
Synthetic `new_*` client IDs are skipped (those are agent-created
clients still pending approval).

```mermaid
flowchart LR
  M(["Mobile: POST /api3/visit/postCheck"]) --> ITER["foreach visit in payload"]
  ITER --> SK{"clientId starts with new_ ?"}
  SK -- "yes" --> SKIP(["skip - unresolved client"])
  SK -- "no" --> LK["Visit::return_model AGENT_ID, clientId, day"]
  LK --> UP["UPDATE visit SET VISITED=1, CHECK_IN_TIME, CHECK_OUT_TIME"]
  UP --> RSP["append {id, clientId, status:1, ok:true}"]
  RSP --> END{more visits?}
  END -- "yes" --> ITER
  END -- "no" --> SYNC["Visit::sync_end_method AGENT_ID"]
  SYNC --> OK(["respond JSON"])

  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000

  class M,ITER,LK,UP,RSP,SYNC action
  class SK,END approval
  class OK success
  class SKIP reject
```

## Limit enforcement (agent product / credit caps)

`LimitController::actionEdit`
(`protected/modules/agents/controllers/LimitController.php`)
defines per-agent product quantity caps stored in
`Warehouse` + `WarehouseDetail`. `LimitReportController` surfaces
remaining counts; the actual enforcement happens at order-save time
when `api3/OrderController` triggers `WarehouseDetail::Sale` to
decrement `COUNT` per `(AGENT_ID, PRODUCT_ID, STORE_ID)`. A would-be
negative count blocks the sale.

```mermaid
flowchart LR
  E(["Admin: POST /agents/limit/edit"]) --> EC["LimitController::actionEdit"]
  EC --> WH["UPSERT Warehouse IDEN=agent, TYPE_LIMIT"]
  WH --> WD["INSERT/UPDATE WarehouseDetail per PRODUCT_ID, STORE_ID"]
  WD --> RPT["LimitReportController: read remaining COUNT"]
  O(["Mobile: POST /api3/order"]) --> WS["WarehouseDetail::Check by AGENT_ID + PRODUCT_ID + STORE_ID"]
  WS --> CK{"remaining COUNT >= order COUNT?"}
  CK -- "yes" --> SALE["WarehouseDetail::Sale: COUNT -= order COUNT"]
  SALE --> OK(["Order accepted"])
  CK -- "no" --> ERR(["error: limit exceeded"])

  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000

  class E,EC,WH,WD,RPT,O,WS,SALE action
  class CK approval
  class OK success
  class ERR reject
```

## Permissions

| Action | Roles |
|--------|-------|
| Create / edit | 1 / 2 / 9 |
| View KPI | 1 / 2 / 8 / 9 (own only for 4) |
| Set limits | 1 / 2 / 9 |

## Workflows

### Entry points

| Trigger | Controller / Action / Job | Notes |
|---|---|---|
| Web (admin) | `AgentController::actionCreateAjax` | Creates `Agent` + linked `User` (role 4); enforces subscription limits |
| Web (admin) | `AgentController::actionUpdateAjax` | Updates agent profile and `User` credentials |
| Web (admin) | `LimitController::actionEdit` | Saves per-product quantity limits into `Warehouse` / `WarehouseDetail` |
| Web (admin) | `LimitController::actionChangeType` | Switches a limit's `TYPE_LIMIT` (daily / monthly / 30-day) |
| Web (admin) | `VisitingController::actionSaveOrder` | Persists day-of-week route order for an agent into `Visiting` |
| Web (admin) | `KpiNewController::actionSetting` | Creates or updates `Kpi` + `KpiTask` records for a period |
| Web (admin) | `KpiNewController::actionTemplate` | Creates or updates `KpiTaskTemplate` (optionally replicated to filials) |
| Mobile (api3) | `api3/KpiController::actionIndex` | Returns this month's KPI tile data to the mobile app |
| Mobile (api3) | `api3/VisitController` | Returns today's client route via `Visiting` rows |

---

### Domain entities

```mermaid
erDiagram
    Agent {
        string AGENT_ID PK
        string FIO
        string ACTIVE
        int    VAN_SELLING
        int    DILER_ID
    }
    AgentSettings {
        string AGENT_ID PK
        string SETTINGS
    }
    AgentPlan {
        string AGENT_PLAN_ID PK
        string AGENT_ID FK
        string TYPE
        string PLAN
        int    MONTH
        int    YEAR
    }
    Visiting {
        string CLIENT_ID PK
        int    AGENT_ID FK
        string DAY
        int    SORT
        int    WEEK_TYPE
        int    WEEK_POSITION
    }
    Kpi {
        string KPI_ID PK
        string TEAM
        string TEAM_TYPE
        int    MONTH
        int    YEAR
        string KPI_TYPE
    }
    KpiTask {
        string KPI_TASK_ID PK
        string KPI_ID FK
        string TEMPLATE_ID FK
        float  VALUE
        string TASK_TYPE
    }
    KpiTaskTemplate {
        string ID PK
        string NAME
        string TASK_TYPE
        string ACTIVE
        int    SUPERVISER
    }
    Warehouse {
        string WAREHOUSE_ID PK
        string IDEN
        string TYPE
        string TYPE_LIMIT
        int    DILER_ID
    }
    WarehouseDetail {
        string WAREHOUSE_DETAIL_ID PK
        string WAREHOUSE_ID FK
        string IDEN
        string PRODUCT_ID
        string STORE_ID
        int    COUNT
    }

    Agent ||--o{ AgentSettings : "has"
    Agent ||--o{ AgentPlan : "has"
    Agent ||--o{ Visiting : "visits"
    Kpi ||--o{ KpiTask : "contains"
    KpiTask }o--|| KpiTaskTemplate : "based on"
    Warehouse ||--o{ WarehouseDetail : "details"
```

---

### Workflow 1.1 — Agent creation with subscription check

When an admin creates a new agent, `AgentController::actionCreateAjax` verifies the tenant's subscription cap for the agent type (field, van-selling, or seller) before persisting the `Agent` and its linked `User` account. Van-selling agents also get a dedicated warehouse created or attached at this point.

```mermaid
sequenceDiagram
    participant Web
    participant AgentController
    participant DB

    Web->>AgentController: POST /agents/agent/createAjax (Agent[], User[], agent_type, warehouse)
    AgentController->>DB: SELECT Agent WHERE VAN_SELLING=type AND ACTIVE='Y'
    DB-->>AgentController: current agent count
    alt count >= subscription limit
        AgentController-->>Web: json {success:false, message:"limit reached"}
    else
        AgentController->>DB: INSERT agent (Agent table)
        AgentController->>DB: INSERT user (User table, ROLE=4, AGENT_ID=new id)
        alt agent_type == TYPE_VANSEL and warehouse == "0"
            AgentController->>DB: INSERT store (Store table, VAN_SELLING=1)
            AgentController->>DB: INSERT CreatedStores (AGENT_ID)
        end
        AgentController-->>Web: json {success:true, id:AGENT_ID}
    end
```

---

### Workflow 1.2 — Day-of-week route assignment

An admin assigns clients to an agent's weekday route via `VisitingController`. The controller reads existing `Visiting` rows grouped by day, allows drag-and-drop re-ordering, and flushes the `SORT` and `WEEK_TYPE` values back to the database. The mobile app subsequently reads today's clients through the `api3/VisitController`.

```mermaid
sequenceDiagram
    participant Web
    participant VisitingController
    participant DB
    participant Mobile
    participant api3

    Web->>VisitingController: GET /agents/visiting/getAgents?agent_id=X
    VisitingController->>DB: SELECT DAY, COUNT(CLIENT_ID) FROM visiting WHERE AGENT_ID=X
    DB-->>VisitingController: days summary
    VisitingController-->>Web: json {days, follow_sequence}

    Web->>VisitingController: GET /agents/visiting/getClients?agent_id=X&day=3
    VisitingController->>DB: SELECT CLIENT_ID, WEEK_TYPE, SORT FROM visiting WHERE AGENT_ID=X AND DAY=3
    DB-->>VisitingController: client rows
    VisitingController-->>Web: json client list

    Web->>VisitingController: POST /agents/visiting/saveOrder (visits[], follow_sequence)
    VisitingController->>DB: UPDATE visiting SET SORT, WEEK_TYPE WHERE AGENT_ID AND CLIENT_ID AND DAY
    VisitingController->>DB: UPDATE AgentPaket.SETTINGS (follow_sequence flag)
    VisitingController-->>Web: json {success:true}

    Mobile->>api3: GET /api3/visit (deviceToken)
    api3->>DB: SELECT visiting WHERE AGENT_ID=X AND DAY=today ORDER BY SORT
    DB-->>api3: ordered client list
    api3-->>Mobile: json route
```

---

### Workflow 1.3 — KPI v2 monthly plan assignment

Each month an admin selects agents, a period (month/year), and target values per `KpiTaskTemplate`. `KpiNewController::actionSetting` creates one `Kpi` row per agent-period (or reuses the existing one) and upserts child `KpiTask` rows. If the account has filials and a template is flagged for cross-filial copy, the controller iterates over each filial prefix and saves a mirrored record before returning to the main database.

```mermaid
flowchart TD
    A(["Web: POST /agents/kpiNew/setting"]) -- agent + month + year + fields --> B[KpiNewController::actionSetting]
    B -- all fields zero? --> C{unset_agent?}
    C -- yes --> D[DELETE KpiTask WHERE KPI_ID]
    D -- last task deleted --> E[DELETE Kpi row]
    C -- no --> F{Kpi row exists?}
    F -- no --> G[INSERT Kpi: TEAM=agent_id, MONTH, YEAR, TEAM_TYPE=agent]
    F -- yes --> H[UPDATE Kpi.FIX_SALARY]
    G -- saved --> I[Upsert KpiTask per template_id]
    H -- saved --> I
    I -- "template COPY=1 && isMain?" --> J[Loop filials: BaseFilial::setFilial]
    J -- each filial --> K["INSERT/UPDATE KpiTask in filial DB"]
    K -- done --> L[BaseFilial::setFilial main]
    I -- no filials --> M(["Redirect /agents/kpiNew/"])
    L --> M
    E --> M
```

---

### Workflow 1.4 — Product-quantity limit enforcement at order time

An admin defines how many units of each product an agent may sell in a given period via `LimitController`. The limit type (daily `"1"`, monthly `"2"`, or rolling-30-day `"3"`) is stored in `Warehouse.TYPE_LIMIT`. When the mobile app syncs an order, `api3/OrderController` triggers `WarehouseDetail::Sale`, which decrements the remaining count for the matching `(AGENT_ID, PRODUCT_ID, STORE_ID)` row. If the count would go negative the sale is blocked.

```mermaid
flowchart TD
    A(["Web: POST /agents/limit/edit"]) -- agent, products, counts --> B[LimitController::actionEdit]
    B -- Warehouse missing? --> C[INSERT Warehouse: IDEN=agent_id, TYPE=agent, TYPE_LIMIT]
    B -- Warehouse exists --> D[UPDATE Warehouse.COUNT = 0]
    C -- saved --> E[INSERT WarehouseDetail per product]
    D -- saved --> E
    E --> F(["Redirect /agents/limit/"])
    G(["Mobile: POST /api3/order"]) -- order payload --> H["api3/OrderController::actionIndex"]
    H -- foreach order detail --> I["WarehouseDetail::Check: find row by AGENT_ID + PRODUCT_ID + STORE_ID"]
    I -- row found --> J{"remaining COUNT >= order COUNT?"}
    J -- yes --> K[WarehouseDetail::Sale: COUNT -= order COUNT]
    K -- saved --> L([Order saved to DB])
    J -- no --> M([Return error: limit exceeded])
    I -- no row --> L
```

---

### Cross-module touchpoints

- Reads: `planning.Planning` (agent monthly totals consumed by `api3/KpiController::version2`)
- Reads: `orders.Order` / `orders.OrderDetail` (actual vs. plan comparison in KPI calculation)
- Writes: `warehouse.Warehouse` / `warehouse.WarehouseDetail` (limit buckets written by `LimitController`)
- Writes: `users.User` (role-4 user record created/updated alongside every `Agent` save in `AgentController`)
- APIs: `api3/kpi/index` — agent's own monthly KPI tile
- APIs: `api3/visit/*` — today's ordered client route built from `Visiting` rows

---

### Gotchas

- `AgentController::actionIndex` immediately redirects to `/staff/view/agent`; the agent list is rendered by the `staff` module, not here.
- `KpiNewController` stores the team as a plain comma-separated string in `Kpi.TEAM`, not a foreign-key join table, so bulk deletes require string-matching logic.
- `Warehouse.TYPE_LIMIT` values `"1"`, `"2"`, `"3"` are reset display labels ("За день", "За месяц", "За 30 дней") with no enum guard; passing an unknown value silently stores it without error.
- `AgentPaket.SETTINGS` is a large JSON blob (up to 100 000 chars per rules) that contains both route `follow_sequence` config and other app-level toggles; edits from multiple screens clobber each other unless the full blob is read-modify-written.
- `KpiTaskTemplate` soft-deletes by setting `ACTIVE = "N"` (`KpiNewController::actionDelete`); hard-delete code is commented out, so orphan `KpiTask` rows can accumulate.
