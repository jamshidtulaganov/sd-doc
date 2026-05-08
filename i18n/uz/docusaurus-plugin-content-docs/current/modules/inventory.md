---
sidebar_position: 6
title: inventory
audience: Backend engineers, QA, PM
summary: Mobil shtrix-kod skanerlash va tizim zaxirasi bilan kelishtirish bilan jismoniy inventarizatsiya hisoblari (stocktake'lar).
topics: [inventory, stocktake, scan, reconciliation, barcode]
---

# `inventory` moduli

Mobil shtrix-kod skanerlash va tizim zaxirasi bilan kelishtirish bilan jismoniy inventarizatsiya hisoblari (stocktake'lar).

## Asosiy xususiyatlar

| Xususiyat | Nima qiladi | Egasi rol(lar) |
|---------|--------------|---------------|
| Inventarizatsiya hujjati yaratish | Yangi stocktake boshlash; `inventory_type` ni tanlash | 1 / 2 / 9 |
| Mijoz / ombor bo'yicha qamrov | Hujjatni ma'lum do'kon yoki ombor bilan cheklash | 1 / 9 |
| Mobil skanerlash | Operatorlar api3 orqali shtrix-kodlarni birma-bir skanerlaydi | 4 / ombor xodimi |
| Foto dalil | Shikastlangan yoki kam tovarlarning fotolarini biriktirish | 4 |
| Kelishtirish | Joriy `Stock` ga nisbatan delta'larni hisoblash | tizim |
| Tuzatishlar | Tasdiqlashda delta'lar zaxiraga tuzatish sifatida post qilinadi | 1 / 9 |
| Tarix | Hujjat bo'yicha tahrirlar va tasdiqlashlar tarixi | tizim |

## Papka

```
protected/modules/inventory/
├── controllers/
│   ├── AddController.php
│   ├── EditController.php
│   ├── DeleteController.php
│   ├── ListController.php
│   ├── HistoryController.php
│   ├── PhotoController.php
│   ├── ScanController.php
│   └── StatusController.php
└── views/
```

## Workflow

1. Menejer inventarizatsiya hujjatini yaratadi (`AddController`).
2. Operatorlar omborda mahsulotlarni `ScanController` (mobil, api3) orqali skanerlaydi.
3. Tizim joriy zaxiraga nisbatan delta'larni hisoblaydi.
4. Menejer tasdiqlaydi; delta'lar `stock` ga tuzatish sifatida post qilinadi.

## Asosiy xususiyat oqimi — Stocktake

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

## Fotolar

`PhotoController` qator bo'yicha foto dalilni biriktiradi (masalan, shikastlangan tovarlar). `upload/inventory/<doc_id>/` ostida saqlanadi.

## Ruxsatlar

| Amal | Rollar |
|--------|-------|
| Yaratish | 1 / 2 / 9 |
| Skanerlash (mobil) | 4 / ombor xodimi |
| Tasdiqlash | 1 / 2 / 9 |

## Workflow'lar

### Kirish nuqtalari

| Trigger | Controller / Action / Job | Izohlar |
|---|---|---|
| Web (menejer) | `AddController::actionIndex` | Yagona inventarizatsiya elementi yaratadi; `InventoryType` va ixtiyoriy `Client` ni tasdiqlaydi |
| Web (menejer, paket) | `AddController::actionBatch` | Import qilingan ro'yxatdan elementlarni paket bilan yaratadi |
| Web (menejer) | `EditController::actionInventory` | Element metama'lumotlarini tahrirlaydi (nom, seriya, tur) |
| Web (menejer) | `EditController::actionHistory` | Elementni boshqa mijozga qayta-biriktiradi / qayta-tayinlaydi; eski `InventoryHistory` qatorini yopadi |
| Web (menejer) | `StatusController::actionEdit` | Yagona-element status o'tishi; `InventoryService::CAN_CHANGE_STATUS_TO` orqali ruxsat etilgan o'tishlarni himoya qiladi |
| Web (menejer, paket) | `StatusController::actionBulkEdit` | Element ID'lari to'plami bo'ylab paket status o'zgarishi |
| Web (menejer) | `PhotoController::actionAdd` | Elementga dalil fotosini biriktiradi (maks 3, maks 5 MB) |
| Mobil (agent) | `api4/InventoryController::actionScanning` | Mijoz joyida element uchun shtrix-kod/QR skanerlash voqeasini qayd etadi |
| Mobil (agent) | `api4/InventoryController::actionScanningPhoto` | Skanerlash voqeasi fotosini yuklaydi (`InventoryCheckPhoto`) |
| Web (hisobot) | `ScanController::actionList` | Skanerlash voqeasi jurnalini oladi (`inventory_check` + `inventory_history` + `inventory_check_photo` ni birlashtiradi) |
| Web (hisobot) | `HistoryController::actionData` | Barcha elementlar bo'ylab to'liq tayinlash tarixini oladi |

### Soha entitylari

```mermaid
erDiagram
    Inventory {
        string INVENTORY_ID PK
        string INV_TYPE_ID FK
        string NAME
        string SERIAL_NUM
        string INV_NO
        string DATE_PRODUCTION
        string ACTIVE
        string XML_ID
    }
    InventoryType {
        string INV_TYPE_ID PK
        string NAME
    }
    InventoryHistory {
        string INVENTORY_HIST_ID PK
        string INVENTORY_ID FK
        string CLIENT_ID FK
        string STATUS
        string CONDITION
        string DATE_FROM
        string DATE_TO
        string ACTIVE
    }
    InventoryCheck {
        int ID PK
        string INVENTORY_ID FK
        string INVENTORY_HIST_ID FK
        string CLIENT_ID
        double LAT
        double LON
        string SCANNED_AT
    }
    InventoryCheckPhoto {
        int ID PK
        int INVENTORY_CHECK_ID FK
        string FILE_NAME
    }
    PhotoInventory {
        int ID PK
        string INV_ID FK
        string PHOTO
    }

    Inventory ||--o{ InventoryHistory : "has history rows"
    InventoryType ||--o{ Inventory : "classifies"
    Inventory ||--o{ InventoryCheck : "scanned as"
    InventoryHistory ||--o{ InventoryCheck : "active at scan time"
    InventoryCheck ||--o{ InventoryCheckPhoto : "has scan photos"
    Inventory ||--o{ PhotoInventory : "has item photos"
```

### Workflow 1.1 — Inventarizatsiya elementi hayot davri (yaratish va status o'tishlari)

Menejer `AddController::actionIndex` orqali jismoniy aktivni ro'yxatga oladi, u esa atomik ravishda `Inventory` qatorini va boshlang'ich `InventoryHistory` qatorini qo'shadi. Shu nuqtadan boshlab element nazorat qilinadigan statuslar to'plami bo'ylab harakatlanadi. Barcha o'tishlar `InventoryService::CAN_CHANGE_STATUS_TO` ga qarshi tasdiqlanadi; noqonuniy sakrashlar har qanday DB yozuvidan oldin rad etiladi.

```mermaid
stateDiagram-v2
    [*] --> Available : AddController insert inventory + history STATUS=1
    Available --> InUse : StatusController status=2 attach to client
    Available --> InRepair : StatusController status=3
    Available --> WrittenOff : StatusController status=4
    Available --> Deleted : StatusController status=5
    InUse --> Available : StatusController status=1 detach from client
    InUse --> InUse : StatusController status=2 reassign client
    InUse --> InRepair : StatusController status=3
    InUse --> Deleted : StatusController status=5
    InRepair --> Available : StatusController status=1
    InRepair --> InUse : StatusController status=2
    InRepair --> Deleted : StatusController status=5
    WrittenOff --> Available : StatusController status=1
    WrittenOff --> InRepair : StatusController status=3
    WrittenOff --> Deleted : StatusController status=5
    Deleted --> Available : StatusController status=1
    Deleted --> InUse : StatusController status=2
    Deleted --> InRepair : StatusController status=3
    Deleted --> WrittenOff : StatusController status=4
```

### Workflow 1.2 — Mobil skanerlash voqeasi (agent mijoz joyida QR/shtrix-kod skanerlaydi)

Daladagi agent `api4/InventoryController::actionScanning` ni ochadi. Endpoint elementni va mijozni tasdiqlaydi, joriy `InventoryHistory` qatorini aniqlaydi, `InventoryCheck` yozuvini saqlaydi (GPS koordinatalari bilan), biriktirilgan har qanday fotolarni `InventoryCheckPhoto` qatorlari sifatida saqlaydi va — agar agentning konfiguratsiyasida `visiting.inventory_qr_report` yoqilgan bo'lsa — mos keluvchi `Visit` ni tashrif buyurilgan deb belgilaydi. Web `ScanController::actionList` keyinchalik skanerlash voqeasi hisobotini ishlab chiqarish uchun `inventory_check`, `inventory_history` va `inventory_check_photo` ni birlashtiradi.

```mermaid
sequenceDiagram
    participant Mobile
    participant api4
    participant DB

    Mobile->>api4: POST api4/inventory/scanning {inventory_id, client_id, scanned_at, latitude, longitude, photos[]}
    api4->>DB: SELECT inventory WHERE INVENTORY_ID=:id
    DB-->>api4: Inventory row (or 404)
    api4->>DB: SELECT client WHERE CLIENT_ID=:id
    DB-->>api4: Client row (or 404)
    api4->>DB: SELECT inventory_history WHERE INVENTORY_ID=:id AND active
    DB-->>api4: Current InventoryHistory row
    api4->>DB: INSERT inventory_check (INVENTORY_ID, CLIENT_ID, INVENTORY_HIST_ID, SCANNED_AT, LAT, LON)
    DB-->>api4: new check ID
    api4->>DB: INSERT inventory_check_photo per base64 image (INVENTORY_CHECK_ID, FILE_NAME)
    DB-->>api4: photo IDs
    api4->>DB: UPDATE visit SET VISITED=1, CHECK_IN_TIME, CHECK_OUT_TIME (only if agent config inventory_qr_report=true)
    DB-->>api4: ok
    api4-->>Mobile: {status:true, result:{id, photos[]}}
    Note over Mobile,DB: Web report: ScanController::actionList SELECT inventory_check JOIN inventory_history JOIN inventory_check_photo
```

### Modullar aro tutash nuqtalari

- O'qiydi: `client.Client` (`AddController::actionIndex`, `EditController::actionHistory`, `api4/InventoryController::actionScanning` da maqsadli mijozni tasdiqlash)
- O'qiydi: `visiting.Visiting` (`api4/InventoryController::actionList` da agentning mijozlar ro'yxatini aniqlash)
- Yozadi: `visiting.Visit` (`api4/InventoryController::actionScanning` ichida `inventory_qr_report` agent konfi yoqilganda tashrifni `VISITED=1` deb belgilash)
- API'lar: `api4/inventory/scanning`, `api4/inventory/scanningPhoto`, `api4/inventory/add`, `api4/inventory/edit`, `api4/inventory/list`

### Tuzoqlar

- `InventoryHistory` **soft-close** patternidan foydalanadi: status o'zgarganda, oldingi aktiv qatorga `ACTIVE='N'` va `DATE_TO=now` alohida `UPDATE` da belgilanadi, so'ng yangi qator qo'shiladi — status ustunining joyida yangilanishi yo'q. `ACTIVE='Y'` filtrini unutgan so'rovlar ikki nusxadagi joriy holatlarni ko'radi.
- `StatusController::actionEdit` yagona-element o'tishlari uchun `InventoryService::CAN_CHANGE_STATUS_TO` ni tekshiradi, lekin `StatusController::actionBulkEdit` `InventoryHistory::model()->statuses` ga qaytadi (eski instance-property massiv, status `5` ni o'z ichiga olmaydi). Ikki himoya sinxron emas.
- Soft-delete (`Inventory` qatorida `ACTIVE='N'`) `ServerSettings::enableInventoryDeletion()` orqasida bloklangan. Agar bayroq o'chirilgan bo'lsa, status `5` `InventoryHistory` ga yozilishi mumkin, ammo element `ListController::actionData` da ko'rinib turaveradi.
- `api3/InventoryController::actionSet` `InventoryService` factory'siz `Inventory` + `InventoryHistory` ni yaratuvchi eski mobil endpoint; u har doim `STATUS=2` va `DILER_ID='d0_1'` ni qattiq kodlaydi. Yangi ish uchun `api4` ni afzal ko'ring.
