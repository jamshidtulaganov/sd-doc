---
sidebar_position: 3
title: clients
audience: Backend engineers, QA, PM
summary: Customer (outlet/retailer) database, contracts, segments, debt snapshots, geo coordinates, and route membership.
topics: [clients, crm, b2b, route, geofence]
---

# `clients` module

Manages the **customer database** in sd-main: B2B outlets, retailers,
HoReCa, plus supporting domain objects — contracts, segments, debt,
geo location, and route membership.

## Key features

| Feature | What it does | Owner role(s) |
|---------|--------------|---------------|
| Client CRUD | Create / edit / archive client records | 1 / 2 / 5 / 9 |
| Field-created clients (mobile) | Agent submits new client during a visit; record goes to *Pending* | 4 |
| Client approval | Manager reviews pending records; approve / edit / reject | 1 / 2 / 9 |
| Categories & segments | Tier clients by sales segment; affects price type and discount | 1 / 9 |
| Contracts | Optional commercial contracts per client (terms, payment days) | 1 / 9 |
| Geo coordinates | `LAT` / `LNG` on every client; used by `gps` for geofencing | 1 / 4 |
| Route membership | Clients are grouped into routes assigned to agents | 8 / 9 |
| Debt snapshot | Computed receivables aging surfaced in reports | 6 / 9 |
| Bulk import | CSV / Excel import for migration | 1 |
| 1C / Faktura.uz round-trip | `XML_ID` + `INN` for outbound EDI | system |

## Folder

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

## Key entities

| Entity | Model | Notes |
|--------|-------|-------|
| Client | `Client` | Active outlets/customers |
| Pending client | `ClientPending` | Field-created, awaiting approval |
| Client category | `ClientCategory` | Pricing tier / segmentation |
| Contract | `ContractClient` | Commercial contract |
| Route | `Route`, `RouteClient` | Agent routes |
| Debt snapshot | `ClientDebt` | Computed aging |

## Approval workflow

See **Feature · Client Approval** in
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

| Endpoint | Purpose |
|----------|---------|
| `GET /api3/client/list` | Sync route clients to mobile |
| `POST /api3/client/create` | Field-created clients (pending) |
| `GET /api4/client/list` | B2B portal listing |

## Permissions

| Action | Roles |
|--------|-------|
| Create | 1 / 2 / 4 (pending only) / 5 |
| Approve | 1 / 2 / 9 |
| Edit | 1 / 2 / 5 / 9 |
| Archive | 1 / 2 |

## See also

- [`agents`](./agents.md) (route assignment)
- [`gps`](./gps.md) (geofencing)
- [`orders`](./orders.md) (clients are buyers)

## Workflows

### Entry points

| Trigger | Controller / Action / Job | Notes |
|---|---|---|
| Web | `ApprovalController::actionIndex` | Manager opens pending-client review list |
| Web | `ApprovalController::actionGetData` | Fetches `client_pending` rows for date range |
| Web | `ApprovalController::actionSave` | Bulk-approves pending clients, creates `Client` records |
| Web | `ApprovalController::actionDelete` | Rejects (deletes) pending clients |
| Web | `ViewController::actionAgentVisitsByWeek` | UI for agent attachment / detachment schedule |
| Web | `ViewController::actionAttachPriceType` | UI for price-type assignment to clients |
| Web | `ViewController::actionSalesCategories` | UI for sales-category assignment |
| Web API | `ApiController::getAgentVisitsByDay` | Reads `Visiting` + `VisitingMonth` for selected clients |
| Web API | `ApiController::setAgentVisitsByDay` | Replaces `Visiting` + `VisitingMonth` records in a transaction |
| Web API | `ApiController::getPriceType` | Reads `Client.PRICE_TYPE_ID` for selected clients |
| Web API | `ApiController::setPriceType` | Writes `Client.PRICE_TYPE_ID` for selected clients |
| Web API | `ApiController::getSalesCat` | Reads `SalesCategory` rows for selected clients |
| Web API | `ApiController::setSalesCat` | Replaces `SalesCategory` rows for selected clients |
| Mobile (`api3`) | `api3/ClientController::actionAddClient` | Agent submits new client; saved as `ClientPending` when `verify=true` |
| Mobile (`api3`) | `api3/ClientController::actionPending` | Agent polls own pending submissions |

### Domain entities

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

### Workflow 1.1 — Field-created client pending review

An agent creates a new client on mobile. If the distributor config has `client.verify = true`, the record is held in `ClientPending` until a manager approves or rejects it from the web back-office.

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

### Workflow 1.2 — Agent visit-schedule attachment / detachment

A manager assigns or removes agent-client visit slots (weekly by day-of-week or monthly by date). The operation is a full replace: existing `Visiting` and `VisitingMonth` rows for the client are deleted then re-inserted inside a transaction.

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

### Workflow 1.3 — Price-type and sales-category assignment

A manager bulk-assigns price types or sales categories to one or more clients. Both operations follow the same pattern through `ApiController` actions: fetch current values, edit in the UI, then persist with a single transactional write.

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

### Cross-module touchpoints

- Reads: `agents.Agent` (resolve AGENT_ID from User on approval; filter visiting schedule by agent)
- Reads: `agents.Visiting` / `VisitingMonth` (schedule display in `AgentRouteController::actionGetClients`)
- Writes: `agents.Visiting` / `VisitingMonth` (replaced on each `setAgentVisitsByDay` call)
- Writes: `clients.SalesCategory` (replaced on each `setSalesCat` call; also written during approval)
- Writes: `clients.ClientLog` (audit entry for `visitDays` field written during `ApprovalController::actionSave`)
- APIs: `api3/client/addClient` (mobile client creation → `ClientPending`)
- APIs: `api3/client/pending` (mobile agent polls own pending submissions)
- APIs: `api4/client/sales-category-list` (B2B portal reads sales categories)

### Gotchas

- `ApprovalController::actionSave` copies field values from `ClientPending` to `Client` using a hard-coded attribute list. Any new `ClientPending` column added in the future must also be added to the `$attributes` array in that method, otherwise it is silently dropped on approval.
- `agentVisitsByDay/SetAction` does a full delete-then-reinsert. Calling it with an empty `weekdays` and empty `byDate` for a client removes all visit assignments for that client with no confirmation prompt.
- `Client.PRICE_TYPE_ID` and `Client.SALES_CAT` are stored as comma-separated strings on the `client` row in addition to the normalised `sales_category` table. The two can drift out of sync if the `sales_category` table is written without also updating `Client.SALES_CAT`. `salesCat/SetAction` updates both; direct DB edits may not.
- The `api3/ClientController::actionAddClient` path splits into two code versions (`addClientVersion1` / `addClientVersion2`) based on `$_REQUEST['u'] === 'merch'`. Only version 1 writes to `ClientPending`; the merch variant (`addClientVersion2`) has its own flow.
- `ApprovalController::actionDelete` requires `operation.clients.approval.delete` permission, which is distinct from the approval permission (`operation.clients.approval`). Misconfigured roles that have approval but not delete cannot reject records.
