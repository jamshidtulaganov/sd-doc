---
sidebar_position: 3
title: clients
audience: Backend engineers, QA, PM
summary: Mijozlar (do'kon/chakana) bazasi, shartnomalar, segmentlar, qarz tasvirlari, geo koordinatalar va marshrut a'zoligi.
topics: [clients, crm, b2b, route, geofence]
---

# `clients` moduli

sd-main da **mijozlar bazasi** ni boshqaradi: B2B do'konlari, chakana sotuvchilar, HoReCa, shuningdek qo'shimcha soha obyektlari — shartnomalar, segmentlar, qarz, geo joylashuv va marshrut a'zoligi.

## Asosiy xususiyatlar

| Xususiyat | Nima qiladi | Egasi rol(lar) |
|---------|--------------|---------------|
| Mijoz CRUD | Mijoz yozuvlarini yaratish / tahrirlash / arxivlash | 1 / 2 / 5 / 9 |
| Dalada yaratilgan mijozlar (mobil) | Agent tashrif vaqtida yangi mijoz yuboradi; yozuv *Pending* ga tushadi | 4 |
| Mijozni tasdiqlash | Menejer kutilayotgan yozuvlarni ko'rib chiqadi; tasdiqlash / tahrirlash / rad etish | 1 / 2 / 9 |
| Kategoriyalar va segmentlar | Mijozlarni savdo segmenti bo'yicha tartiblash; narx turi va chegirmaga ta'sir qiladi | 1 / 9 |
| Shartnomalar | Mijoz bo'yicha ixtiyoriy tijoriy shartnomalar (shartlar, to'lov kunlari) | 1 / 9 |
| Geo koordinatalari | Har bir mijozda `LAT` / `LNG`; `gps` tomonidan geofencing uchun ishlatiladi | 1 / 4 |
| Marshrut a'zoligi | Mijozlar agentlarga tayinlangan marshrutlarga guruhlanadi | 8 / 9 |
| Qarz tasviri | Hisobotlarda ko'rsatiladigan hisoblangan qarzlar yoshi | 6 / 9 |
| Paket import | Migratsiya uchun CSV / Excel import | 1 |
| 1C / Faktura.uz round-trip | Tashqi EDI uchun `XML_ID` + `INN` | tizim |

## Papka

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

## Asosiy entitylar

| Entity | Model | Izohlar |
|--------|-------|-------|
| Mijoz | `Client` | Aktiv do'konlar/mijozlar |
| Kutilayotgan mijoz | `ClientPending` | Dalada yaratilgan, tasdiqlash kutilmoqda |
| Mijoz kategoriyasi | `ClientCategory` | Narxlash darajasi / segmentatsiya |
| Shartnoma | `ContractClient` | Tijoriy shartnoma |
| Marshrut | `Route`, `RouteClient` | Agent marshrutlari |
| Qarz tasviri | `ClientDebt` | Hisoblangan yoshi |

## Tasdiqlash workflow'i

[FigJam · sd-main · Feature Flows](https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU) ichida **Feature · Client Approval** ga qarang.

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

| Endpoint | Maqsad |
|----------|---------|
| `GET /api3/client/list` | Marshrut mijozlarini mobilga sinxronlash |
| `POST /api3/client/create` | Dalada yaratilgan mijozlar (kutilayotgan) |
| `GET /api4/client/list` | B2B portal ro'yxati |

## Ruxsatlar

| Amal | Rollar |
|--------|-------|
| Yaratish | 1 / 2 / 4 (faqat kutilayotgan) / 5 |
| Tasdiqlash | 1 / 2 / 9 |
| Tahrirlash | 1 / 2 / 5 / 9 |
| Arxivlash | 1 / 2 |

## Shuningdek qarang

- [`agents`](./agents.md) (marshrut tayinlash)
- [`gps`](./gps.md) (geofencing)
- [`orders`](./orders.md) (mijozlar — xaridorlar)

## Workflow'lar

### Kirish nuqtalari

| Trigger | Controller / Action / Job | Izohlar |
|---|---|---|
| Web | `ApprovalController::actionIndex` | Menejer kutilayotgan mijozni ko'rib chiqish ro'yxatini ochadi |
| Web | `ApprovalController::actionGetData` | Sana oralig'i uchun `client_pending` qatorlarini oladi |
| Web | `ApprovalController::actionSave` | Kutilayotgan mijozlarni paket bilan tasdiqlaydi, `Client` yozuvlarini yaratadi |
| Web | `ApprovalController::actionDelete` | Kutilayotgan mijozlarni rad etadi (o'chiradi) |
| Web | `ViewController::actionAgentVisitsByWeek` | Agentni biriktirish / uzish jadvali UI |
| Web | `ViewController::actionAttachPriceType` | Mijozlarga narx turini tayinlash UI |
| Web | `ViewController::actionSalesCategories` | Savdo kategoriyasini tayinlash UI |
| Web API | `ApiController::getAgentVisitsByDay` | Tanlangan mijozlar uchun `Visiting` + `VisitingMonth` ni o'qiydi |
| Web API | `ApiController::setAgentVisitsByDay` | Tranzaksiyada `Visiting` + `VisitingMonth` yozuvlarini almashtiradi |
| Web API | `ApiController::getPriceType` | Tanlangan mijozlar uchun `Client.PRICE_TYPE_ID` ni o'qiydi |
| Web API | `ApiController::setPriceType` | Tanlangan mijozlar uchun `Client.PRICE_TYPE_ID` ni yozadi |
| Web API | `ApiController::getSalesCat` | Tanlangan mijozlar uchun `SalesCategory` qatorlarini o'qiydi |
| Web API | `ApiController::setSalesCat` | Tanlangan mijozlar uchun `SalesCategory` qatorlarini almashtiradi |
| Mobil (`api3`) | `api3/ClientController::actionAddClient` | Agent yangi mijoz yuboradi; `verify=true` bo'lganda `ClientPending` sifatida saqlanadi |
| Mobil (`api3`) | `api3/ClientController::actionPending` | Agent o'z kutilayotgan yuborishlarini so'raydi |

### Soha entitylari

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

### Workflow 1.1 — Dalada yaratilgan mijoz tasdiqlash kutmoqda

Agent mobilda yangi mijoz yaratadi. Agar distribyutor konfiguratsiyasida `client.verify = true` bo'lsa, yozuv menejer web back-office dan tasdiqlamaguncha yoki rad etmaguncha `ClientPending` da ushlab turiladi.

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

### Workflow 1.2 — Agent tashrif jadvali biriktirish / uzish

Menejer agent-mijoz tashrif slotlarini tayinlaydi yoki olib tashlaydi (haftalik hafta kuni bo'yicha yoki oylik sana bo'yicha). Operatsiya to'liq almashtirish: mijoz uchun mavjud `Visiting` va `VisitingMonth` qatorlari tranzaksiya ichida o'chiriladi va keyin qayta-qo'shiladi.

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

### Workflow 1.3 — Narx turi va savdo kategoriyasini tayinlash

Menejer bir yoki bir nechta mijozga narx turlari yoki savdo kategoriyalarini paket bilan tayinlaydi. Ikkala operatsiya `ApiController` action'lari orqali bir xil shaklda ishlaydi: joriy qiymatlarni olish, UI da tahrirlash, so'ngra bitta tranzaksion yozish bilan saqlash.

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

### Modullar aro tutash nuqtalari

- O'qiydi: `agents.Agent` (tasdiqlashda User dan AGENT_ID ni olish; tashrif jadvalini agent bo'yicha filtrlash)
- O'qiydi: `agents.Visiting` / `VisitingMonth` (`AgentRouteController::actionGetClients` da jadvalni ko'rsatish)
- Yozadi: `agents.Visiting` / `VisitingMonth` (har bir `setAgentVisitsByDay` chaqiruvida almashtiriladi)
- Yozadi: `clients.SalesCategory` (har bir `setSalesCat` chaqiruvida almashtiriladi; tasdiqlash vaqtida ham yoziladi)
- Yozadi: `clients.ClientLog` (`ApprovalController::actionSave` davomida `visitDays` maydoni uchun audit yozuvi)
- API'lar: `api3/client/addClient` (mobil mijoz yaratish → `ClientPending`)
- API'lar: `api3/client/pending` (mobil agent o'z kutilayotgan yuborishlarini so'raydi)
- API'lar: `api4/client/sales-category-list` (B2B portal savdo kategoriyalarini o'qiydi)

### Tuzoqlar

- `ApprovalController::actionSave` `ClientPending` dan `Client` ga maydon qiymatlarini qattiq kodlangan atribut ro'yxatidan foydalanib nusxalaydi. Kelajakda qo'shilgan har qanday yangi `ClientPending` ustuni bu metoddagi `$attributes` massiviga ham qo'shilishi kerak, aks holda u tasdiqlashda jim tushib qoladi.
- `agentVisitsByDay/SetAction` to'liq o'chirib qayta-kiritish qiladi. Mijoz uchun bo'sh `weekdays` va bo'sh `byDate` bilan chaqirish hech qanday tasdiqlash so'ramasdan barcha tashrif tayinlovlarini olib tashlaydi.
- `Client.PRICE_TYPE_ID` va `Client.SALES_CAT` normallashtirilgan `sales_category` jadvaliga qo'shimcha `client` qatorida vergul bilan ajratilgan satrlar sifatida saqlanadi. Agar `sales_category` jadvali `Client.SALES_CAT` ni yangilamasdan yozilsa, ikkalasi sinxrondan chiqishi mumkin. `salesCat/SetAction` ikkalasini ham yangilaydi; to'g'ridan-to'g'ri DB tahrirlari yangilamasligi mumkin.
- `api3/ClientController::actionAddClient` yo'li `$_REQUEST['u'] === 'merch'` asosida ikki kod versiyasiga (`addClientVersion1` / `addClientVersion2`) bo'linadi. Faqat 1-versiya `ClientPending` ga yozadi; merch varianti (`addClientVersion2`) o'z oqimiga ega.
- `ApprovalController::actionDelete` `operation.clients.approval.delete` ruxsatini talab qiladi, bu tasdiqlash ruxsatidan (`operation.clients.approval`) farq qiladi. Tasdiqlash ruxsatiga ega bo'lib, o'chirishga ega bo'lmagan noto'g'ri sozlangan rollar yozuvlarni rad eta olmaydi.
