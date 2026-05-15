---
sidebar_position: 2
title: "sd-billing"
audience: All team members
summary: "Subscription billing — licensing, payments (Click/Payme/Paynet/MBANK), distributor settlement, dunning."
topics: [diagrams, sd, billing]
---

# sd-billing — diagram gallery

Subscription billing — licensing, payments (Click/Payme/Paynet/MBANK), distributor settlement, dunning.

All 33 diagrams in this group, drawn inline.

## Index

| # | Title | Kind | Source page |
|---|-------|------|-------------|
| 01 | [5. Queue drain — `cron.php notify`](#d-01) | `sequence` | [sd-billing/notifications](/docs/sd-billing/notifications) |
| 02 | [10b. Phone directory sync](#d-02) | `flowchart` | [sd-billing/notifications](/docs/sd-billing/notifications) |
| 03 | [Architecture diagram](#d-03) | `flowchart` | [sd-billing/overview](/docs/sd-billing/overview) |
| 04 | [Integration with sd-main & sd-cs](#d-04) | `sequence` | [sd-billing/integration](/docs/sd-billing/integration) |
| 05 | [SMS package buy](#d-05) | `sequence` | [sd-billing/integration](/docs/sd-billing/integration) |
| 06 | [SMS send + forward](#d-06) | `sequence` | [sd-billing/integration](/docs/sd-billing/integration) |
| 07 | [SMS delivery callback](#d-07) | `sequence` | [sd-billing/integration](/docs/sd-billing/integration) |
| 08 | [sd-billing domain model](#d-08) | `er` | [sd-billing/domain-model](/docs/sd-billing/domain-model) |
| 09 | [Sequence](#d-09) | `sequence` | [sd-billing/balance-and-money-math](/docs/sd-billing/balance-and-money-math) |
| 10 | [After balance changes — license refresh](#d-10) | `flowchart` | [sd-billing/balance-and-money-math](/docs/sd-billing/balance-and-money-math) |
| 11 | [Subscription & licensing](#d-11) | `flowchart` | [sd-billing/subscription-flow](/docs/sd-billing/subscription-flow) |
| 12 | [Buy packages — round-trip sequence](#d-12) | `sequence` | [sd-billing/subscription-flow](/docs/sd-billing/subscription-flow) |
| 13 | [License renewal + expiry notify (flowchart)](#d-13) | `flowchart` | [sd-billing/subscription-flow](/docs/sd-billing/subscription-flow) |
| 14 | [ERD (shape view)](#d-14) | `er` | [sd-billing/data-scheme](/docs/sd-billing/data-scheme) |
| 15 | [Settlement](#d-15) | `flowchart` | [sd-billing/cron-and-settlement](/docs/sd-billing/cron-and-settlement) |
| 16 | [Notifications cron](#d-16) | `sequence` | [sd-billing/cron-and-settlement](/docs/sd-billing/cron-and-settlement) |
| 17 | [botLicenseReminder cron (sequence)](#d-17) | `sequence` | [sd-billing/cron-and-settlement](/docs/sd-billing/cron-and-settlement) |
| 18 | [Operation: manual payment entry](#d-18) | `flowchart` | [sd-billing/cron-and-settlement](/docs/sd-billing/cron-and-settlement) |
| 19 | [Cashbox transfer](#d-19) | `flowchart` | [sd-billing/cron-and-settlement](/docs/sd-billing/cron-and-settlement) |
| 20 | [Click flow (canonical)](#d-20) | `sequence` | [sd-billing/payment-gateways](/docs/sd-billing/payment-gateways) |
| 21 | [Payme flow](#d-21) | `sequence` | [sd-billing/payment-gateways](/docs/sd-billing/payment-gateways) |
| 22 | [Paynet flow](#d-22) | `sequence` | [sd-billing/payment-gateways](/docs/sd-billing/payment-gateways) |
| 23 | [Distributor payment create/update](#d-23) | `flowchart` | [sd-billing/payment-gateways](/docs/sd-billing/payment-gateways) |
| 24 | [Manual payment entry (dashboard variant)](#d-24) | `flowchart` | [sd-billing/payment-gateways](/docs/sd-billing/payment-gateways) |
| 25 | [Write-server (push licence file)](#d-25) | `sequence` | [sd-billing/payment-gateways](/docs/sd-billing/payment-gateways) |
| 26 | [License delete (revoke a subscription)](#d-26) | `sequence` | [sd-billing/api-reference](/docs/sd-billing/api-reference) |
| 27 | [License pay (manual fallback)](#d-27) | `flowchart` | [sd-billing/api-reference](/docs/sd-billing/api-reference) |
| 28 | [License batch buy (read-side variant)](#d-28) | `flowchart` | [sd-billing/api-reference](/docs/sd-billing/api-reference) |
| 29 | [Host status report](#d-29) | `sequence` | [sd-billing/api-reference](/docs/sd-billing/api-reference) |
| 30 | [App auth (sd-main → sd-billing)](#d-30) | `sequence` | [sd-billing/api-reference](/docs/sd-billing/api-reference) |
| 31 | [Workflow](#d-31) | `sequence` | [sd-billing/workflows/api-click](/docs/sd-billing/workflows/api-click) |
| 32 | [4a. Listing payments](#d-32) | `sequence` | [sd-billing/workflows/operation-payment](/docs/sd-billing/workflows/operation-payment) |
| 33 | [4. Workflow](#d-33) | `state` | [sd-billing/workflows/operation-subscription](/docs/sd-billing/workflows/operation-subscription) |

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

## 02. 10b. Phone directory sync {#d-02}

- **Kind**: `flowchart`
- **Source page**: [sd-billing/notifications](/docs/sd-billing/notifications)
- **Originating section**: 10b. Phone directory sync

```mermaid
flowchart LR
  S(["sd-billing<br/>updates Spravochnik / Diler.PHONE"]) --> ENQ["NotifyCron<br/>(or direct cron call)"]
  ENQ --> CR(["cron drains row"])
  CR --> SM["POST {Diler.DOMAIN}/api/billing/phone"]
  SM --> RG["sd-main: Report::getSpravochnik()"]
  RG --> WR["UPDATE User.TEL<br/>for agents/expeditors/partners"]
  WR --> OK(["next SMS run hits<br/>correct numbers"])

  class S,ENQ,SM,RG,WR action
  class CR cron
  class OK success
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
```

## 03. Architecture diagram {#d-03}

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

## 04. Integration with sd-main & sd-cs {#d-04}

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

## 05. SMS package buy {#d-05}

- **Kind**: `sequence`
- **Source page**: [sd-billing/integration](/docs/sd-billing/integration)
- **Originating section**: SMS package buy

```mermaid
sequenceDiagram
  participant SM as sd-main (dealer)
  participant API as api/sms/buySmsPackage
  participant DB as MySQL
  participant D as Diler

  SM->>API: POST {package_id, host, sd_id, sd_login, type=dealer}
  API->>DB: SmsPackage active?
  API->>D: Diler by id or HOST
  API->>API: BALANS >= PRICE?
  alt insufficient
    API-->>SM: not_enough_balance
  else ok
    API->>DB: INSERT SmsBoughtPackage
    API->>DB: INSERT Service (TYPE_DILER, DONE)
    API->>DB: INSERT BoughtPackage (joins)
    API->>D: deleteLicense()
    API-->>SM: success [{id, name, count, ...}]
  end
```

## 06. SMS send + forward {#d-06}

- **Kind**: `sequence`
- **Source page**: [sd-billing/integration](/docs/sd-billing/integration)
- **Originating section**: SMS send + forward

```mermaid
sequenceDiagram
  participant SM as sd-main
  participant API as api/sms
  participant DB as MySQL
  participant SMS as Sms component<br/>(Eskiz/Mobizon)

  SM->>API: POST /send {type, object_id, host, messages}
  API->>API: hasAccessIpAddress() check
  API->>DB: load SmsBoughtPackage rows (USED_LIMIT != SMS_LIMIT)
  API->>API: maxSmsLimit ≥ countSMS?
  alt over limit
    API-->>SM: fail "недостаточно SMS"
  else ok
    API->>SMS: Sms::multy(messages, host)
    SMS-->>API: status, response
    API-->>SM: success {left_sms_limit, status}
  end
  Note over API: actionSendingForward skips<br/>limit math and calls multy() directly
```

## 07. SMS delivery callback {#d-07}

- **Kind**: `sequence`
- **Source page**: [sd-billing/integration](/docs/sd-billing/integration)
- **Originating section**: SMS delivery callback

```mermaid
sequenceDiagram
  participant P as Provider (Eskiz/Mobizon)
  participant API as api/sms/callback
  participant DB as MySQL
  participant SM as sd-main /sms/callback/item

  P->>API: POST DLR {host, status, sms_count, ...}
  API->>API: Logger::writeLog (sms-callback-all.json)
  API->>DB: find Diler by HOST
  alt status == DELIVERED
    API->>DB: load active SmsBoughtPackage rows
    loop pack sms_count
      API->>DB: USED_LIMIT += min(left, smsCount)
    end
  end
  alt status in (DELIVERED, REJECTED)
    API->>SM: POST {host, status, ...}
    SM-->>API: 2xx
  end
```

## 08. sd-billing domain model {#d-08}

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

## 09. Sequence {#d-09}

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

## 10. After balance changes — license refresh {#d-10}

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

## 11. Subscription & licensing {#d-11}

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

## 12. Buy packages — round-trip sequence {#d-12}

- **Kind**: `sequence`
- **Source page**: [sd-billing/subscription-flow](/docs/sd-billing/subscription-flow)
- **Originating section**: Buy packages — round-trip sequence

```mermaid
sequenceDiagram
  participant SM as sd-main (dealer)
  participant API as sd-billing<br/>api/license/buyPackages
  participant DB as MySQL
  participant D as Diler

  SM->>API: POST {token, host, packages[], start_date, month_count}
  API->>API: UserIdentity("sd","sd") authenticate
  API->>DB: validate package, currency, day-of-month
  loop each month × each package
    API->>DB: INSERT Subscription (START_FROM, ACTIVE_TO)
    API->>DB: INSERT Payment TYPE=license (-amount)
  end
  API->>D: writeVisit() + deleteLicenseImmediately()
  API-->>SM: 200 {success, diler_id}
```

## 13. License renewal + expiry notify (flowchart) {#d-13}

- **Kind**: `flowchart`
- **Source page**: [sd-billing/subscription-flow](/docs/sd-billing/subscription-flow)
- **Originating section**: License renewal + expiry notify (flowchart)

```mermaid
flowchart LR
  CR(["09:00 cron<br/>botLicenseReminder"]) --> Q["SELECT Diler<br/>NOT EXISTS active bot_report Subscription"]
  Q --> EMP{"rows?"}
  EMP -- "no" --> DONE(["log + end"])
  EMP -- "yes" --> LOOP["per dealer: build URL<br/>{DOMAIN}/api/billing/telegramLicense"]
  LOOP --> SENT{"stamp file<br/>exists today?"}
  SENT -- "yes" --> SKIP(["skip"])
  SENT -- "no" --> POST["curl POST"]
  POST --> CODE{"http_code == 200?"}
  CODE -- "no, try≤3" --> POST
  CODE -- "no, try>3" --> ERR(["write error log"])
  CODE -- "yes" --> OK(["write success stamp"])

  class CR cron
  class Q,LOOP,POST action
  class EMP,SENT,CODE approval
  class ERR reject
  class OK,DONE,SKIP success
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
```

## 14. ERD (shape view) {#d-14}

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

## 15. Settlement {#d-15}

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

## 16. Notifications cron {#d-16}

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

## 17. botLicenseReminder cron (sequence) {#d-17}

- **Kind**: `sequence`
- **Source page**: [sd-billing/cron-and-settlement](/docs/sd-billing/cron-and-settlement)
- **Originating section**: botLicenseReminder cron (sequence)

```mermaid
sequenceDiagram
  participant CR as 09:00 cron<br/>botLicenseReminder
  participant DB as MySQL (d0_*)
  participant LOG as upload/bot-report-reminder
  participant SM as sd-main<br/>/api/billing/telegramLicense

  CR->>DB: SELECT Diler WHERE no active<br/>bot_report Subscription
  DB-->>CR: rows[]
  loop per dealer
    CR->>LOG: check stamp file for today
    alt new today
      CR->>SM: curl POST telegramLicense
      alt 200 OK
        SM-->>CR: ok
        CR->>LOG: write success stamp
      else fail (try ≤ 3)
        CR->>SM: retry
      else fail (try > 3)
        CR->>LOG: append error log
      end
    end
  end
```

## 18. Operation: manual payment entry {#d-18}

- **Kind**: `flowchart`
- **Source page**: [sd-billing/cron-and-settlement](/docs/sd-billing/cron-and-settlement)
- **Originating section**: Operation: manual payment entry

```mermaid
flowchart LR
  S(["Operator submits<br/>Payment row"]) --> A["actionCreateOrUpdate"]
  A --> CB{"Operator has cashbox?"}
  CB -- "no" --> R1(["error: no cashbox"])
  CB -- "yes" --> DLR{"Diler/Currency/Cashbox<br/>found?"}
  DLR -- "no" --> R2(["error: not found"])
  DLR -- "yes" --> CUR{"Diler.CURRENCY_ID<br/>matches?"}
  CUR -- "no" --> R3(["error: валюта"])
  CUR -- "yes" --> AC{"Access::check<br/>operation.dealer.payment"}
  AC -- "deny" --> R4(["403"])
  AC -- "allow" --> TX["BEGIN; Payment->save();<br/>COMMIT"]
  TX --> DL["Diler::deleteLicense()"]
  DL --> OK(["success"])

  class S,A,TX,DL action
  class CB,DLR,CUR,AC approval
  class R1,R2,R3,R4 reject
  class OK success
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
```

## 19. Cashbox transfer {#d-19}

- **Kind**: `flowchart`
- **Source page**: [sd-billing/cron-and-settlement](/docs/sd-billing/cron-and-settlement)
- **Originating section**: Cashbox transfer

```mermaid
flowchart LR
  S(["Operator submits<br/>Transfer form"]) --> FT{"FlowType +<br/>ComingType 'transfer'<br/>exist?"}
  FT -- "no" --> R1(["redirect: error flash"])
  FT -- "yes" --> SAVE["Transfer->save()"]
  SAVE --> OUT["Consumption OUTCOME<br/>(FROM_CASHBOX, -AMOUNT)"]
  OUT --> IN["Consumption INCOME<br/>(TO_CASHBOX, +AMOUNT)"]
  IN --> EQ{"isUZB()?"}
  EQ -- "yes" --> E1["EQUIVALENT = AMOUNT"]
  EQ -- "no" --> E2["EQUIVALENT = AMOUNT × CURRENCY"]
  E1 --> LINK["Transfer.FROM_COMP_ID,<br/>TO_COMP_ID set"]
  E2 --> LINK
  LINK --> OK(["success flash"])

  class S,SAVE,OUT,IN,E1,E2,LINK action
  class FT,EQ approval
  class R1 reject
  class OK success
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
```

## 20. Click flow (canonical) {#d-20}

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
  API->>D: Diler.BALANS += summa (DB trigger)
  API->>D: deleteLicense() + refresh()
  API-->>C: 200
```

## 21. Payme flow {#d-21}

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

## 22. Paynet flow {#d-22}

- **Kind**: `sequence`
- **Source page**: [sd-billing/payment-gateways](/docs/sd-billing/payment-gateways)
- **Originating section**: Paynet flow

```mermaid
sequenceDiagram
  participant PN as Paynet gateway
  participant API as api/paynet (actionIndex)
  participant SVC as PaynetService<br/>(paynetuz extension)
  participant DB as MySQL
  participant D as Diler

  PN->>API: SOAP POST (XML)
  API->>API: UserIdentity("paynet","paynet")<br/>authenticate
  API->>SVC: SoapServer dispatch
  SVC->>DB: insert/update PaynetTransaction
  SVC->>DB: insert Payment TYPE=paynetonline
  SVC->>D: BALANS += summa (trigger)
  SVC->>D: Diler::deleteLicense() + refresh()
  SVC-->>API: SOAP result
  API-->>PN: 200 text/xml
```

## 23. Distributor payment create/update {#d-23}

- **Kind**: `flowchart`
- **Source page**: [sd-billing/payment-gateways](/docs/sd-billing/payment-gateways)
- **Originating section**: Distributor payment create/update

```mermaid
flowchart LR
  S(["Operator submits<br/>DistrPayment form"]) --> A["actionCreateAjax /<br/>actionUpdateAjax"]
  A --> AC{"Access::check<br/>operation.distr.payment"}
  AC -- "deny" --> R1(["403"])
  AC -- "allow" --> CB{"User has cashbox?"}
  CB -- "none" --> R2(["error: no cashbox"])
  CB -- "ok" --> CUR{"Distr.CURRENCY_ID<br/>== posted CURRENCY_ID?"}
  CUR -- "no" --> R3(["error: валюта неверно"])
  CUR -- "yes" --> SAVE["DistrPayment->save()<br/>(CASHBOX_ID auto-set)"]
  SAVE --> OK(["success"])

  class S,A,SAVE action
  class AC,CB,CUR approval
  class R1,R2,R3 reject
  class OK success
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
```

## 24. Manual payment entry (dashboard variant) {#d-24}

- **Kind**: `flowchart`
- **Source page**: [sd-billing/payment-gateways](/docs/sd-billing/payment-gateways)
- **Originating section**: Manual payment entry (dashboard variant)

```mermaid
flowchart LR
  S(["Operator submits<br/>Dealer payment"]) --> A["actionCreateAjax /<br/>actionUpdateAjax"]
  A --> AC{"Access::check<br/>operation.dealer.payment"}
  AC -- "deny" --> R1(["403"])
  AC -- "allow" --> CB{"User has cashbox?"}
  CB -- "none" --> R2(["error: no cashbox"])
  CB -- "ok" --> CUR{"Diler.CURRENCY_ID<br/>== posted CURRENCY_ID?"}
  CUR -- "no" --> R3(["error: валюта неверно"])
  CUR -- "yes" --> SAVE["Payment->save()<br/>(CASHBOX_ID auto-set)"]
  SAVE --> DL["Diler::deleteLicense()<br/>→ NotifyCron license_delete"]
  DL --> OK(["success"])

  class S,A,SAVE,DL action
  class AC,CB,CUR approval
  class R1,R2,R3 reject
  class OK success
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
```

## 25. Write-server (push licence file) {#d-25}

- **Kind**: `sequence`
- **Source page**: [sd-billing/payment-gateways](/docs/sd-billing/payment-gateways)
- **Originating section**: Write-server (push licence file)

```mermaid
sequenceDiagram
  participant Adm as Admin
  participant FX as FixController
  participant DLR as Diler (paged 10)
  participant SD as sd-main /api/billing/checkBranch
  participant SRV as Server row

  Adm->>FX: GET writeServer?offset&limit
  loop each Diler in page
    FX->>SD: POST /api/billing/checkBranch
    SD-->>FX: {db_server, web_branch}
    FX->>SRV: save(db_server, web_server, web_branch)
  end
  Adm->>FX: GET checkStatusServer
  FX->>SRV: status = OPENED (or DELETED)<br/>per dealer.isDeleted()
```

## 26. License delete (revoke a subscription) {#d-26}

- **Kind**: `sequence`
- **Source page**: [sd-billing/api-reference](/docs/sd-billing/api-reference)
- **Originating section**: License delete (revoke a subscription)

```mermaid
sequenceDiagram
  participant SM as sd-main / ops UI
  participant API as api/license/deleteOne
  participant DB as MySQL
  participant D as Diler

  SM->>API: POST {token, id, sd_id, sd_login}
  API->>API: auth() + day-of-month <= 5
  API->>DB: load Subscription (IS_DELETED=0)
  alt missing or non-bot type
    API-->>SM: fail
  else day > 5
    API-->>SM: fail "доступ запрещен"
  else allowed
    API->>DB: load siblings (DILER_ID, START_FROM, ACTIVE_TO)
    loop each sibling
      API->>DB: save SD_USER_* + deleteSubscrip()
    end
    API->>D: writeVisit() + deleteLicenseImmediately()
    API-->>SM: success {subscription_id}
  end
```

## 27. License pay (manual fallback) {#d-27}

- **Kind**: `flowchart`
- **Source page**: [sd-billing/api-reference](/docs/sd-billing/api-reference)
- **Originating section**: License pay (manual fallback)

```mermaid
flowchart LR
  S(["Operator receives<br/>off-channel payment"]) --> A["operation/PaymentController<br/>::actionCreateOrUpdate"]
  A --> AC{"Access<br/>operation.dealer.payment"}
  AC -- "deny" --> R1(["403"])
  AC -- "allow" --> SAVE["Payment->save()<br/>(TYPE=cash/p2p/cashless)"]
  SAVE --> DL["Diler::deleteLicense()<br/>(refresh licence on sd-main)"]
  DL --> OK(["success"])

  class S,A,SAVE,DL action
  class AC approval
  class R1 reject
  class OK success
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
```

## 28. License batch buy (read-side variant) {#d-28}

- **Kind**: `flowchart`
- **Source page**: [sd-billing/api-reference](/docs/sd-billing/api-reference)
- **Originating section**: License batch buy (read-side variant)

```mermaid
flowchart LR
  S(["sd-main loads<br/>billing screen"]) --> A["actionIndexBatch"]
  A --> AU{"auth() token"}
  AU -- "fail" --> R1(["fail"])
  AU -- "ok" --> D["getDilerWithRelations(host)"]
  D --> BAT["getSubscriptionsBatch(dilerId)<br/>13-month window"]
  BAT --> SQ["one SELECT Subscription<br/>+ one SELECT Payment"]
  SQ --> FOLD["group rows by month"]
  FOLD --> OUT["return balance, types,<br/>bonusLimit, subscriptions"]
  OUT --> OK(["success"])

  class S,A,D,BAT,SQ,FOLD,OUT action
  class AU approval
  class R1 reject
  class OK success
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
```

## 29. Host status report {#d-29}

- **Kind**: `sequence`
- **Source page**: [sd-billing/api-reference](/docs/sd-billing/api-reference)
- **Originating section**: Host status report

```mermaid
sequenceDiagram
  participant CL as Caller (ops tool)
  participant H as api/host
  participant U as User
  participant DLR as Diler

  CL->>H: POST /auth {login, password}
  H->>U: findByAttributes(LOGIN)
  H->>U: PASSWORD == md5(password)?
  alt invalid
    H-->>CL: 401
  else valid
    U->>U: generateToken()
    H-->>CL: 200 {token}
  end
  CL->>H: GET /activeHosts<br/>Authorization: Bearer …
  H->>H: checkPeakHours() (08–19 → 403)
  H->>DLR: findAll STATUS=ACTIVE
  DLR-->>H: rows
  H-->>CL: 200 {data:[{host,domain}]}
```

## 30. App auth (sd-main → sd-billing) {#d-30}

- **Kind**: `sequence`
- **Source page**: [sd-billing/api-reference](/docs/sd-billing/api-reference)
- **Originating section**: App auth (sd-main → sd-billing)

```mermaid
sequenceDiagram
  participant APP as sd-main / desktop app
  participant H as api/app
  participant U as User
  participant DB as MySQL

  APP->>H: POST /auth {login, password}
  H->>U: findByAttributes(LOGIN)
  H->>U: md5(password) match? isActive()?
  alt invalid
    H-->>APP: {success:false}
  else valid
    H->>H: UserIdentity::authenticate()
    H->>U: generateToken()
    H-->>APP: {success:true, token}
  end
  APP->>H: POST /execute {sql, token}
  H->>U: findByAttributes(TOKEN)
  alt token invalid or inactive
    H-->>APP: {success:false}
  else ok
    H->>DB: $db->createCommand(sql)->queryAll()
    DB-->>H: rows
    H-->>APP: {success:true, data}
  end
```

## 31. Workflow {#d-31}

- **Kind**: `sequence`
- **Source page**: [sd-billing/workflows/api-click](/docs/sd-billing/workflows/api-click)
- **Originating section**: Workflow

```mermaid
sequenceDiagram
    participant U  as User (Click app)
    participant C  as Click.uz
    participant CC as ClickController
    participant DB as MySQL
    participant D  as Diler (sd-main instance)

    U->>C: initiates payment
    C->>CC: POST /api/click/index  action=0 (prepare)
    CC->>CC: Logger::writeLog2 — raw request persisted
    CC->>CC: ClickTransaction::checkSign (HMAC md5)
    note over CC: returns -1 if sign invalid
    CC->>DB: validate Diler by merchant_trans_id (HOST field)
    note over CC: returns -5 if dealer not found or not UZB country
    CC->>DB: INSERT click_transaction (STATUS=0 / prepare)
    CC-->>C: 200 { error:0, merchant_prepare_id:#ID }
    note over CC: Logger::writeLog2 — response persisted

    C->>CC: POST /api/click/index  action=1 (confirm)
    CC->>CC: ClickTransaction::checkSign (HMAC md5, includes merchant_prepare_id)
    note over CC: returns -1 if sign invalid
    CC->>DB: SELECT click_transaction by merchant_prepare_id
    note over CC: returns -6 if not found
    CC->>CC: amount mismatch check
    note over CC: returns -2 if amounts differ
    CC->>CC: error field check (Click signals user cancellation via error≠0)
    note over CC: sets STATUS=2 (cancelled), returns -9
    CC->>CC: already-completed guard
    note over CC: returns -4 if STATUS already 1
    CC->>DB: BEGIN TRANSACTION
    CC->>DB: UPDATE click_transaction STATUS=1, UPDATE_AT=now()
    CC->>DB: INSERT payment TYPE=13 (clickonline), CASHBOX_ID=cashless
    note over DB: Payment::afterSave calls Diler::changeBalans(AMOUNT+DISCOUNT)
    note over DB: changeBalans increments BALANS, calls updateBalance() SUM recompute, writes LogBalans row
    CC->>D: Diler::deleteLicense() — enqueues HTTP DELETE to dealer's /api/billing/license
    CC->>D: Diler::refresh() — reload model state
    CC->>DB: UPDATE click_transaction PAYMENT_ID=payment.ID
    CC->>DB: COMMIT
    CC->>CC: TLogger::billingLog — structured billing audit log
    CC-->>C: 200 { error:0, merchant_confirm_id:#ID }
    note over CC: Logger::writeLog2 — response persisted
```

## 32. 4a. Listing payments {#d-32}

- **Kind**: `sequence`
- **Source page**: [sd-billing/workflows/operation-payment](/docs/sd-billing/workflows/operation-payment)
- **Originating section**: 4a. Listing payments

```mermaid
sequenceDiagram
  participant U as Operator
  participant FE as Browser (Vue)
  participant C as PaymentController
  participant DB as MySQL

  U->>FE: Opens /operation/payment/index
  FE->>C: GET actionIndex
  C->>DB: Load distributors, dealers, users, cashboxes, currencies, types
  C-->>FE: Render page with bootstrap data
  FE->>C: POST actionGetData {fromDate, toDate, ...filters}
  C->>DB: SELECT Payment JOIN Diler WHERE IS_DEMO=0 AND DATE IN [fromDate,toDate]
  C-->>FE: JSON array (column-first row format)
  FE->>U: Render data table
```

## 33. 4. Workflow {#d-33}

- **Kind**: `state`
- **Source page**: [sd-billing/workflows/operation-subscription](/docs/sd-billing/workflows/operation-subscription)
- **Originating section**: 4. Workflow

```mermaid
stateDiagram-v2
  direction LR
  [*] --> future : create (START_FROM > today)
  [*] --> active : create (START_FROM ≤ today ≤ ACTIVE_TO)
  future --> active : time passes
  active --> expired : time passes (ACTIVE_TO < today)
  future --> deleted : delete action
  active --> deleted : delete action
  expired --> deleted : delete action

  classDef action fill:#dbeafe,stroke:#1e40af,color:#000
  classDef success fill:#dcfce7,stroke:#166534,color:#000
  classDef reject fill:#fee2e2,stroke:#991b1b,color:#000
  classDef cron fill:#ede9fe,stroke:#6d28d9,color:#000
```

