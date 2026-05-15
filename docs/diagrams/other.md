---
sidebar_position: 99
title: "Other"
audience: All team members
summary: "Cross-cutting diagrams that don't fit a single project bucket."
topics: [diagrams, other]
---

# Other — diagram gallery

Cross-cutting diagrams that don't fit a single project bucket.

All 26 diagrams in this group, drawn inline.

## Index

| # | Title | Kind | Source page |
|---|-------|------|-------------|
| 01 | [Master view](#d-01) | `flowchart` | [quality/clients/index](/docs/quality/clients/index) |
| 02 | [How they're used downstream](#d-02) | `flowchart` | [quality/clients/categorisation](/docs/quality/clients/categorisation) |
| 03 | [Master view](#d-03) | `flowchart` | [quality/settings/index](/docs/quality/settings/index) |
| 04 | [Master view — how the screens fit together](#d-04) | `flowchart` | [quality/payment/index](/docs/quality/payment/index) |
| 05 | [Master view — how the screens build on the same tables](#d-05) | `flowchart` | [quality/payment/index](/docs/quality/payment/index) |
| 06 | [Step by step — recording a supplier payment](#d-06) | `sequence` | [quality/payment/supplier-finance](/docs/quality/payment/supplier-finance) |
| 07 | [How it all hangs together](#d-07) | `flowchart` | [quality/payment/expenses-and-pnl](/docs/quality/payment/expenses-and-pnl) |
| 08 | [Step by step — managing categories](#d-08) | `flowchart` | [quality/payment/expenses-and-pnl](/docs/quality/payment/expenses-and-pnl) |
| 09 | [Step by step — PNL screen](#d-09) | `flowchart` | [quality/payment/expenses-and-pnl](/docs/quality/payment/expenses-and-pnl) |
| 10 | [Step by step — inter-filial transfer](#d-10) | `sequence` | [quality/payment/expenses-and-pnl](/docs/quality/payment/expenses-and-pnl) |
| 11 | [The big picture](#d-11) | `flowchart` | [quality/integrations/index](/docs/quality/integrations/index) |
| 12 | [How the balance is computed](#d-12) | `flowchart` | [quality/finans/cashbox-balance](/docs/quality/finans/cashbox-balance) |
| 13 | [Master view](#d-13) | `flowchart` | [quality/finans/index](/docs/quality/finans/index) |
| 14 | [How they balance](#d-14) | `flowchart` | [quality/finans/transaction-types](/docs/quality/finans/transaction-types) |
| 15 | [How balances split per currency](#d-15) | `flowchart` | [quality/finans/multi-currency](/docs/quality/finans/multi-currency) |
| 16 | [The algorithm in plain words](#d-16) | `flowchart` | [quality/finans/settlement](/docs/quality/finans/settlement) |
| 17 | [How they map onto each other](#d-17) | `flowchart` | [quality/team/index](/docs/quality/team/index) |
| 18 | [Where the agent connects to other modules](#d-18) | `flowchart` | [quality/team/role-agent](/docs/quality/team/role-agent) |
| 19 | [Where the expeditor connects to other modules](#d-19) | `flowchart` | [quality/team/role-expeditor](/docs/quality/team/role-expeditor) |
| 20 | [Where the supervisor connects to other modules](#d-20) | `flowchart` | [quality/team/role-supervisor](/docs/quality/team/role-supervisor) |
| 21 | [The big picture — a typical agent workday on the phone](#d-21) | `sequence` | [quality/mobile/index](/docs/quality/mobile/index) |
| 22 | [The two-system surface](#d-22) | `flowchart` | [quality/markirovka/index](/docs/quality/markirovka/index) |
| 23 | [The big picture — order lifecycle](#d-23) | `state` | [quality/orders/index](/docs/quality/orders/index) |
| 24 | [Master view](#d-24) | `flowchart` | [quality/stock/index](/docs/quality/stock/index) |
| 25 | [What happens on the stock side](#d-25) | `sequence` | [quality/stock/defect-and-van-stock](/docs/quality/stock/defect-and-van-stock) |
| 26 | [Where stock goes](#d-26) | `flowchart` | [quality/stock/defect-and-van-stock](/docs/quality/stock/defect-and-van-stock) |

## 01. Master view {#d-01}

- **Kind**: `flowchart`
- **Source page**: [quality/clients/index](/docs/quality/clients/index)
- **Originating section**: Master view

```mermaid
flowchart LR
    Web([Web operator]) -- creates / edits --> C[Client record]
    Mob([Agent mobile]) -- creates with verify=yes --> CP[ClientPending]
    Mgr([Manager]) -- approves --> C
    C --> Vis[Visiting / route]
    C --> Exp[Expeditor link]
    C --> Ord([Orders module])
    C --> Fin([Finans module])
    C --> Aud([Audit module])
```

## 02. How they're used downstream {#d-02}

- **Kind**: `flowchart`
- **Source page**: [quality/clients/categorisation](/docs/quality/clients/categorisation)
- **Originating section**: How they're used downstream

```mermaid
flowchart LR
    Client --> Cat[Category]
    Client --> Channel
    Client --> SalesCat[Sales categories]
    Client --> Class
    Cat --> Rules[Auto-discount / auto-bonus rules]
    Channel --> Rules
    SalesCat --> Rules
    Class --> Rules
    Cat --> Reports
    Channel --> Reports
    SalesCat --> Reports
```

## 03. Master view {#d-03}

- **Kind**: `flowchart`
- **Source page**: [quality/settings/index](/docs/quality/settings/index)
- **Originating section**: Master view

```mermaid
flowchart LR
    Cfg([Settings module])
    Lkp[(Lookups: cashbox, price type,<br/>channel, trade direction, city)]
    Rls[(Rules: bonus, discount, manual discount)]
    Usr[(Users, roles, RBAC grid)]
    Tog[(Global toggles + status_config.txt)]
    Per[(Period close)]

    Cfg --> Lkp
    Cfg --> Rls
    Cfg --> Usr
    Cfg --> Tog
    Cfg --> Per

    Lkp --> Ord([Orders])
    Lkp --> Fin([Finans])
    Lkp --> Stk([Stock])
    Rls --> Ord
    Usr --> Ord
    Usr --> Fin
    Usr --> Stk
    Tog --> Ord
    Tog --> Fin
    Tog --> Stk
    Per --> Ord
    Per --> Fin
    Per --> Stk
```

## 04. Master view — how the screens fit together {#d-04}

- **Kind**: `flowchart`
- **Source page**: [quality/payment/index](/docs/quality/payment/index)
- **Originating section**: Master view — how the screens fit together

```mermaid
flowchart LR
    Mob([Mobile expeditor<br/>collects cash])
    PD[(PaymentDeliver<br/>pending row)]
    App([Manager: **Подтверждение оплаты**<br/>Payment approval])
    CT[(ClientTransaction<br/>TRANS_TYPE=3 receipt)]
    Cons([Operator: **Расходы**<br/>Expense entry])
    CC[(Consumption rows<br/>TYPE=0 expense<br/>TYPE=1 other-income)]
    PT([Operator: **Перевод платежей**<br/>Inter-filial transfer])
    PNL([Manager: P&L screen])
    SF([Operator: **Оплаты поставщикам**<br/>Supplier payment])
    ST[(ShipperTransaction)]
    Rep([Reports + cashbox balance])

    Mob --> PD
    PD --> App
    App -- approves --> CT
    Cons --> CC
    PT --> CC
    SF --> ST
    SF -- writes parallel --> CC
    CT --> Rep
    CC --> Rep
    ST --> Rep
    CC --> PNL
    CT --> PNL
```

## 05. Master view — how the screens build on the same tables {#d-05}

- **Kind**: `flowchart`
- **Source page**: [quality/payment/index](/docs/quality/payment/index)
- **Originating section**: Master view — how the screens build on the same tables

```mermaid
flowchart TB
    subgraph Field
        PD[(PaymentDeliver)]
    end
    subgraph Manager
        App[Approval screen]
    end
    subgraph Ledger
        CT[(ClientTransaction)]
        CC[(Consumption)]
        ST[(ShipperTransaction)]
    end
    subgraph Reports
        PNL[P&L]
        DDS[Cash-movement report]
        CB[Cashbox balance]
        SR[Supplier reconciliation act]
    end

    PD --> App
    App --> CT
    App -- closes invoice --> CT
    CC --> PNL
    CC --> DDS
    CT --> DDS
    CT --> CB
    CC --> CB
    ST --> SR
    ST -- often paired with --> CC
```

## 06. Step by step — recording a supplier payment {#d-06}

- **Kind**: `sequence`
- **Source page**: [quality/payment/supplier-finance](/docs/quality/payment/supplier-finance)
- **Originating section**: Step by step — recording a supplier payment

```mermaid
sequenceDiagram
    autonumber
    participant Op as Operator
    participant F as Payment form
    participant Closed as Closed-period gate
    participant ST as ShipperTransaction
    participant Cons as Consumption
    participant CB as Cashbox total

    Op->>F: Pick supplier, per-currency rows (summa, date, comment),<br/>optional toggle: "also create cashbox expense"<br/>+ category + cashbox
    Op->>F: Submit
    loop per currency line
        F->>Closed: Check the period for this date
        alt period closed and not exempt
            Closed-->>F: Redirect to error
        else
            F->>ST: INSERT ShipperTransaction TYPE=1<br/>(payment to supplier)
            alt operator ticked "consumption=yes"
                F->>Cons: INSERT Consumption TYPE=0 TRANS_TYPE=3<br/>SHIPPER_TRANS_ID = ST.ID<br/>comment = original + supplier name
                Cons-->>CB: cashbox total decreases
            end
        end
    end
    F-->>Op: Redirect to supplier-payments list
```

## 07. How it all hangs together {#d-07}

- **Kind**: `flowchart`
- **Source page**: [quality/payment/expenses-and-pnl](/docs/quality/payment/expenses-and-pnl)
- **Originating section**: How it all hangs together

```mermaid
flowchart LR
    Op([Operator])
    Cash[(Cashbox)]
    Cons[(Consumption table)]
    CT[(ClientTransaction)]
    DDS([ДДС report])
    PNL([PNL screen])
    PT([Inter-filial transfer])
    SF([Supplier payment])

    Op -- "Расходы (TYPE=0)" --> Cons
    Op -- "Прочие приходы (TYPE=1)" --> Cons
    PT -- "TRANS_TYPE=4" --> Cons
    SF -- "TRANS_TYPE=3" --> Cons
    Cons -- expense out --> Cash
    Cons -- income in --> Cash
    Cash --> DDS
    CT --> DDS
    Cons -- "TYPE=0, TRANS_TYPE=1,<br/>EXCLUDE_PNL=0" --> PNL
    Cons -- "TYPE=1, TRANS_TYPE=1,<br/>EXCLUDE_PNL=0" --> PNL
    CT -- "TRANS_TYPE=8<br/>bad debt" --> PNL
```

## 08. Step by step — managing categories {#d-08}

- **Kind**: `flowchart`
- **Source page**: [quality/payment/expenses-and-pnl](/docs/quality/payment/expenses-and-pnl)
- **Originating section**: Step by step — managing categories

```mermaid
flowchart LR
    P[ConsumptionParent<br/>fund / фонд]
    C[ConsumptionChild<br/>article / статья]
    R[Consumption row<br/>= one expense]
    P --> C
    C --> R
    P --> R
```

## 09. Step by step — PNL screen {#d-09}

- **Kind**: `flowchart`
- **Source page**: [quality/payment/expenses-and-pnl](/docs/quality/payment/expenses-and-pnl)
- **Originating section**: Step by step — PNL screen

```mermaid
flowchart LR
    Sales[(Sales rows<br/>last X days)]
    Lots[(Lot purchase prices)]
    Cons[(Consumption<br/>operating expenses)]
    BadDebt[(ClientTransaction<br/>TRANS_TYPE=8)]
    P[PNL temp table<br/>= revenue, cost, profit per sale]
    Out[Final P&L view]

    Sales --> P
    Lots --> P
    P --> Out
    Cons --> Out
    BadDebt --> Out
```

## 10. Step by step — inter-filial transfer {#d-10}

- **Kind**: `sequence`
- **Source page**: [quality/payment/expenses-and-pnl](/docs/quality/payment/expenses-and-pnl)
- **Originating section**: Step by step — inter-filial transfer

```mermaid
sequenceDiagram
    autonumber
    participant S as Sender filial operator
    participant SDB as Sender DB
    participant RDB as Receiver DB
    participant R as Receiver filial operator

    S->>SDB: Create transfer: pick currency, receiving filial,<br/>list of cashbox→summa pairs
    Note over SDB: Per cashbox: balance must be ≥ summa.<br/>Each line writes a Consumption row<br/>(TYPE=0, TRANS_TYPE=4) → cashbox down.
    S->>SDB: PaymentTransfer row inserted with OPERATION_ID=1 (sender side)
    SDB->>RDB: Mirror PaymentTransfer row inserted on receiver filial<br/>with OPERATION_ID=2 and same DOCUMENT_ID
    S-->>R: Notify
    R->>RDB: Receiver opens transfer doc, sees status=2 (pending)
    alt receiver accepts
        R->>RDB: Pick which cashbox(es) to credit, summa per
        RDB->>RDB: Insert Consumption rows TYPE=1, TRANS_TYPE=4 → cashboxes up
        RDB->>SDB: Set sender's status=3 (accepted)
        RDB->>RDB: Set own status=3
        Note over RDB,R: Optional: instead of Consumption,<br/>can save as a ClientTransaction<br/>(trans=1 on the request).
    else receiver rejects
        R->>RDB: Set status=4 with reason
        RDB-->>SDB: Sender also updated to 4
        Note over RDB: Consumption rows deleted on rejection.
    else sender cancels
        S->>SDB: Set status=5
        SDB-->>RDB: Receiver also updated to 5
    end
```

## 11. The big picture {#d-11}

- **Kind**: `flowchart`
- **Source page**: [quality/integrations/index](/docs/quality/integrations/index)
- **Originating section**: The big picture

```mermaid
flowchart LR
    Customer([B2B customer])
    Bot[Telegram WebApp]
    Queue[(Online orders queue)]
    Operator([Operator])
    Orders[(Orders module)]
    POS([iDokon POS terminal])
    Tax[Faktura.uz / Didox]
    ERP[1C / SmartUp X]

    Customer -- catalog, basket --> Bot
    Bot -- submit --> Queue
    Operator -- pick client, accept --> Queue
    Queue -- promote --> Orders
    Orders -- ESF push --> Tax
    Orders -- JSON / XML export --> ERP
    ERP -- import orders --> Orders
    POS -- daily sales --> Orders
    Orders -- recommended order --> POS
```

## 12. How the balance is computed {#d-12}

- **Kind**: `flowchart`
- **Source page**: [quality/finans/cashbox-balance](/docs/quality/finans/cashbox-balance)
- **Originating section**: How the balance is computed

```mermaid
flowchart LR
    Q[SELECT SUMMA<br/>FROM ClientTransaction<br/>WHERE CASHBOX=:id<br/>AND DATE <= :asOf]
    Q --> Sum[Sum per currency]
    Sum --> View[Display per-currency total]
```

## 13. Master view {#d-13}

- **Kind**: `flowchart`
- **Source page**: [quality/finans/index](/docs/quality/finans/index)
- **Originating section**: Master view

```mermaid
flowchart LR
    Orders([Orders module])
    Payment([Payment module])
    F([Finans])
    Settle[(TransactionClosed)]
    CF[(ClientFinans cache)]
    Reports([Reports])

    Orders -- TRANS_TYPE=1 invoice --> F
    Payment -- TRANS_TYPE=3 payment --> F
    F -- close --> Settle
    F -- correct() --> CF
    CF --> Reports
    F --> Reports
```

## 14. How they balance {#d-14}

- **Kind**: `flowchart`
- **Source page**: [quality/finans/transaction-types](/docs/quality/finans/transaction-types)
- **Originating section**: How they balance

```mermaid
flowchart LR
    O([Order saved]) -- writes --> Inv[TRANS_TYPE=1<br/>Invoice<br/>SUMMA negative]
    Cash([Cash collected]) -- writes --> Pay[TRANS_TYPE=3<br/>Payment<br/>SUMMA positive]
    Inv -- settled by --> Pay
    Conv[Currency conversion] -- writes --> C4[TRANS_TYPE=4<br/>Excluded from settle]
    OB([Operator: initial balance]) -- writes --> T6[TRANS_TYPE=6<br/>start position]
    OP([Operator: payout/writeoff]) -- writes --> T78[TRANS_TYPE=7 or 8]
    DC([Order defect correction]) -- writes --> T9[TRANS_TYPE=9]
```

## 15. How balances split per currency {#d-15}

- **Kind**: `flowchart`
- **Source page**: [quality/finans/multi-currency](/docs/quality/finans/multi-currency)
- **Originating section**: How balances split per currency

```mermaid
flowchart LR
    Client((Client X))
    Client --> UZS[(UZS balance)]
    Client --> USD[(USD balance)]
    Client --> EUR[(EUR balance)]
    UZS --> S1[FIFO settlement<br/>over UZS rows only]
    USD --> S2[FIFO settlement<br/>over USD rows only]
    EUR --> S3[FIFO settlement<br/>over EUR rows only]
```

## 16. The algorithm in plain words {#d-16}

- **Kind**: `flowchart`
- **Source page**: [quality/finans/settlement](/docs/quality/finans/settlement)
- **Originating section**: The algorithm in plain words

```mermaid
flowchart TD
    A([New payment saved]) --> B[Load all OPEN invoices for this client + currency<br/>ordered by DATE ASC]
    B --> C[Iterate invoices oldest-first]
    C --> D{Invoice still has open balance?}
    D -- yes --> E{Payment still has unallocated SUMMA?}
    E -- yes --> F[Close min(invoice.open, payment.remaining)]
    F --> G[Insert TransactionClosed row<br/>TR_FROM=payment, TR_TO=invoice, SUMMA=amount]
    G --> H[Update payment.COMPUTATION -= amount<br/>Update invoice.COMPUTATION += amount]
    H --> D
    E -- no --> X([Stop])
    D -- no --> C
```

## 17. How they map onto each other {#d-17}

- **Kind**: `flowchart`
- **Source page**: [quality/team/index](/docs/quality/team/index)
- **Originating section**: How they map onto each other

```mermaid
flowchart TD
    Admin([Admin / Manager / Key-account<br/>web admin])
    KA([Key-account])
    Sup([Supervisor])
    Agent([Field agent])
    Van([Van-selling agent])
    Sel([Seller / point-of-sale])
    Exp([Expeditor])
    Client([Client / outlet])

    Admin -- creates / configures --> Sup
    Admin -- creates / configures --> Agent
    Admin -- creates / configures --> Van
    Admin -- creates / configures --> Sel
    Admin -- creates / configures --> Exp
    Sup -- supervises --> Agent
    Sup -- supervises --> Van
    Agent -- visits + takes orders from --> Client
    Van -- visits + sells direct from van --> Client
    Sel -- works at point-of-sale --> Client
    Exp -- delivers orders to + collects cash from --> Client
    KA -- approves orders, monitors --> Agent

    classDef admin fill:#dbeafe,stroke:#1e40af,color:#000
    classDef field fill:#dcfce7,stroke:#166534,color:#000
    classDef customer fill:#fef3c7,stroke:#92400e,color:#000
    class Admin,KA,Sup admin
    class Agent,Van,Sel,Exp field
    class Client customer
```

## 18. Where the agent connects to other modules {#d-18}

- **Kind**: `flowchart`
- **Source page**: [quality/team/role-agent](/docs/quality/team/role-agent)
- **Originating section**: Where the agent connects to other modules

```mermaid
flowchart LR
    A([Agent on mobile app]) --> V[Visits]
    A --> O[Orders]
    A --> P[Payments — only if cash collection enabled]
    A --> K[KPI]
    A --> B[Bonuses]
    A --> D[Discounts]
    A --> S[Stock — read-only, except van-selling]
    A --> CL[Clients — read, sometimes create/edit]
    V -->|geofence + GPS| GPS[GPS module]
    O -->|writes Order, OrderDetail| ORD[Orders module]
    P -->|writes ClientTransaction| FIN[Finans module]
    K -->|reads Planning + Order data| PL[Planning]
```

## 19. Where the expeditor connects to other modules {#d-19}

- **Kind**: `flowchart`
- **Source page**: [quality/team/role-expeditor](/docs/quality/team/role-expeditor)
- **Originating section**: Where the expeditor connects to other modules

```mermaid
flowchart LR
    E([Expeditor on mobile]) --> O[Orders — status changes]
    E --> P[Payments — cash collection]
    E --> ST[Stock — defect store moves]
    E --> DEF[Defect tracking]
    O -->|status Shipped → Delivered / Returned| ORD[Orders module]
    P -->|writes ClientTransaction TRANS_TYPE=3| FIN[Finans / Payments]
    DEF -->|writes Defect + StoreDetail exchange| STK[Stock]
    classDef field fill:#dcfce7,stroke:#166534,color:#000
    class E field
```

## 20. Where the supervisor connects to other modules {#d-20}

- **Kind**: `flowchart`
- **Source page**: [quality/team/role-supervisor](/docs/quality/team/role-supervisor)
- **Originating section**: Where the supervisor connects to other modules

```mermaid
flowchart LR
    S([Supervisor — web admin]) --> AG[Agents under them]
    S --> K[KPI views]
    S --> R[Reports]
    S --> ROUTE[Routes]
    AG --> O[Orders]
    AG --> V[Visits]
    K --> PL[Planning]
    classDef admin fill:#dbeafe,stroke:#1e40af,color:#000
    class S admin
```

## 21. The big picture — a typical agent workday on the phone {#d-21}

- **Kind**: `sequence`
- **Source page**: [quality/mobile/index](/docs/quality/mobile/index)
- **Originating section**: The big picture — a typical agent workday on the phone

```mermaid
sequenceDiagram
    autonumber
    participant Phone as Agent's phone
    participant API as Server (api3 + api4)
    participant DB as Sales DB
    participant Map as /gps/monitoring (web)

    Phone->>API: 1. POST /login (login, password, deviceId, fcm_token)
    API-->>Phone: token, role, profiles, server time
    Phone->>API: 2. GET /config (packet)
    API-->>Phone: ~100 KB JSON of toggles, plus a sync GPS ping
    Phone->>API: 3. GET clients / clients balances
    API-->>Phone: client list scoped to this agent
    Phone->>API: 4. GET products / prices / warehouses
    API-->>Phone: catalogue scoped to this agent
    Phone->>API: 5. GET visits for today (route)
    API-->>Phone: ordered list of clients to visit

    loop every minute while app is open
        Phone->>API: POST /gps (lat, lon, battery, signal)
        API->>DB: insert GPS row
        API-->>Map: visible in the live map
    end

    loop for each visit during the day
        Phone->>API: check in (visit start) + photos / order / payment
        API->>DB: write visit + order + payment
    end

    Phone->>API: logout (or token expires)
```

## 22. The two-system surface {#d-22}

- **Kind**: `flowchart`
- **Source page**: [quality/markirovka/index](/docs/quality/markirovka/index)
- **Originating section**: The two-system surface

```mermaid
flowchart LR
    SUPP([Supplier]) -- ships goods + ESF --> OP1[(ESF operator<br/>Didox / Faktura)]
    OP1 -- sync incoming --> M[Markirovka module]
    AB[(Aslbelgisi state tracker)] -- CIS validation --> M
    M -- create / sign outgoing ESF --> OP2[(ESF operator<br/>Didox / Faktura)]
    OP2 -- delivers ESF --> CUST([Customer])
    M -- acceptance status --> WH[Warehouse acceptance flow]
```

## 23. The big picture — order lifecycle {#d-23}

- **Kind**: `state`
- **Source page**: [quality/orders/index](/docs/quality/orders/index)
- **Originating section**: The big picture — order lifecycle

```mermaid
stateDiagram-v2
    [*] --> New : Operator or Agent creates the order
    New --> Shipped : Loaded onto the vehicle
    New --> Cancelled : Cancelled before shipment
    Shipped --> Delivered : Handed to client
    Shipped --> New : Pulled back for correction
    Shipped --> Returned : Client refused — full return
    Delivered --> New : Correction (reopens the order)
    Returned --> New : Re-opened for correction
    Cancelled --> New : Re-opened for correction
    Delivered --> [*] : Debt settled — order is done
```

## 24. Master view {#d-24}

- **Kind**: `flowchart`
- **Source page**: [quality/stock/index](/docs/quality/stock/index)
- **Originating section**: Master view

```mermaid
flowchart LR
    Supp([Supplier]) -- Purchase --> S1[(Store A: sale)]
    S1 -- Order sale --> Cust([Customer])
    S1 -- Manual transfer --> S2[(Store B: sale)]
    S1 -- Partial defect --> DEF[(Defect store)]
    S1 -- Van requisition --> VAN[(Van store)]
    VAN -- Van sale --> Cust
    All[All movements] --> Log[(StoreLog audit)]
    style DEF fill:#fee2e2
    style VAN fill:#dcfce7
```

## 25. What happens on the stock side {#d-25}

- **Kind**: `sequence`
- **Source page**: [quality/stock/defect-and-van-stock](/docs/quality/stock/defect-and-van-stock)
- **Originating section**: What happens on the stock side

```mermaid
sequenceDiagram
    autonumber
    participant Triggered as actionPartialDefect / api3 expeditor
    participant SD as StoreDetail
    participant DB as exchange + log

    Triggered->>DB: INSERT exchange (TYPE=3 delivery, OPERATION=-1 decrease)
    loop each defective product
        Triggered->>SD: update_count(-qty, source_store, product, 'Exchange', exchange_id)
        Triggered->>SD: update_count(+qty, defect_store, product, 'Exchange', exchange_id)
        Triggered->>DB: INSERT exchange_detail (product, qty)
    end
```

## 26. Where stock goes {#d-26}

- **Kind**: `flowchart`
- **Source page**: [quality/stock/defect-and-van-stock](/docs/quality/stock/defect-and-van-stock)
- **Originating section**: Where stock goes

```mermaid
flowchart LR
    Main[(Main warehouse)] -- "Exchange TYPE=2<br/>(van requisition)" --> Van[(Van store)]
    Van -- "Order (van sale)" --> Customer
    Customer -- Return --> Van
```

