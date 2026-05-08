---
sidebar_position: 1
title: "Экосистема"
audience: All team members
summary: "Карта трёх проектов платформы SalesDoctor. Используйте эти диаграммы, чтобы сориентировать новых сотрудников до погружения в любой отдельный проект."
topics: [diagrams, ecosystem]
---

# Экосистема — галерея диаграмм

Карта трёх проектов платформы SalesDoctor. Используйте эти диаграммы, чтобы сориентировать новых сотрудников до погружения в любой отдельный проект.

Все 3 диаграммы группы, отрисованные inline.

## Указатель

| # | Заголовок | Тип | Исходная страница |
|---|-------|------|-------------|
| 01 | [Экосистема SalesDoctor](#d-01) | `flowchart` | [ecosystem](/docs/ecosystem) |
| 02 | [Карта межпроектной интеграции](#d-02) | `flowchart` | [ecosystem](/docs/ecosystem) |
| 03 | [Каталог ключевых фич по проектам](#d-03) | `flowchart` | [ecosystem](/docs/ecosystem) |

## 01. Экосистема SalesDoctor {#d-01}

- **Тип**: `flowchart`
- **Исходная страница**: [ecosystem](/docs/ecosystem)
- **Раздел-источник**: Экосистема SalesDoctor

```mermaid
flowchart LR
  subgraph HQ["Brand owner / HQ"]
    CS["sd-cs"]
    CSDB[(MySQL cs_*)]
  end
  subgraph DealerA["Dealer A"]
    MA["sd-main"]
    DA[(MySQL sd_dealerA, d0_*)]
  end
  subgraph DealerB["Dealer B"]
    MB["sd-main"]
    DB2[(MySQL sd_dealerB, d0_*)]
  end
  subgraph Vendor["Platform vendor"]
    BL["sd-billing"]
    BLDB[(MySQL d0_* billing schema)]
  end
  CS --> CSDB
  CS -.->|read d0_*| DA
  CS -.->|read d0_*| DB2
  MA --> DA
  MB --> DB2
  BL --> BLDB
  BL -.->|push licences, sync phones, status| MA
  BL -.->|push licences, sync phones, status| MB
  BL -.->|push licences, sync phones, status| CS

  class CS,CSDB,MA,DA,MB,DB2,BL,BLDB action
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000

  style HQ fill:#ffffff,stroke:#cccccc
  style DealerA fill:#ffffff,stroke:#cccccc
  style DealerB fill:#ffffff,stroke:#cccccc
  style Vendor fill:#ffffff,stroke:#cccccc
```

## 02. Карта межпроектной интеграции {#d-02}

- **Тип**: `flowchart`
- **Исходная страница**: [ecosystem](/docs/ecosystem)
- **Раздел-источник**: Карта межпроектной интеграции

```mermaid
flowchart TB
  subgraph Billing["sd-billing (vendor)"]
    B_API["api/license + api/host + api/click + api/payme"]
    B_DB[("d0_* billing schema")]
    B_CRON["cron: notify settlement status"]
  end
  subgraph Main["sd-main (per dealer)"]
    M_API["api/billing (license + phone + status)"]
    M_DB[("d0_* dealer schema")]
    M_LIC["protected/license2/"]
  end
  subgraph CS["sd-cs (HQ)"]
    CS_API["api/billing (status only)"]
    CS_DB[("cs_* schema")]
    CS_DEAL["dealer connection (read-only swap)"]
  end

  M_API -->|"POST buyPackages exchange info"| B_API
  B_CRON -->|"POST license push + DELETE license"| M_API
  B_CRON -->|"POST phone (Spravochnik)"| M_API
  M_API -->|"writes/clears"| M_LIC
  B_CRON -->|"GET status?app=sdmanager"| CS_API
  CS_DEAL -.->|"read d0_* per-dealer"| M_DB
  B_API --> B_DB
  M_API --> M_DB
  CS_API --> CS_DB

  classDef action fill:#dbeafe,stroke:#1e40af,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron fill:#ede9fe,stroke:#6d28d9,color:#000
  class B_API,M_API,CS_API,CS_DEAL action
  class B_DB,M_DB,CS_DB,M_LIC external
  class B_CRON cron

  style Billing fill:#ffffff,stroke:#cccccc
  style Main fill:#ffffff,stroke:#cccccc
  style CS fill:#ffffff,stroke:#cccccc
```

## 03. Каталог ключевых фич по проектам {#d-03}

- **Тип**: `flowchart`
- **Исходная страница**: [ecosystem](/docs/ecosystem)
- **Раздел-источник**: Каталог ключевых фич по проектам

```mermaid
flowchart TB
  subgraph SDMain["sd-main · Dealer CRM"]
    direction TB
    M_ORD["Orders (web + mobile + B2B online)"]
    M_AGT["Agents · routes · KPI · vehicles"]
    M_CLI["Clients · contracts · segments · debt"]
    M_WHS["Warehouse · stock · inventory · transfers"]
    M_PAY["Payments · cashier approval · cashbox"]
    M_AUD["Audits · facing · photo reports"]
    M_GPS["GPS tracking · geofence · trip playback"]
    M_INT["Integrations 1C · Didox · Faktura.uz · Smartup"]
    M_RPT["80+ reports · Excel export · pivots"]
    M_OO["B2B online store · Telegram bot · WebApp"]
  end

  subgraph SDCs["sd-cs · HQ Country Sales"]
    direction TB
    CS_RPT["Consolidated reports across all dealers"]
    CS_PIV["Pivots · RFM · SKU · expeditor"]
    CS_DIR["HQ directory · brands · segments · plans"]
    CS_MDB["Multi-DB read of dealer DBs (read-only)"]
  end

  subgraph SDBilling["sd-billing · Subscriptions and licensing"]
    direction TB
    B_SUB["Subscriptions · packages · tariffs · bonus"]
    B_LIC["Licence files · feature gating per system"]
    B_PAY["Click · Payme · Paynet · MBANK · P2P · cash"]
    B_SET["Daily settlement distributor / dealer"]
    B_NOT["Telegram + SMS notifications · expiry reminders"]
    B_PRT["Partner portal · self-service"]
  end

  classDef action fill:#dbeafe,stroke:#1e40af,color:#000
  class M_ORD,M_AGT,M_CLI,M_WHS,M_PAY,M_AUD,M_GPS,M_INT,M_RPT,M_OO action
  class CS_RPT,CS_PIV,CS_DIR,CS_MDB action
  class B_SUB,B_LIC,B_PAY,B_SET,B_NOT,B_PRT action

  style SDMain fill:#ffffff,stroke:#cccccc
  style SDCs fill:#ffffff,stroke:#cccccc
  style SDBilling fill:#ffffff,stroke:#cccccc
```

