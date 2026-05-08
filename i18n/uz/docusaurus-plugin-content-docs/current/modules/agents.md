---
sidebar_position: 4
title: agents
audience: Backend engineers, QA, PM
summary: Savdo agentlari (dala kuchi) — profillari, rejalari, KPI'lari, transport vositalari, kredit va chegirma cheklovlari.
topics: [agents, kpi, plans, limits, mobile, route]
---

# `agents` moduli

Savdo agentlari (dala kuchi) plus ularning rejalari, KPI'lari, transport vositalari va cheklovlari. Web admin dala kuchi qanday tashkil etilganligini boshqaradi; agentlarning o'zlari mobil ilovadan api3 orqali ishlaydi.

## Asosiy xususiyatlar

| Xususiyat | Nima qiladi | Egasi rol(lar) |
|---------|--------------|---------------|
| Agent CRUD | Agentlarni yaratish / tahrirlash / o'chirish | 1 / 2 / 9 |
| Agent sozlamalari | Agent bo'yicha togglar (naqd yig'ish, chegirma chegaralari va boshqalar) | 1 / 9 |
| Oylik reja | Davr bo'yicha maqsadli hajm / soni | 1 / 9 |
| KPI v1 / v2 | Agent bo'yicha reja-haqiqat hisobotlari | 8 / 9 |
| Kredit chegarasi | Agent buyurtmada qabul qilishi mumkin bo'lgan maksimal qarz | 1 / 9 |
| Chegirma chegarasi | Agent qo'llashi mumkin bo'lgan maksimal chegirma | 1 / 9 |
| Transport tayinlash | Har bir agent `Car` ga bog'lanadi | 1 / 9 |
| Paket / to'plamlar | Agentlar sotishi mumkin bo'lgan oldindan belgilangan mahsulot to'plamlari | 1 / 9 |
| Marshrut tayinlash | Hafta kunlari marshrutlari mijozlarga moslashtirilgan | 8 / 9 |

## Papka

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

## Asosiy entitylar

| Entity | Model |
|--------|-------|
| Agent | `Agent` |
| Agent sozlamalari | `AgentSettings` |
| Agent rejasi | `AgentPlan` |
| Agent paketi | `AgentPaket` |
| Avtomobil | `Car` |
| KPI | turli `Kpi*` modellari |

## Rejalar va KPI

Agent rejalari oylik boshqariladi. `KpiController` haqiqiy va reja raqamlarini hisobot qiladi; `KpiNewController` qayta yozilgani — yangi loyihalar uni afzal ko'rishi kerak.

## Cheklovlar

`LimitController` kredit va chegirma chegaralarini majburiy qiladi. Cheklovlar **buyurtma yaratishda** va **tasdiqlashda** tekshiriladi. Har qanday chegaradan oshgan agent buyurtmani menejer-tasdiqlash holatiga majburlaydi.

## Mobil (api3)

Agent mobil ilovasi api3 ni chaqiradi:

- [`POST /api3/login/index`](../api/api-v3-mobile.md#login)
- [`POST /api3/visit/index`](../api/api-v3-mobile.md#visits)
- `GET /api3/agent/route` — bugungi mijozlar
- `GET /api3/kpi/index` — agentning o'z KPI plitkasi

## Asosiy xususiyat oqimi — Tashrif va GPS

[FigJam · sd-main · Feature Flows](https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU) ichida **Feature · Visit & GPS geofence** ga qarang.

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

## Ruxsatlar

| Amal | Rollar |
|--------|-------|
| Yaratish / tahrirlash | 1 / 2 / 9 |
| KPI ko'rish | 1 / 2 / 8 / 9 (4 uchun faqat o'ziniki) |
| Cheklov belgilash | 1 / 2 / 9 |

## Workflow'lar

### Kirish nuqtalari

| Trigger | Controller / Action / Job | Izohlar |
|---|---|---|
| Web (admin) | `AgentController::actionCreateAjax` | `Agent` + bog'langan `User` (rol 4) yaratadi; obuna chegaralarini majburiy qiladi |
| Web (admin) | `AgentController::actionUpdateAjax` | Agent profilini va `User` ma'lumotlarini yangilaydi |
| Web (admin) | `LimitController::actionEdit` | Mahsulot bo'yicha miqdor cheklovlarini `Warehouse` / `WarehouseDetail` ga saqlaydi |
| Web (admin) | `LimitController::actionChangeType` | Cheklovning `TYPE_LIMIT` ni almashtiradi (kunlik / oylik / 30-kunlik) |
| Web (admin) | `VisitingController::actionSaveOrder` | Agent uchun hafta kunlari marshrut tartibini `Visiting` ga saqlaydi |
| Web (admin) | `KpiNewController::actionSetting` | Davr uchun `Kpi` + `KpiTask` yozuvlarini yaratadi yoki yangilaydi |
| Web (admin) | `KpiNewController::actionTemplate` | `KpiTaskTemplate` ni yaratadi yoki yangilaydi (filiallarga ixtiyoriy ravishda nusxalanadi) |
| Mobil (api3) | `api3/KpiController::actionIndex` | Mobil ilovaga shu oygi KPI plitka ma'lumotlarini qaytaradi |
| Mobil (api3) | `api3/VisitController` | `Visiting` qatorlari orqali bugungi mijoz marshrutini qaytaradi |

---

### Soha entitylari

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

### Workflow 1.1 — Obuna tekshiruvi bilan agent yaratish

Admin yangi agent yaratganda, `AgentController::actionCreateAjax` `Agent` va uning bog'langan `User` hisobini saqlashdan oldin tenant obunasining agent turi (dala, van-selling yoki sotuvchi) bo'yicha chegarasini tekshiradi. Van-selling agentlari ham bu nuqtada maxsus ombor yaratadi yoki biriktiradi.

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

### Workflow 1.2 — Hafta kunlari marshrut tayinlash

Admin `VisitingController` orqali agentning hafta kunlari marshrutiga mijozlarni tayinlaydi. Kontroller mavjud `Visiting` qatorlarini kun bo'yicha guruhlangan holda o'qiydi, drag-and-drop bilan qayta tartiblashga ruxsat beradi va `SORT` va `WEEK_TYPE` qiymatlarini ma'lumotlar bazasiga qaytaradi. Mobil ilova keyinchalik `api3/VisitController` orqali bugungi mijozlarni o'qiydi.

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

### Workflow 1.3 — KPI v2 oylik reja tayinlash

Har oy admin agentlarni, davrni (oy/yil) va `KpiTaskTemplate` bo'yicha maqsadli qiymatlarni tanlaydi. `KpiNewController::actionSetting` har bir agent-davr uchun bitta `Kpi` qatori yaratadi (yoki mavjudini qayta ishlatadi) va child `KpiTask` qatorlarini upsert qiladi. Agar hisobda filiallar bo'lsa va shablon filiallar aro nusxalash uchun belgilangan bo'lsa, kontroller har bir filial prefiksini takrorlaydi va asosiy ma'lumotlar bazasiga qaytishdan oldin mirror yozuvni saqlaydi.

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

### Workflow 1.4 — Buyurtma vaqtida mahsulot-miqdor cheklovini majburiy qilish

Admin `LimitController` orqali ma'lum bir davrda agent har bir mahsulotning qancha birligini sotishi mumkinligini belgilaydi. Cheklov turi (kunlik `"1"`, oylik `"2"`, yoki rolling-30-kunlik `"3"`) `Warehouse.TYPE_LIMIT` da saqlanadi. Mobil ilova buyurtmani sinxronlaganda, `api3/OrderController` `WarehouseDetail::Sale` ni ishga tushiradi, u esa mos keluvchi `(AGENT_ID, PRODUCT_ID, STORE_ID)` qatori uchun qolgan miqdorni kamaytiradi. Agar miqdor manfiy bo'lib qolsa, savdo bloklanadi.

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

### Modullar aro tutash nuqtalari

- O'qiydi: `planning.Planning` (`api3/KpiController::version2` da iste'mol qilinadigan agent oylik jami)
- O'qiydi: `orders.Order` / `orders.OrderDetail` (KPI hisoblashda haqiqat va reja taqqoslash)
- Yozadi: `warehouse.Warehouse` / `warehouse.WarehouseDetail` (`LimitController` tomonidan yoziladigan cheklov chelaklari)
- Yozadi: `users.User` (`AgentController` da har bir `Agent` saqlash bilan birga rol-4 user yozuvi yaratiladi/yangilanadi)
- API'lar: `api3/kpi/index` — agentning o'z oylik KPI plitkasi
- API'lar: `api3/visit/*` — `Visiting` qatorlaridan qurilgan bugungi tartiblangan mijoz marshruti

---

### Tuzoqlar

- `AgentController::actionIndex` darhol `/staff/view/agent` ga yo'naltiradi; agent ro'yxati bu yerda emas, balki `staff` moduli tomonidan render qilinadi.
- `KpiNewController` jamoani oddiy vergul bilan ajratilgan satr sifatida `Kpi.TEAM` da saqlaydi, foreign-key join jadvali emas, shuning uchun paket o'chirishlar satr-mos kelish mantiqini talab qiladi.
- `Warehouse.TYPE_LIMIT` qiymatlari `"1"`, `"2"`, `"3"` enum himoyasisiz ko'rsatish yorliqlariga ("За день", "За месяц", "За 30 дней") aylantiriladi; noma'lum qiymatni uzatish uni xatosiz jim saqlaydi.
- `AgentPaket.SETTINGS` katta JSON blob (qoidalar bo'yicha 100 000 belgigacha) — u marshrut `follow_sequence` konfiguratsiyasini va boshqa ilova darajasidagi togglar saqlaydi; bir nechta ekrandan tahrirlashlar to'liq blobni o'qib-o'zgartirib-yozmasangiz, bir-birini bosib o'tadi.
- `KpiTaskTemplate` `ACTIVE = "N"` ni belgilash bilan soft-delete qiladi (`KpiNewController::actionDelete`); qattiq-o'chirish kodi izohga olingan, shuning uchun yetim `KpiTask` qatorlari to'planishi mumkin.
