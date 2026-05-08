---
sidebar_position: 2
title: "sd-billing"
audience: All team members
summary: "Subscription billing — licensing, payments (Click/Payme/Paynet/MBANK), distributor settlement, dunning."
topics: [diagrams, sd, billing]
---

# sd-billing — diagram gallery

Subscription billing — licensing, payments (Click/Payme/Paynet/MBANK), distributor settlement, dunning.

All 12 diagrams in this group, drawn inline.

## Index

| # | Title | Kind | Source page |
|---|-------|------|-------------|
| 01 | [5. Queue drain — `cron.php notify`](#d-01) | `sequence` | [sd-billing/notifications](/docs/sd-billing/notifications) |
| 02 | [Architecture diagram](#d-02) | `flowchart` | [sd-billing/overview](/docs/sd-billing/overview) |
| 03 | [Integration with sd-main & sd-cs](#d-03) | `sequence` | [sd-billing/integration](/docs/sd-billing/integration) |
| 04 | [sd-billing domain model](#d-04) | `er` | [sd-billing/domain-model](/docs/sd-billing/domain-model) |
| 05 | [Sequence](#d-05) | `sequence` | [sd-billing/balance-and-money-math](/docs/sd-billing/balance-and-money-math) |
| 06 | [After balance changes — license refresh](#d-06) | `flowchart` | [sd-billing/balance-and-money-math](/docs/sd-billing/balance-and-money-math) |
| 07 | [Subscription & licensing](#d-07) | `flowchart` | [sd-billing/subscription-flow](/docs/sd-billing/subscription-flow) |
| 08 | [ERD (shape view)](#d-08) | `er` | [sd-billing/data-scheme](/docs/sd-billing/data-scheme) |
| 09 | [Settlement](#d-09) | `flowchart` | [sd-billing/cron-and-settlement](/docs/sd-billing/cron-and-settlement) |
| 10 | [Notifications cron](#d-10) | `sequence` | [sd-billing/cron-and-settlement](/docs/sd-billing/cron-and-settlement) |
| 11 | [Click flow (canonical)](#d-11) | `sequence` | [sd-billing/payment-gateways](/docs/sd-billing/payment-gateways) |
| 12 | [Payme flow](#d-12) | `sequence` | [sd-billing/payment-gateways](/docs/sd-billing/payment-gateways) |

## 01. 5. Queue drain — `cron.php notify` {#d-01}

- **Kind**: `sequence`
- **Source page**: [sd-billing/notifications](/docs/sd-billing/notifications)
- **Originating section**: 5. Queue drain — `cron.php notify`

```mermaid
sequenceDiagram
  autonumber
  participant CR as cron.php notify
  participant DB as d0_notify_cron
  participant TG as Telegram proxy<br/>10.0.0.2:3000
  participant SD as sd-main host

  CR->>DB: SELECT * WHERE status=0
  loop per row
    alt type = telegram
      CR->>CR: resolveApiUrl(model)<br/>(bot.api_url or default)
      CR->>TG: POST /addRequest<br/>{method:sendMessage, chat_id, text, parse_mode, url, host}
      alt 200 ok=true
        CR->>DB: status=1
      else 5xx / network error
        CR->>DB: stay status=0 (retry next tick)
      else 200 ok=false (e.g. chat not found)
        CR->>DB: status=1 (treat as delivered to break loop)
      end
    else type = license_delete
      CR->>SD: GET row.text  (the dealer's /api/billing/license URL)
      alt JSON {status:true}
        CR->>DB: status=1
      else any other response
        CR->>DB: stay status=0 (retry)
      end
    else type = visit_write
      CR->>SD: GET row.text  (/api/cronVisit/write)
      Note over CR,SD: same success criterion as license_delete
    end
  end
```

## 02. Architecture diagram {#d-02}

- **Kind**: `flowchart`
- **Source page**: [sd-billing/overview](/docs/sd-billing/overview)
- **Originating section**: Architecture diagram

```mermaid
flowchart LR
  subgraph Inbound["Money & data in"]
    PG[("Payment gateways<br/>Click · Payme · Paynet · MBANK · P2P")]
    EXT[("1C / external imports")]
    PORTAL["Partner portal · admin UI"]
  end
  subgraph Bill["sd-billing (Yii 1.x)"]
    API["api module"]
    OP["operation module"]
    DASH["dashboard"]
    PART["partner"]
    CR["cron commands<br/>(notify, settlement, stat, cleaner, …)"]
    NOT["notification + sms"]
  end
  subgraph Out["Outbound"]
    TG[("Telegram (bot proxy 10.0.0.2:3000)")]
    SMS[("SMS gateway (Eskiz / Mobizon)")]
    LIC["License files → sd-main"]
    STAT["Status pings → sd-cs"]
  end
  subgraph DB["MySQL 8 (d0_*)"]
    direction TB
  end
  PG --> API
  EXT --> API
  PORTAL --> DASH
  PORTAL --> OP
  PORTAL --> PART
  API --> DB
  OP --> DB
  DASH --> DB
  PART --> DB
  CR --> DB
  CR --> NOT
  NOT --> TG
  NOT --> SMS
  CR --> LIC
  API --> LIC
  CR --> STAT

  class PG,EXT,TG,SMS external
  class PORTAL,API,OP,DASH,PART,CR,NOT,LIC,STAT action
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000

  style Inbound fill:#ffffff,stroke:#cccccc
  style Bill fill:#ffffff,stroke:#cccccc
  style Out fill:#ffffff,stroke:#cccccc
  style DB fill:#ffffff,stroke:#cccccc
```

## 03. Integration with sd-main & sd-cs {#d-03}

- **Kind**: `sequence`
- **Source page**: [sd-billing/integration](/docs/sd-billing/integration)
- **Originating section**: Integration with sd-main & sd-cs

```mermaid
sequenceDiagram
  participant B as sd-billing
  participant M as sd-main (dealer)
  participant C as sd-cs (HQ)

  Note over B,M: Subscription purchase
  M->>B: api/license/buyPackages (UserIdentity sd/sd)
  B->>B: validate, charge BALANS, insert Subscription
  B-->>M: 200 + new licence file payload
  M->>M: write protected/license2/<licence>
  Note over B,C: Periodic status pings
  B->>C: api/billing/status?app=sdmanager
  C-->>B: { status:success, url, code }
  Note over B,M: Phone directory sync
  B->>M: api/billing/phone (sync)
  M->>M: User.TEL updates from Spravochnik
  Note over B,M: Licence expiry
  B->>M: api/billing/license (DELETE)
  M->>M: clear protected/license2/*
```

## 04. sd-billing domain model {#d-04}

- **Kind**: `er`
- **Source page**: [sd-billing/domain-model](/docs/sd-billing/domain-model)
- **Originating section**: sd-billing domain model

```mermaid
erDiagram
  DISTRIBUTOR ||--o{ DILER : owns
  DILER ||--o{ SUBSCRIPTION : has
  DILER ||--o{ PAYMENT : pays
  DILER ||--|| SERVER : runs
  DILER ||--o| DILER_BONUS : has
  PACKAGE ||--o{ SUBSCRIPTION : referenced_by
  TARIFF ||--o{ TARIFF_PACKAGE : bundles
  PACKAGE ||--o{ TARIFF_PACKAGE : in
  PAYMENT }o--|| CASHBOX : posted_to
  PAYMENT }o--o| CLICK_TRANSACTION : via
  PAYMENT }o--o| PAYME_TRANSACTION : via
  PAYMENT }o--o| PAYNET_TRANSACTION : via
  USER }o--|| ROLE : assigned

  DISTRIBUTOR {
    string ID PK
    string NAME
    float BALANS
  }
  DILER {
    int DILER_ID PK
    string NAME
    string HOST
    int STATUS
    float BALANS
    float MIN_SUMMA
    float MIN_LICENSE
    float CREDIT_LIMIT
    date CREDIT_DATE
    date FREE_TO
    int MONTHLY
    bool IS_DEMO
  }
  SUBSCRIPTION {
    string ID PK
    int DILER_ID FK
    int PACKAGE_ID FK
    date START_FROM
    date ACTIVE_TO
    bool IS_DELETED
  }
  PACKAGE {
    int PACKAGE_ID PK
    string NAME
    string SUBSCRIP_TYPE
    int TYPE
    string PACKAGE_TYPE
    string CLIENT_TYPE
    float PRICE
  }
  TARIFF {
    int ID PK
    string NAME
  }
  TARIFF_PACKAGE {
    int ID PK
    int TARIFF_ID FK
    int PACKAGE_ID FK
  }
  PAYMENT {
    string ID PK
    int DILER_ID FK
    string TYPE
    float SUMMA
    datetime DATE
    int CASHBOX_ID FK
  }
  CASHBOX {
    int ID PK
    string NAME
    string CURRENCY
  }
  CLICK_TRANSACTION {
    string ID PK
    int PAYMENT_ID FK
    string SIGN
    string STATE
  }
  PAYME_TRANSACTION {
    string ID PK
    int PAYMENT_ID FK
    string STATE
  }
  PAYNET_TRANSACTION {
    string ID PK
    int PAYMENT_ID FK
    string STATE
  }
  SERVER {
    int ID PK
    int DILER_ID FK
    string HOST
    string DB_HOST
    string DB_USER
    string DB_PASS
    string STATUS
  }
  DILER_BONUS {
    int DILER_ID PK
    float QUOTA
  }
  USER {
    int USER_ID PK
    string LOGIN
    int ROLE
    bool IS_ADMIN
  }
  ROLE {
    int ID PK
    string NAME
  }
```

## 05. Sequence {#d-05}

- **Kind**: `sequence`
- **Source page**: [sd-billing/balance-and-money-math](/docs/sd-billing/balance-and-money-math)
- **Originating section**: Sequence

```mermaid
sequenceDiagram
  autonumber
  participant Caller as Caller (UI / gateway / cron)
  participant Pay as Payment::create()
  participant Diler as Diler::changeBalans()
  participant LB as LogBalans
  participant DB as d0_payment / d0_diler

  Caller->>Pay: Payment::create([DILER_ID, AMOUNT, TYPE, ...])
  Pay->>DB: INSERT d0_payment
  Pay->>Pay: afterSave()<br/>diler->resetActiveLicense()
  Pay->>Diler: changeBalans(AMOUNT + DISCOUNT)
  Diler->>Diler: $this->BALANS += $amount
  Diler->>Diler: moveCreditDate()  (if BALANS ≥ 0)
  Diler->>DB: UPDATE d0_diler SET BALANS=…, CREDIT_DATE=…
  Diler->>LB: INSERT d0_log_balans (DILER_ID, SUMMA)
  Diler->>DB: UPDATE d0_diler SET BALANS = (<br/>  SELECT SUM(AMOUNT+DISCOUNT) FROM d0_payment<br/>  WHERE IS_DELETED=0 AND DILER_ID=:id)
  Note over Diler,DB: ☝ updateBalance() — authoritative recompute,<br/>safe under concurrent writes
```

## 06. After balance changes — license refresh {#d-06}

- **Kind**: `flowchart`
- **Source page**: [sd-billing/balance-and-money-math](/docs/sd-billing/balance-and-money-math)
- **Originating section**: After balance changes — license refresh

```mermaid
flowchart LR
  PAY["Payment created<br/>(or edited / deleted)"] --> AS["Payment::afterSave"]
  AS --> CB["Diler::changeBalans()"]
  CB --> UB["Diler::updateBalance()<br/>SUM recompute"]
  CB --> RAL["Diler::resetActiveLicense()<br/>(ACTIVE_TO of latest sub)"]
  AS --> DEL["Diler::deleteLicense()<br/>(in some flows)"]
  DEL --> NQ["NotifyCron::createLicenseDelete<br/>(queues HTTP push)"]
  NQ --> CR["cron.php notify (1m)"]
  CR --> SDM["POST /api/billing/license<br/>on dealer's sd-main"]
  SDM --> RM["unlink protected/license2/*"]

  classDef action fill:#dbeafe,stroke:#1e40af,color:#000
  classDef cron   fill:#ede9fe,stroke:#6d28d9,color:#000
  class PAY,AS,CB,UB,RAL,DEL,NQ,SDM,RM action
  class CR cron
```

## 07. Subscription & licensing {#d-07}

- **Kind**: `flowchart`
- **Source page**: [sd-billing/subscription-flow](/docs/sd-billing/subscription-flow)
- **Originating section**: Subscription & licensing

```mermaid
flowchart LR
  S(["Dealer signs up"]) --> P["Pay (online or offline)"]
  P --> B["Diler.BALANS += summa"]
  B --> BUY["api/license/buyPackages"]
  BUY --> CHK{"Validation passes?"}
  CHK -- "no" --> ERR(["Reject"])
  CHK -- "yes" --> SUB["Subscription rows<br/>[START_FROM, ACTIVE_TO]"]
  SUB --> NEG["Payment TYPE=license (negative)"]
  NEG --> SET["Diler.refresh() — recompute BALANS, FREE_TO, MONTHLY"]
  SET --> SRV["Diler.HOST → Server.STATUS=SENT → OPENED"]
  SRV --> NOTIF(["Telegram + SMS to dealer"])

  class S action
  class P,B,BUY,SUB,NEG,SET,SRV action
  class CHK approval
  class ERR reject
  class NOTIF success
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
```

## 08. ERD (shape view) {#d-08}

- **Kind**: `er`
- **Source page**: [sd-billing/data-scheme](/docs/sd-billing/data-scheme)
- **Originating section**: ERD (shape view)

```mermaid
erDiagram
  DILER ||--o{ SUBSCRIPTION : has
  DILER ||--o{ PAYMENT : pays
  DILER ||--|| SERVER : runs
  DILER ||--o| DILER_BONUS : has
  DISTRIBUTOR ||--o{ DILER : owns
  PACKAGE ||--o{ SUBSCRIPTION : referenced_by
  TARIFF ||--o{ TARIFF_PACKAGE : bundles
  PACKAGE ||--o{ TARIFF_PACKAGE : in
  PAYMENT }o--|| CASHBOX : posted_to
  PAYMENT }o--o| CLICK_TRANSACTION : via
  PAYMENT }o--o| PAYME_TRANSACTION : via
  PAYMENT }o--o| PAYNET_TRANSACTION : via
  DILER ||--o{ LOG_BALANS : journals
  NOTIFY_CRON }o--|| NOTIFY_BOT : routes_through
```

## 09. Settlement {#d-09}

- **Kind**: `flowchart`
- **Source page**: [sd-billing/cron-and-settlement](/docs/sd-billing/cron-and-settlement)
- **Originating section**: Settlement

```mermaid
flowchart LR
  S(["01:00 cron"]) --> READ["Pull last-month payments grouped by Distributor + Diler"]
  READ --> CALC["Compute share % per agreement"]
  CALC --> DEB["Insert Payment TYPE=distribute (debit Distributor)"]
  DEB --> CRE["Insert Payment TYPE=distribute (credit Diler)"]
  CRE --> LOG["LogDistrBalans rolling balance row"]
  LOG --> NOTIF[("Telegram summary to ops")]

  class S cron
  class READ,CALC,DEB,CRE,LOG action
  class NOTIF external
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
```

## 10. Notifications cron {#d-10}

- **Kind**: `sequence`
- **Source page**: [sd-billing/cron-and-settlement](/docs/sd-billing/cron-and-settlement)
- **Originating section**: Notifications cron

```mermaid
sequenceDiagram
  participant CR as cron notify
  participant DB as MySQL
  participant TG as Telegram bot proxy (10.0.0.2:3000)
  participant SD as sd-main

  loop every minute
    CR->>DB: SELECT * FROM d0_notify_cron WHERE sent=0 LIMIT 100
    Note over CR,DB: Branch is keyed by row type column on d0_notify_cron
    alt Telegram
      CR->>DB: lookup d0_notify_bot
      CR->>TG: POST /addRequest
      TG-->>CR: ok
      CR->>DB: mark sent
    else License delete
      CR->>SD: api/license/delete (HTTP)
      SD-->>CR: ok
      CR->>DB: mark sent
    end
  end
```

## 11. Click flow (canonical) {#d-11}

- **Kind**: `sequence`
- **Source page**: [sd-billing/payment-gateways](/docs/sd-billing/payment-gateways)
- **Originating section**: Click flow (canonical)

```mermaid
sequenceDiagram
  participant U as User
  participant C as Click
  participant API as api/click
  participant DB as MySQL
  participant D as Diler
  U->>C: pay
  C->>API: prepare (sign)
  API->>API: ClickTransaction::checkSign
  API->>DB: insert ClickTransaction (state=prepared)
  Note over API: Duplicate prepare/confirm requests return the same response (idempotent)
  API-->>C: 200
  C->>API: confirm (sign)
  API->>DB: ClickTransaction state=confirmed
  API->>DB: insert Payment TYPE=clickonline
  API->>D: Payment::afterSave → Diler::changeBalans (PHP)<br/>then updateBalance() SUM recompute
  API->>D: deleteLicense() + refresh()
  API-->>C: 200
```

## 12. Payme flow {#d-12}

- **Kind**: `sequence`
- **Source page**: [sd-billing/payment-gateways](/docs/sd-billing/payment-gateways)
- **Originating section**: Payme flow

```mermaid
sequenceDiagram
  participant Pa as Payme
  participant API as api/payme
  participant DB as MySQL
  Pa->>API: CheckPerformTransaction
  API->>DB: validate dealer + amount
  API-->>Pa: result
  Pa->>API: CreateTransaction
  API->>DB: PaymeTransaction (created)
  Pa->>API: PerformTransaction
  API->>DB: PaymeTransaction (performed) + Payment TYPE=payme
  API-->>Pa: result
```

