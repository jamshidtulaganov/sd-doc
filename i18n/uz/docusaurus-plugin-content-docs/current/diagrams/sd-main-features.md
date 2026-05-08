---
sidebar_position: 6
title: "sd-main · Xususiyat oqimlari"
audience: Jamoaning barcha a'zolari
summary: "sd-main dagi kundalik operatsiyalar uchun har bir modul bo'yicha xususiyat oqimlari."
topics: [diagrams, sd, main, features]
---

# sd-main · Xususiyat oqimlari — diagramma galereyasi

sd-main dagi kundalik operatsiyalar uchun har bir modul bo'yicha xususiyat
oqimlari.

Ushbu guruhdagi 16 ta diagrammaning hammasi ichki ko'rinishda chizilgan.

## Indeks

| # | Sarlavha | Tur | Manba sahifa |
|---|-------|------|-------------|
| 01 | [Tasdiqlash ish jarayoni](#d-01) | `flowchart` | [modules/clients](/docs/modules/clients) |
| 02 | [Asosiy xususiyat oqimi — Buyurtma eksporti](#d-02) | `flowchart` | [modules/integration](/docs/modules/integration) |
| 03 | [Asosiy xususiyat oqimi — Hisobotni ishga tushirish](#d-03) | `flowchart` | [modules/report](/docs/modules/report) |
| 04 | [Tasdiqlash oqimi](#d-04) | `flowchart` | [modules/payment](/docs/modules/payment) |
| 05 | [Asosiy xususiyat oqimi — SMS yuborish](#d-05) | `sequence` | [modules/sms](/docs/modules/sms) |
| 06 | [Asosiy xususiyat oqimi — Inventarizatsiya](#d-06) | `flowchart` | [modules/inventory](/docs/modules/inventory) |
| 07 | [Asosiy xususiyat oqimi — Topshirish](#d-07) | `flowchart` | [modules/audit-adt](/docs/modules/audit-adt) |
| 08 | [Domen mavjudotlari](#d-08) | `er` | [modules/audit-adt](/docs/modules/audit-adt) |
| 09 | [Workflow 1.1 — Foto-hisobot olish va ko'rib chiqish](#d-09) | `sequence` | [modules/audit-adt](/docs/modules/audit-adt) |
| 10 | [Workflow 1.2 — Storecheck (MML) muvofiqlik tekshiruvi](#d-10) | `flowchart` | [modules/audit-adt](/docs/modules/audit-adt) |
| 11 | [Asosiy xususiyat oqimi — Tovar qabul qilish](#d-11) | `flowchart` | [modules/warehouse](/docs/modules/warehouse) |
| 12 | [Asosiy xususiyat oqimi — Onlayn buyurtma](#d-12) | `flowchart` | [modules/onlineOrder](/docs/modules/onlineOrder) |
| 13 | [Status mashinasi](#d-13) | `state` | [modules/orders](/docs/modules/orders) |
| 14 | [Asosiy xususiyat oqimi — Buyurtma yaratish](#d-14) | `sequence` | [modules/orders](/docs/modules/orders) |
| 15 | [Asosiy xususiyat oqimi — Tashrif va GPS](#d-15) | `flowchart` | [modules/agents](/docs/modules/agents) |
| 16 | [Asosiy xususiyat oqimi — Defekt va Qaytarish](#d-16) | `flowchart` | [modules/stock](/docs/modules/stock) |

## 01. Tasdiqlash ish jarayoni {#d-01}

- **Turi**: `flowchart`
- **Manba sahifa**: [modules/clients](/docs/modules/clients)
- **Boshlovchi bo'lim**: Tasdiqlash ish jarayoni

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

## 02. Asosiy xususiyat oqimi — Buyurtma eksporti {#d-02}

- **Turi**: `flowchart`
- **Manba sahifa**: [modules/integration](/docs/modules/integration)
- **Boshlovchi bo'lim**: Asosiy xususiyat oqimi — Buyurtma eksporti

```mermaid
flowchart LR
  S(["Order Loaded/Delivered"]) --> J["Enqueue ExportOrderJob"]
  J --> C{"Provider"}
  C -->|1C| S1[("POST 1C")]
  C -->|Didox| S2[("POST Didox")]
  C -->|Faktura| S3[("POST Faktura.uz")]
  S1 --> LOG["integration_log"]
  S2 --> LOG
  S3 --> LOG
  LOG --> RTY{"Retry count ≤ 6 and error?"}
  RTY -->|yes| BACK["Retry backoff max 6"]
  RTY -->|no| DONE(["Done"])
classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
classDef approval fill:#fef3c7,stroke:#92400e,color:#000
classDef success  fill:#dcfce7,stroke:#166534,color:#000
classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
classDef external fill:#f3f4f6,stroke:#374151,color:#000
classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
class S,J,LOG,BACK action
class S1,S2,S3 external
class DONE success
```

## 03. Asosiy xususiyat oqimi — Hisobotni ishga tushirish {#d-03}

- **Turi**: `flowchart`
- **Manba sahifa**: [modules/report](/docs/modules/report)
- **Boshlovchi bo'lim**: Asosiy xususiyat oqimi — Hisobotni ishga tushirish

```mermaid
flowchart LR
  U(["Open report"]) --> F["Set filters"]
  F --> CHK{"Cache hit?"}
  CHK -->|yes| R["Render"]
  CHK -->|no| SQL["Aggregate SQL"]
  SQL --> CACHE[("redis_app TTL 300s")]
  CACHE --> R
  R --> EX{"Export?"}
  EX -->|yes| XLS(["PHPExcel -> .xlsx"])

  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000

  class U,F,CHK,R,SQL,EX action
  class CACHE external
  class XLS success
```

## 04. Tasdiqlash oqimi {#d-04}

- **Turi**: `flowchart`
- **Manba sahifa**: [modules/payment](/docs/modules/payment)
- **Boshlovchi bo'lim**: Tasdiqlash oqimi

```mermaid
flowchart LR
  A["Agent collects cash"] --> B["Pay record created"]
  B --> C{"Approval needed?"}
  C -- yes --> D["Cashier reviews"]
  D --> E["Approved / Rejected"]
  C -- no --> F["Auto-applied"]
  E --> F
classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
classDef approval fill:#fef3c7,stroke:#92400e,color:#000
classDef success  fill:#dcfce7,stroke:#166534,color:#000
classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
classDef external fill:#f3f4f6,stroke:#374151,color:#000
classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
class A,B,F action
class D approval
class E success
```

## 05. Asosiy xususiyat oqimi — SMS yuborish {#d-05}

- **Turi**: `sequence`
- **Manba sahifa**: [modules/sms](/docs/modules/sms)
- **Boshlovchi bo'lim**: Asosiy xususiyat oqimi — SMS yuborish

```mermaid
sequenceDiagram
  participant E as Trigger
  participant Q as Queue
  participant J as SendSmsJob
  participant P as Provider
  participant CB as Callback
  E->>Q: enqueue
  J->>P: send
  P-->>J: 202
  P->>CB: DLR
  CB->>J: status delivered/failed
```

## 06. Asosiy xususiyat oqimi — Inventarizatsiya {#d-06}

- **Turi**: `flowchart`
- **Manba sahifa**: [modules/inventory](/docs/modules/inventory)
- **Boshlovchi bo'lim**: Asosiy xususiyat oqimi — Inventarizatsiya

```mermaid
flowchart LR
  M(["Manager creates doc"]) --> SC["Operators scan"]
  SC --> CALC["Compute deltas vs Stock"]
  CALC --> REV{"Manager approves?"}
  REV -->|approve| POST(["Post adjustments"])
  REV -->|adjust| SC

  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000

  class M,SC,CALC action
  class REV approval
  class POST success
```

## 07. Asosiy xususiyat oqimi — Topshirish {#d-07}

- **Turi**: `flowchart`
- **Manba sahifa**: [modules/audit-adt](/docs/modules/audit-adt)
- **Boshlovchi bo'lim**: Asosiy xususiyat oqimi — Topshirish

```mermaid
flowchart LR
  V(["At client"]) --> Q["Answer poll"]
  Q --> F["Mark facing"]
  F --> P["Photos"]
  P --> SUB["POST /api3/auditor/index"]
  SUB --> AR["AuditResult rows"]
  AR --> RV["Supervisor review"]
  RV --> KPI(["Compliance KPI"])

  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000

  class V,Q,F,P,SUB,AR action
  class RV approval
  class KPI success
```

## 08. Domen mavjudotlari {#d-08}

- **Turi**: `er`
- **Manba sahifa**: [modules/audit-adt](/docs/modules/audit-adt)
- **Boshlovchi bo'lim**: Domen mavjudotlari

```mermaid
erDiagram
    PhotoReport {
        string CLIENT_ID FK
        string AGENT_ID FK
        string USER_ID FK
        string PARENT
        string URL
        string DATE
        string RATING
        string STATUS
    }
    AudCategory {
        int ID PK
        string NAME
        int PARENT
        int BRAND
        int SORT
        int ACTIVE
        int FACING_CHECK
        int MIN
        int MAX
    }
    AudProduct {
        int ID PK
        int CAT_ID FK
    }
    AuditStorchekCat {
        string CAT_ID FK
        int TOTAL_INDEX
        string MML_PRODUCT
    }
    AudSku {
        string CLIENT_ID FK
        string USER_ID FK
        int CAT_ID FK
        int PRODUCT_ID FK
        decimal PRICE
        string DATE
    }
    Client {
        string CLIENT_ID PK
    }

    PhotoReport }o--|| Client : "CLIENT_ID"
    AudSku }o--|| Client : "CLIENT_ID"
    AudSku }o--|| AudCategory : "CAT_ID"
    AudSku }o--|| AudProduct : "PRODUCT_ID"
    AuditStorchekCat }o--|| AudCategory : "CAT_ID"
    AudProduct }o--|| AudCategory : "CAT_ID"
```

## 09. Workflow 1.1 — Foto-hisobot olish va ko'rib chiqish {#d-09}

- **Turi**: `sequence`
- **Manba sahifa**: [modules/audit-adt](/docs/modules/audit-adt)
- **Boshlovchi bo'lim**: Workflow 1.1 — Foto-hisobot olish va ko'rib chiqish

```mermaid
sequenceDiagram
    participant Mobile
    participant api3
    participant DB
    participant Web
    participant PhotoReportController

    Mobile->>api3: POST /api3/auditor/setphoto (photo file + CLIENT_ID + PARENT)
    api3->>api3: api3/AuditorController::actionSetphoto — validate + build PhotoReport
    api3->>DB: INSERT photo_report (URL, CLIENT_ID, AGENT_ID, DATE, STATUS)
    api3-->>Mobile: 200 OK (saved record ID)

    Web->>PhotoReportController: GET /audit/photo-report (date range + CLIENT_ID filter)
    PhotoReportController->>DB: SELECT photo_report WHERE CLIENT_ID, DATE (PhotoReportController::actionAjax)
    DB-->>PhotoReportController: photo_report rows with URL, RATING, STATUS
    PhotoReportController-->>Web: JSON photo record list
    Web->>PhotoReportController: POST rating update (RATING field)
    PhotoReportController->>DB: UPDATE photo_report SET RATING
    PhotoReportController-->>Web: 200 OK
```

## 10. Workflow 1.2 — Storecheck (MML) muvofiqlik tekshiruvi {#d-10}

- **Turi**: `flowchart`
- **Manba sahifa**: [modules/audit-adt](/docs/modules/audit-adt)
- **Boshlovchi bo'lim**: Workflow 1.2 — Storecheck (MML) muvofiqlik tekshiruvi

```mermaid
flowchart TD
    A[Web requests storecheck matrix\nStorecheckController::actionIndex]
    A -- fetch configs --> B[Load all AuditStorchekCat rows\nReport::getSpravochnikResult]
    B -- fetch categories --> C[Load all AudCategory configs\nAudCategory::model]
    C -- loop clients --> D[For each client row]
    D -- loop categories --> E[For each AuditStorchekCat config]
    E --> F{MML_PRODUCT\nnon-empty?}
    F -- No --> G[Mark category: N/A]
    F -- Yes --> H[json_decode MML_PRODUCT\ninto product ID list]
    H -- query SKUs --> I[SELECT aud_sku WHERE CLIENT_ID\nAND CAT_ID AND DATE range]
    I -- evaluate --> J{All MML product IDs\nfound in aud_sku?}
    J -- Yes --> K[Mark category: Compliant]
    J -- No --> L[Mark category: Missing — list absent IDs]
    K -- join orders --> M[JOIN orders.OrderDetail ON CLIENT_ID\nget MAX order date]
    L -- join orders --> M
    G -- join orders --> M
    M -- update row --> N[Append last-order date to client row]
    N --> O{More categories?}
    O -- Yes --> E
    O -- No --> P{More clients?}
    P -- Yes --> D
    P -- No --> Q[Render compliance matrix to Web]
```

## 11. Asosiy xususiyat oqimi — Tovar qabul qilish {#d-11}

- **Turi**: `flowchart`
- **Manba sahifa**: [modules/warehouse](/docs/modules/warehouse)
- **Boshlovchi bo'lim**: Asosiy xususiyat oqimi — Tovar qabul qilish

```mermaid
flowchart LR
  S(["Open Add doc"]) --> WT["Pick warehouse + type"]
  WT --> ADD["Scan/pick lines"]
  ADD --> SAV["Save doc"]
  SAV --> POST["Stock += count"]
  POST --> SYNC[("Optional 1C sync")]

  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000

  class S,WT,ADD,SAV,POST action
  class SYNC external
```

## 12. Asosiy xususiyat oqimi — Onlayn buyurtma {#d-12}

- **Turi**: `flowchart`
- **Manba sahifa**: [modules/onlineOrder](/docs/modules/onlineOrder)
- **Boshlovchi bo'lim**: Asosiy xususiyat oqimi — Onlayn buyurtma

```mermaid
flowchart LR
  C(["Customer login api4"]) --> CAT["Catalog"]
  CAT --> CRT["Cart"]
  CRT --> SUB["POST /api4/order/create"]
  SUB --> ORD["Order STATUS=New"]
  ORD --> PAY{"Pay now?"}
  PAY -->|yes| RDR[("Redirect to provider")]
  RDR --> CB["Callback verify"]
  CB --> AP(["Mark paid"])

  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000

  class C,CAT,CRT,SUB,ORD,PAY,CB action
  class RDR external
  class AP success
```

## 13. Status mashinasi {#d-13}

- **Turi**: `state`
- **Manba sahifa**: [modules/orders](/docs/modules/orders)
- **Boshlovchi bo'lim**: Status mashinasi

```mermaid
stateDiagram-v2
  [*] --> Draft
  Draft --> New
  New --> Reserved
  Reserved --> Loaded
  Loaded --> Delivered
  Delivered --> Paid
  Paid --> Closed
  New --> Cancelled
  Reserved --> Cancelled
  Delivered --> Defect
  Defect --> Returned
  Returned --> Closed
  Cancelled --> [*]
  Closed --> [*]
  note right of Closed
    SUB_STATUS carries fine-grained reasons
    (e.g. "awaiting cashier").
  end note
```

## 14. Asosiy xususiyat oqimi — Buyurtma yaratish {#d-14}

- **Turi**: `sequence`
- **Manba sahifa**: [modules/orders](/docs/modules/orders)
- **Boshlovchi bo'lim**: Asosiy xususiyat oqimi — Buyurtma yaratish

```mermaid
sequenceDiagram
  participant A as Agent
  participant API as api3
  participant DB as MySQL
  participant Q as Queue
  A->>API: POST /api3/order/create
  API->>DB: validate client / limit / stock
  alt valid
    API->>DB: Insert Order STATUS=New
    API->>Q: enqueue StockReserveJob
    API-->>A: success
  else invalid
    API-->>A: error code
  end
```

## 15. Asosiy xususiyat oqimi — Tashrif va GPS {#d-15}

- **Turi**: `flowchart`
- **Manba sahifa**: [modules/agents](/docs/modules/agents)
- **Boshlovchi bo'lim**: Asosiy xususiyat oqimi — Tashrif va GPS

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

## 16. Asosiy xususiyat oqimi — Defekt va Qaytarish {#d-16}

- **Turi**: `flowchart`
- **Manba sahifa**: [modules/stock](/docs/modules/stock)
- **Boshlovchi bo'lim**: Asosiy xususiyat oqimi — Defekt va Qaytarish

```mermaid
flowchart LR
  D(["Delivery"]) --> CHK{"All lines accepted (no defect)?"}
  CHK -->|yes| OK["STATUS=Delivered"]
  CHK -->|no| DEF["Defect rows"]
  DEF --> RTS["Return-to-stock job"]
  RTS --> RPT["Defect KPI"]
classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
classDef approval fill:#fef3c7,stroke:#92400e,color:#000
classDef success  fill:#dcfce7,stroke:#166534,color:#000
classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
classDef external fill:#f3f4f6,stroke:#374151,color:#000
classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
class D,DEF,RTS,RPT action
class OK success
```

