---
sidebar_position: 3
title: "sd-cs (HQ)"
audience: Jamoaning barcha a'zolari
summary: "Konsolidatsiyalangan hisobotlarni yaratish uchun ko'plab diler DB laridan o'qiydigan bosh ofis ilovasi."
topics: [diagrams, sd, cs]
---

# sd-cs (HQ) — diagramma galereyasi

Konsolidatsiyalangan hisobotlarni yaratish uchun ko'plab diler DB laridan
o'qiydigan bosh ofis ilovasi.

Ushbu guruhdagi 11 ta diagrammaning hammasi ichki ko'rinishda chizilgan.

## Indeks

| # | Sarlavha | Tur | Manba sahifa |
|---|-------|------|-------------|
| 01 | [Ikki-DB ulanish xaritasi](#d-01) | `flowchart` | [sd-cs/architecture](/docs/sd-cs/architecture) |
| 02 | [DB lararo bog'lanish (filial bridge)](#d-02) | `er` | [sd-cs/architecture](/docs/sd-cs/architecture) |
| 03 | [`b_demo` ichidagi multi-tenant tartibi](#d-03) | `flowchart` | [sd-cs/architecture](/docs/sd-cs/architecture) |
| 04 | [`setFilial()` jadvalni qayta yozishi](#d-04) | `flowchart` | [sd-cs/architecture](/docs/sd-cs/architecture) |
| 05 | [Login → filial scoping → so'rov](#d-05) | `sequence` | [sd-cs/architecture](/docs/sd-cs/architecture) |
| 06 | [Modul → ulanish matritsasi](#d-06) | `flowchart` | [sd-cs/architecture](/docs/sd-cs/architecture) |
| 07 | [Arxitektura (diagramma)](#d-07) | `flowchart` | [sd-cs/overview](/docs/sd-cs/overview) |
| 08 | [Yangi dilerni onboarding qilish](#d-08) | `flowchart` | [sd-cs/sd-main-integration](/docs/sd-cs/sd-main-integration) |
| 09 | [Ish jarayoni](#d-09) | `sequence` | [sd-cs/workflows/report-inventory](/docs/sd-cs/workflows/report-inventory) |
| 10 | [Ish jarayoni](#d-10) | `sequence` | [sd-cs/workflows/report-sale](/docs/sd-cs/workflows/report-sale) |
| 11 | [Ish jarayoni](#d-11) | `sequence` | [sd-cs/workflows/pivot-akb](/docs/sd-cs/workflows/pivot-akb) |

## 01. Ikki-DB ulanish xaritasi {#d-01}

- **Turi**: `flowchart`
- **Manba sahifa**: [sd-cs/architecture](/docs/sd-cs/architecture)
- **Boshlovchi bo'lim**: Ikki-DB ulanish xaritasi

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

## 02. DB lararo bog'lanish (filial bridge) {#d-02}

- **Turi**: `er`
- **Manba sahifa**: [sd-cs/architecture](/docs/sd-cs/architecture)
- **Boshlovchi bo'lim**: DB lararo bog'lanish (filial bridge)

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

## 03. `b_demo` ichidagi multi-tenant tartibi {#d-03}

- **Turi**: `flowchart`
- **Manba sahifa**: [sd-cs/architecture](/docs/sd-cs/architecture)
- **Boshlovchi bo'lim**: `b_demo` ichidagi multi-tenant tartibi

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

## 04. `setFilial()` jadvalni qayta yozishi {#d-04}

- **Turi**: `flowchart`
- **Manba sahifa**: [sd-cs/architecture](/docs/sd-cs/architecture)
- **Boshlovchi bo'lim**: `setFilial()` jadvalni qayta yozishi

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

## 05. Login → filial scoping → so'rov {#d-05}

- **Turi**: `sequence`
- **Manba sahifa**: [sd-cs/architecture](/docs/sd-cs/architecture)
- **Boshlovchi bo'lim**: Login → filial scoping → so'rov

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

## 06. Modul → ulanish matritsasi {#d-06}

- **Turi**: `flowchart`
- **Manba sahifa**: [sd-cs/architecture](/docs/sd-cs/architecture)
- **Boshlovchi bo'lim**: Modul → ulanish matritsasi

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

## 07. Arxitektura (diagramma) {#d-07}

- **Turi**: `flowchart`
- **Manba sahifa**: [sd-cs/overview](/docs/sd-cs/overview)
- **Boshlovchi bo'lim**: Arxitektura (diagramma)

```mermaid
flowchart LR
  HQ[HQ users] --> APP[sd-cs]
  APP --> OWN[(MySQL cs_*)]
  APP -.-> D1[(Dealer A d0_*)]
  APP -.-> D2[(Dealer B d0_*)]
  APP -.-> DN[(Dealer N d0_*)]
  APP --> RD[(Redis sessions)]

  class HQ,APP,OWN,RD action
  class D1,D2,DN external
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
```

## 08. Yangi dilerni onboarding qilish {#d-08}

- **Turi**: `flowchart`
- **Manba sahifa**: [sd-cs/sd-main-integration](/docs/sd-cs/sd-main-integration)
- **Boshlovchi bo'lim**: Yangi dilerni onboarding qilish

```mermaid
flowchart LR
  A(["New dealer signs contract"]) --> B["sd-billing creates Diler row"]
  B --> C["sd-billing pushes licence file"]
  C --> D["Dealer's sd-main is provisioned"]
  D --> E["Dealer DB credentials registered in HQ"]
  E --> F["DealerRegistry row inserted in cs_*"]
  F --> G["Test report against new dealer"]
  G --> H["Capability flags filled in registry"]
  H --> I(["Dealer included in default HQ reports"])

  class A action
  class B,C,D,E,F,G,H action
  class I success
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
```

## 09. Ish jarayoni {#d-09}

- **Turi**: `sequence`
- **Manba sahifa**: [sd-cs/workflows/report-inventory](/docs/sd-cs/workflows/report-inventory)
- **Boshlovchi bo'lim**: Ish jarayoni

```mermaid
sequenceDiagram
  autonumber
  participant U as Trade-marketing manager
  participant W as sd-cs · /report/inventory
  participant CS as cs3_demo
  participant BD as b_demo (per-filial)

  U->>W: GET /report/inventory
  W->>CS: cs_region, cs_territory (filter dictionaries)
  W->>BD: d0_inventory_type, d0_inventory_group
  W-->>U: render filter form + grid placeholder
  U->>W: pick group (filial / region / territory)
  W->>W: POST /report/inventory/getData
  loop for each visible filial fN
    W->>BD: SELECT INV_TYPE_ID, COUNT(*)<br/>FROM d0_fN_inventory_history<br/>WHERE DATE_TO IS NULL
  end
  W-->>U: roll-up grid (inventory type × group key)
  U->>W: click cell → POST /report/inventory/getClients
  W->>BD: SELECT … FROM d0_fN_inventory_history h<br/>JOIN d0_fN_inventory inv, d0_fN_client, …
  W-->>U: client list with photo counts
  U->>W: click a unit → POST /report/inventory/getPhotos
  W->>BD: SELECT … FROM d0_fN_photo_inventory
  W-->>U: photo carousel (URLs use filial.domain)
```

## 10. Ish jarayoni {#d-10}

- **Turi**: `sequence`
- **Manba sahifa**: [sd-cs/workflows/report-sale](/docs/sd-cs/workflows/report-sale)
- **Boshlovchi bo'lim**: Ish jarayoni

```mermaid
sequenceDiagram
  autonumber
  participant U as Manager
  participant W as sd-cs · /report/sell
  participant CS as cs3_demo
  participant BD as b_demo (per-filial)

  U->>W: GET /report/sell
  W->>CS: cs_user_filial (visible filials)
  W->>BD: d0_filial (active='Y')
  W->>BD: d0_product, d0_product_category, … (filter dictionaries)
  W-->>U: render filter form (categories, regions, brands, …)
  U->>W: pick filters + Apply
  W->>W: POST /report/sell/getData
  loop for each visible filial fN
    W->>BD: SELECT … FROM d0_fN_order_detail t<br/>JOIN d0_fN_order, d0_fN_client, d0_product
  end
  W-->>U: aggregated grid (rows = product category, cols = filial / region / territory / group)
  U->>W: Export → POST /report/sell/export
  W-->>U: PHPExcel .xlsx
```

## 11. Ish jarayoni {#d-11}

- **Turi**: `sequence`
- **Manba sahifa**: [sd-cs/workflows/pivot-akb](/docs/sd-cs/workflows/pivot-akb)
- **Boshlovchi bo'lim**: Ish jarayoni

```mermaid
sequenceDiagram
  autonumber
  participant U as Manager
  participant W as sd-cs · /pivot/akb
  participant CS as cs3_demo
  participant BD as b_demo (per-filial)

  U->>W: GET /pivot/akb
  W-->>U: render shell + pivot UI
  U->>W: choose date range, groupBy, okbType
  W->>W: GET /pivot/akb/pivotData?…
  W->>CS: cs_user_filial → visible filials
  W->>BD: d0_filial active='Y'
  loop for each visible filial fN
    W->>BD: SELECT … FROM d0_fN_order_detail t<br/>JOIN d0_fN_order, d0_product
    W->>BD: SELECT COUNT(DISTINCT) FROM d0_fN_visit (or d0_fN_client)
    W-->>U: stream a JSON line per result row (NDJSON inside an array)
  end
  U->>W: Save view → POST /pivot/akb/saveReport
  W->>CS: cs_pivot_config(code='akb', name, config)
```

