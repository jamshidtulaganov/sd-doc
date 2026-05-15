---
sidebar_position: 9
title: finans
audience: Backend engineers, QA, PM, Finance ops
summary: Financial accounting layer in sd-main — P&L, agent P&L, pivot P&L, cashbox transfers, consumption / expense tracking.
topics: [finance, pnl, cashbox, transfer, consumption, expense]
---

# `finans` module

Financial accounting layer for sd-main. Aggregates the money side of
the business: P&L, agent P&L, cashbox movements, expenses.

## Key features

| Feature | What it does | Owner role(s) |
|---------|--------------|---------------|
| P&L by period | Income / expense / margin per period | 1 / 9 / Finance |
| Pivot P&L | Slice-and-dice P&L | 1 / 9 / Finance |
| Agent P&L | Per-agent profitability | 1 / 8 / 9 |
| Cashbox displacement | Move money between cashboxes (e.g. agent → main) | 6 / Finance |
| Payment transfer | Reassign a payment to a different cashbox / order | 1 / 6 |
| Consumption / expense tracking | Operational expenses against budget | 1 / Finance |

## Folder

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

## See also

- [`pay`](./payment.md) — payment recording
- [`payment`](./payment.md) — payment approval workflow

## Workflows

### Entry points

| Trigger | Controller / Action / Job | Notes |
|---|---|---|
| Web — agent P&L grid | `AgentPnlController::actionIndex` | Per-agent P&L view, separate from filial-wide PnL |
| Web | `CashboxDisplacementController::actionIndex` | Renders cashbox-displacement list view |
| Web (GET) | `CashboxDisplacementController::actionGetDisplacement` | Returns filtered displacement records as JSON |
| Web (POST) | `CashboxDisplacementController::actionSave` | Creates a new cashbox displacement + paired Consumption rows |
| Web (GET) | `CashboxDisplacementController::actionCancelDisplacement` | Sets `STATUS=2`, deletes paired Consumption rows |
| Web (POST) | `PaymentTransferController::actionCreate` | Creates inter-filial payment transfer document + debit Consumption |
| Web (POST) | `PaymentTransferController::actionChangeStatus` | Advances PaymentTransfer status; on ACCEPTED writes ClientTransaction or Consumption |
| Web — pivot P&L grid | `PivotPnlController::actionIndex` | Cross-tab P&L pivot view |
| Web (POST) | `ConsumptionController::actionIndex` (POST branch) | Adds, edits, or deletes a Consumption expense row |
| Web (POST) | `ConsumptionController::actionCredit` (POST branch) | Adds, edits, or deletes a credit (income) Consumption row |
| Web | `PnlController::actionIndex` | Builds `pnl` temp table via `Finans::pnlTempTable`, aggregates into P&L view |

---

### Domain entities

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

### Workflow 1.1 — Cashbox displacement (internal transfer between cashboxes)

A cashier or finance manager moves funds from one cashbox to another within the same filial. The controller writes a `cashbox_displacement` record and two paired `consumption` rows — a debit (TYPE=0) from the source cashbox and a credit (TYPE=1) into the destination cashbox — inside a single DB transaction. Cancellation deletes both consumption rows and marks the displacement STATUS=2.

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

### Workflow 1.2 — Inter-filial payment transfer (send → receive lifecycle)

A sender filial initiates a payment transfer to another filial. The document travels through statuses (PENDING=2 → ACCEPTED=3 or REJECTED=4 / CANCELLED=5). On creation the sender's cashbox balances are debited via `consumption` (TRANS_TYPE=4, TYPE=0). On acceptance by the receiver, funds are credited either as a `ClientTransaction` (TRANS_TYPE=3, when `trans=1`) or as a `consumption` (TYPE=1, TRANS_TYPE=4). Rejection or cancellation deletes the debit consumption rows.

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

### Workflow 1.3 — Expense / income recording and P&L inclusion

Finance staff record operational expenses (TYPE=0) or cashbox income (TYPE=1) directly through `ConsumptionController`. Each row is tagged with a fund (`ConsumptionParent`) and category (`ConsumptionChild`). `PnlController::actionIndex` reads `consumption` WHERE `TRANS_TYPE=1 AND EXCLUDE_PNL=0` to add operating expenses and other income into the P&L totals after `Finans::pnlTempTable` populates the `pnl` temp table from sales data.

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

### Cross-module touchpoints

- Reads: `pay.ClientTransaction` (TRANS_TYPE IN(3,4,5) — used for cashbox balance calculation in `CashboxDisplacementController::getCashboxBalance` and `PaymentTransferController::getCashboxBalance`)
- Writes: `pay.ClientTransaction` (INSERT TRANS_TYPE=3, TYPE=1 when payment transfer is accepted with `trans=1` flag — via `PaymentTransferController::savePaymentAsTransaction`)
- Writes: `pay.ClientFinans` (`ClientFinans::correct` called after writing ClientTransaction on transfer acceptance)
- Reads: `settings.Closed` (period-lock check via `Closed::model()->check_update('finans', date)` before any expense write in `ConsumptionController`)
- Reads: `warehouse.LotDistribution` / `orders.Order` (used by `Finans::pnlTempTable` when `ServerSettings::enableLotManagement()` is true)

---

### Gotchas

- `CashboxDisplacement` and `PaymentTransfer` both extend `BaseFilial`, so their table names are filial-prefixed at runtime. Cross-filial queries in `PaymentTransferController::actionChangeStatus` switch the active filial context via `BaseFilial::setFilial($prefix)` before querying the receiver's `payment_transfer` table — failure to switch back can corrupt the session filial context.
- `Consumption.TRANS_TYPE` is load-bearing for P&L: only rows with `TRANS_TYPE=1` flow into `PnlController`. Rows written by displacement (`TRANS_TYPE=2`) and payment-transfer (`TRANS_TYPE=4`) are silently excluded from P&L aggregation.
- `Consumption.EXCLUDE_PNL=1` is a manual override that removes a row from P&L even if `TRANS_TYPE=1`. It can be set on both add and edit paths in `ConsumptionController`.
- `PaymentTransferController::actionChangeStatus` writes to both the sender and receiver filial DB contexts in the same HTTP request. The DB transaction (`$safeTrans`) only covers the current filial connection; the remote-filial insert in `switchFilialAndSaveTransfer` is outside the transaction and not rolled back on failure.
- `ConsumptionController::actionCredit` (cashbox income, TYPE=1) does **not** call `TelegramReport::newConsumption`; only expense entries (TYPE=0 in `actionIndex`) trigger the Telegram notification.
- P&L computation has two code paths gated by `ServerSettings::enableLotManagement()`. When enabled, `Finans::pnlTempTable` uses the `LotDistribution`-based SQL; when disabled, it falls back to the legacy `Finans::pnlSql`. Both populate the same `pnl` temp table but produce **different P&L numbers** on the same data. Verify which mode the target instance runs before trusting historical comparisons.
- `PaymentTransferController::actionChangeStatus` runs `allowedStatus` twice — once in the sender's filial context (lines ~229–231), once in the receiver's after `BaseFilial::setFilial` (lines ~293–297). The STATUS update and Consumption deletes between them (lines ~237–247) execute **before** the second guard, so a partial mutation can land if the receiver-side check fails. Treat the two halves as non-atomic.

## Cashbox displacement (move money)

`CashboxDisplacementController::actionSave` (line 296) opens a single
DB transaction, validates source/destination cashboxes and currencies,
inserts one `CashboxDisplacement` row with `CB_FROM`/`CB_TO`/`SUMMA`/
`CO_SUMMA`/`RATE`, then writes two paired `Consumption` rows via
`createConsumption` — debit on the source cashbox, credit on the
destination — both tagged `TRANS_TYPE=2`. Any failure rolls back the
whole displacement.

```mermaid
flowchart LR
  A(["POST /finans/cashboxDisplacement/save"]) --> B{"Validate transferFrom + transferTo + currency"}
  B -->|invalid| R["fail() — Invalid Cashbox"]
  B -->|ok| C["beginTransaction"]
  C --> D["INSERT CashboxDisplacement CB_FROM CB_TO SUMMA CO_SUMMA RATE"]
  D --> E["INSERT Consumption TYPE=0 TRANS_TYPE=2 CASHBOX=CB_FROM (debit)"]
  D --> F["INSERT Consumption TYPE=1 TRANS_TYPE=2 CASHBOX=CB_TO (credit)"]
  E --> G["commit"]
  F --> G
  G --> S(["success — done"])

  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000

  class A,C,D,E,F action
  class B approval
  class G,S success
  class R reject
```

## Payment transfer (reassign across filial)

`PaymentTransferController::actionCreate` (line 371) opens
`$safeTrans`, calls `savePaymentTransfer(..., STATUS='2')` to insert
the sender-side `payment_transfer` row, then writes a `Consumption
TRANS_TYPE=4 TYPE=0` per item against the source cashbox.
`switchFilialAndSaveTransfer` then crosses into the receiver filial
context and saves the mirror `payment_transfer` row with
`STATUS=1 OPERATION_ID=2`. The receiver later runs
`actionChangeStatus` (line 203) to transition `STATUS` to ACCEPTED=3,
REJECTED=4, or CANCELLED=5 — the rejected/cancelled paths delete the
debit consumption rows.

```mermaid
flowchart TB
  A(["POST /finans/paymentTransfer/create"]) --> B{"Currency + Filial active + cashbox balance ok?"}
  B -->|no| R1["fail — reload_page / insufficient funds"]
  B -->|yes| C["beginTransaction"]
  C --> D["savePaymentTransfer STATUS=2 OPERATION_ID=1 (sender)"]
  D --> E["INSERT Consumption TYPE=0 TRANS_TYPE=4 per item"]
  E --> F["switchFilialAndSaveTransfer (receiver filial, STATUS=1 OPERATION_ID=2)"]
  F --> G["commit"]
  G --> H(["receiver opens /paymentTransfer/changeStatus"])
  H --> I{"status?"}
  I -->|"ACCEPTED=3, trans=1"| J["INSERT ClientTransaction TRANS_TYPE=3 + ClientFinans::correct"]
  I -->|"ACCEPTED=3, trans=0"| K["INSERT Consumption TYPE=1 TRANS_TYPE=4"]
  I -->|"REJECTED=4 / CANCELLED=5"| L["DELETE Consumption IDEN=DOCUMENT_ID TRANS_TYPE=4"]

  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000

  class A,C,D,E,F,H action
  class B,I approval
  class G,J,K success
  class R1,L reject
```
