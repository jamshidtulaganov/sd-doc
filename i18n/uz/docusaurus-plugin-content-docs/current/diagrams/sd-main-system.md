---
sidebar_position: 4
title: "sd-main · Tizim dizayni"
audience: Jamoaning barcha a'zolari
summary: "sd-main ning qatlam darajasidagi arxitekturasi — HTTP, ilova qatlami, MySQL, Redis (3 DB), navbat, cron, fayl saqlash."
topics: [diagrams, sd, main, system]
---

# sd-main · Tizim dizayni — diagramma galereyasi

sd-main ning qatlam darajasidagi arxitekturasi — HTTP, ilova qatlami,
MySQL, Redis (3 DB), navbat, cron, fayl saqlash.

Ushbu guruhdagi 7 ta diagrammaning hammasi ichki ko'rinishda chizilgan.

## Indeks

| # | Sarlavha | Tur | Manba sahifa |
|---|-------|------|-------------|
| 01 | [Topologiya umumiy ko'rinishi](#d-01) | `flowchart` | [devops/deployment](/docs/devops/deployment) |
| 02 | [Yuqori darajadagi diagramma](#d-02) | `flowchart` | [architecture/overview](/docs/architecture/overview) |
| 03 | [1. Topologiya](#d-03) | `flowchart` | [architecture/cross-project-integration](/docs/architecture/cross-project-integration) |
| 04 | [2.3 Ketma-ketlik — litsenziya yuborish (eng keng tarqalgan)](#d-04) | `sequence` | [architecture/cross-project-integration](/docs/architecture/cross-project-integration) |
| 05 | [3.2 buyPackages — kanonik yo'l](#d-05) | `sequence` | [architecture/cross-project-integration](/docs/architecture/cross-project-integration) |
| 06 | [4.4 Ketma-ketlik — dilerlararo hisobot](#d-06) | `sequence` | [architecture/cross-project-integration](/docs/architecture/cross-project-integration) |
| 07 | [6. Yangi dilerni provisioning qilish (boshidan oxirigacha)](#d-07) | `flowchart` | [architecture/cross-project-integration](/docs/architecture/cross-project-integration) |

## 01. Topologiya umumiy ko'rinishi {#d-01}

- **Turi**: `flowchart`
- **Manba sahifa**: [devops/deployment](/docs/devops/deployment)
- **Boshlovchi bo'lim**: Topologiya umumiy ko'rinishi

```mermaid
flowchart LR
    subgraph "sd-main (dealer CRM)"
        M_IMG[php:7.3-fpm + nginx<br/>1 container]
        M_DB[(MySQL 8.0<br/>per-tenant DBs)]
        M_R[(Redis 7)]
        M_IMG --> M_DB
        M_IMG --> M_R
    end
    subgraph "sd-billing"
        B_IMG[php:7.2-apache<br/>1 container]
        B_DB[(MySQL 8.0)]
        B_IMG --> B_DB
    end
    subgraph "sd-cs (HQ)"
        C_IMG[no container today<br/>deployed via SFTP/rsync]
    end

    class M_IMG,M_DB,M_R,B_IMG,B_DB,C_IMG action
    classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
    classDef external fill:#f3f4f6,stroke:#374151,color:#000
    classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
```

## 02. Yuqori darajadagi diagramma {#d-02}

- **Turi**: `flowchart`
- **Manba sahifa**: [architecture/overview](/docs/architecture/overview)
- **Boshlovchi bo'lim**: Yuqori darajadagi diagramma

```mermaid
flowchart LR
  subgraph Clients
    WB[Web Admin]
    MA[Mobile Agent]
    OS[Online Store]
    EXT[(External: 1C, Didox, Faktura.uz, Smartup)]
  end
  subgraph Edge
    NX[Nginx]
  end
  subgraph App[App tier - PHP 7.3 + Yii 1.x]
    WEB[Web]
    A1[api]
    A3[api3 mobile]
    A4[api4 online]
    JOBS[Queue Workers]
    CRON[Cron]
  end
  subgraph Data
    DB[(MySQL 8)]
    R0[(Redis db0 sessions)]
    R1[(Redis db1 queue)]
    R2[(Redis db2 cache)]
    FS[(File storage)]
  end
  WB --> NX
  MA --> NX
  OS --> NX
  EXT --> NX
  NX --> WEB
  NX --> A1
  NX --> A3
  NX --> A4
  WEB --> DB
  WEB --> R0
  WEB --> R2
  A3 --> DB
  A3 --> R2
  A4 --> DB
  A4 --> R2
  WEB --> R1
  R1 --> JOBS
  JOBS --> DB
  CRON --> R1
  WEB --> FS

  class WB,MA,OS,NX,WEB,A1,A3,A4,JOBS,CRON,DB,R0,R1,R2,FS action
  class EXT external
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000

  style Clients fill:#ffffff,stroke:#cccccc
  style Edge fill:#ffffff,stroke:#cccccc
  style App fill:#ffffff,stroke:#cccccc
  style Data fill:#ffffff,stroke:#cccccc
```

## 03. 1. Topologiya {#d-03}

- **Turi**: `flowchart`
- **Manba sahifa**: [architecture/cross-project-integration](/docs/architecture/cross-project-integration)
- **Boshlovchi bo'lim**: 1. Topologiya

```mermaid
flowchart LR
  subgraph Vendor["Platform vendor (sd-billing)"]
    BL["sd-billing<br/>Yii 1.1.15"]
    BLDB[("d0_* billing schema")]
    BLCRON["cron.php<br/>notify · stat · settlement<br/>botLicenseReminder"]
  end

  subgraph DealerN["Dealer N (×100s)"]
    direction TB
    MA["sd-main<br/>Yii 1.x"]
    MADB[("d0_* dealer schema")]
    LIC["protected/license2/*"]
  end

  subgraph HQ["HQ (sd-cs, ×country)"]
    CS["sd-cs<br/>Yii 1.x"]
    CSDB[("cs_* HQ schema")]
  end

  BLCRON -->|"POST /api/billing/license<br/>(delete licence files)"| MA
  BLCRON -->|"POST /api/billing/phone<br/>(sync Spravochnik)"| MA
  BLCRON -->|"GET /api/billing/stat"| MA
  BLCRON -->|"POST /api/billing/telegramLicense"| MA
  BLCRON -->|"GET /api/sli/status?app=sdmanager"| CS
  MA -->|"POST /api/license/buyPackages<br/>POST /api/license/exchange<br/>POST /api/license/info"| BL
  CS -.->|"swap dealer connection<br/>SELECT FROM d0_*"| MADB
  MA --> MADB
  MA --> LIC
  CS --> CSDB
  BL --> BLDB

  classDef action  fill:#dbeafe,stroke:#1e40af,color:#000
  classDef cron    fill:#ede9fe,stroke:#6d28d9,color:#000
  classDef store   fill:#f3f4f6,stroke:#374151,color:#000
  class BL,MA,CS action
  class BLCRON cron
  class BLDB,MADB,CSDB,LIC store

  style Vendor  fill:#ffffff,stroke:#cccccc
  style DealerN fill:#ffffff,stroke:#cccccc
  style HQ      fill:#ffffff,stroke:#cccccc
```

## 04. 2.3 Ketma-ketlik — litsenziya yuborish (eng keng tarqalgan) {#d-04}

- **Turi**: `sequence`
- **Manba sahifa**: [architecture/cross-project-integration](/docs/architecture/cross-project-integration)
- **Boshlovchi bo'lim**: 2.3 Ketma-ketlik — litsenziya yuborish (eng keng tarqalgan)

```mermaid
sequenceDiagram
  autonumber
  participant Op as Operator (sd-billing UI)
  participant BL as sd-billing
  participant Q  as d0_notify_cron
  participant CR as cron.php notify (1m)
  participant MA as sd-main /api/billing/license

  Op->>BL: Top-up Diler.BALANS<br/>or change Diler.HOST
  BL->>BL: Diler::beforeSave hook<br/>→ deleteLicense()
  BL->>Q: NotifyCron::createLicenseDelete(<br/>  url=DOMAIN+/api/billing/license)
  CR->>Q: pop pending row
  CR->>MA: POST /api/billing/license
  MA->>MA: glob protected/license2/* → unlink
  MA-->>CR: 200 {status:true}
  CR->>Q: mark sent
  Note over MA: next page load on sd-main<br/>re-fetches licence from sd-billing
```

## 05. 3.2 buyPackages — kanonik yo'l {#d-05}

- **Turi**: `sequence`
- **Manba sahifa**: [architecture/cross-project-integration](/docs/architecture/cross-project-integration)
- **Boshlovchi bo'lim**: 3.2 buyPackages — kanonik yo'l

```mermaid
sequenceDiagram
  autonumber
  participant SU as Dealer user (sd-main UI)
  participant MA as sd-main
  participant BL as sd-billing /api/license/buyPackages
  participant DB as sd-billing MySQL
  participant LF as sd-main protected/license2/

  SU->>MA: Click "Buy package X"
  MA->>BL: POST {token, dealer, package_id, qty}
  BL->>BL: validate token,<br/>currency match,<br/>balance ≥ MIN_SUMMA
  BL->>DB: BEGIN
  BL->>DB: INSERT Subscription rows<br/>INSERT Payment(TYPE_LICENSE, -amount)
  BL->>BL: Payment::afterSave → Diler::changeBalans (PHP)<br/>+ updateBalance() SUM recompute
  BL->>DB: COMMIT
  BL-->>MA: 200 {success, balance, subs}
  MA->>LF: write /protected/license2/<feature>.lic
  Note over MA: subsequent pages read<br/>licence from license2/
```

## 06. 4.4 Ketma-ketlik — dilerlararo hisobot {#d-06}

- **Turi**: `sequence`
- **Manba sahifa**: [architecture/cross-project-integration](/docs/architecture/cross-project-integration)
- **Boshlovchi bo'lim**: 4.4 Ketma-ketlik — dilerlararo hisobot

```mermaid
sequenceDiagram
  autonumber
  participant U  as HQ user
  participant CS as sd-cs (controller)
  participant CR as cs_dealer_registry
  participant DA as d0_* dealer A
  participant DB as d0_* dealer B
  participant DN as d0_* dealer N

  U->>CS: GET /report/sales?from=…&to=…
  CS->>CR: SELECT * FROM cs_dealer_registry<br/>WHERE active=1
  loop per dealer
    CS->>CS: build CDbConnection(dsn,user,pass)<br/>setComponent('dealer', cn)
    CS->>DA: SELECT DATE,SUM(SUMMA) FROM d0_order<br/>WHERE STATUS IN(...) GROUP BY d
    DA-->>CS: rows
    CS->>CS: cn->active = false  (release)
  end
  CS->>CS: PHP aggregator.fold(rows[])
  CS-->>U: report HTML / JSON
```

## 07. 6. Yangi dilerni provisioning qilish (boshidan oxirigacha) {#d-07}

- **Turi**: `flowchart`
- **Manba sahifa**: [architecture/cross-project-integration](/docs/architecture/cross-project-integration)
- **Boshlovchi bo'lim**: 6. Yangi dilerni provisioning qilish (boshidan oxirigacha)

```mermaid
flowchart LR
  A(["Contract signed"]) --> B["sd-billing creates Diler row"]
  B --> C["Diler::sendRequest()<br/>creates Server (status=SENT)"]
  C --> D["Server.createServer<br/>provisions dealer MySQL + sd-main host"]
  D --> E["Server.status=OPENED"]
  E --> F["sd-billing pushes initial licence<br/>POST /api/billing/license"]
  F --> G["Dealer registry row inserted in cs_*<br/>(DSN, capability flags)"]
  G --> H["sd-cs runs smoke report"]
  H --> I(["Dealer live, included in HQ rollups"])

  classDef action  fill:#dbeafe,stroke:#1e40af,color:#000
  classDef success fill:#dcfce7,stroke:#166534,color:#000
  class A,B,C,D,E,F,G,H action
  class I success
```

