---
sidebar_position: 9
title: finans
audience: Backend engineers, QA, PM, Finance ops
summary: sd-main dagi moliyaviy buxgalteriya qatlami — P&L, agent P&L, pivot P&L, kassa o'tkazmalari, sarf-xarajatlarni kuzatish.
topics: [finance, pnl, cashbox, transfer, consumption, expense]
---

# `finans` moduli

sd-main uchun moliyaviy buxgalteriya qatlami. Biznesning pul tomonini birlashtiradi: P&L, agent P&L, kassa harakatlari, xarajatlar.

## Asosiy xususiyatlar

| Xususiyat | Nima qiladi | Egasi rol(lar) |
|---------|--------------|---------------|
| Davr bo'yicha P&L | Davr bo'yicha daromad / xarajat / marja | 1 / 9 / Moliya |
| Pivot P&L | Slice-and-dice P&L | 1 / 9 / Moliya |
| Agent P&L | Agent bo'yicha foydalilik | 1 / 8 / 9 |
| Kassa siljishi | Kassalar o'rtasida pulni ko'chirish (masalan, agent → asosiy) | 6 / Moliya |
| To'lovni ko'chirish | To'lovni boshqa kassa / buyurtmaga qayta tayinlash | 1 / 6 |
| Sarf / xarajatni kuzatish | Byudjetga nisbatan operatsion xarajatlar | 1 / Moliya |

## Papka

```
protected/modules/finans/
└── controllers/
    ├── PnlController.php
    ├── PivotPnlController.php
    ├── AgentPnlController.php
    ├── CashboxDisplacementController.php
    ├── PaymentTransferController.php
    └── ConsumptionController.php
```

## Shuningdek qarang

- [`pay`](./payment.md) — to'lovni qayd etish
- [`payment`](./payment.md) — to'lovni tasdiqlash workflow'i

## Workflow'lar

### Kirish nuqtalari

| Trigger | Controller / Action / Job | Izohlar |
|---|---|---|
| Web — agent P&L gridi | `AgentPnlController::actionIndex` | Agent bo'yicha P&L ko'rinishi, filial-bo'ylab PnL'dan ajratilgan |
| Web | `CashboxDisplacementController::actionIndex` | Kassa-siljish ro'yxati ko'rinishini render qiladi |
| Web (GET) | `CashboxDisplacementController::actionGetDisplacement` | Filtrlangan siljish yozuvlarini JSON sifatida qaytaradi |
| Web (POST) | `CashboxDisplacementController::actionSave` | Yangi kassa siljishi + juftlangan Consumption qatorlarini yaratadi |
| Web (GET) | `CashboxDisplacementController::actionCancelDisplacement` | `STATUS=2` ni belgilaydi, juftlangan Consumption qatorlarini o'chiradi |
| Web (POST) | `PaymentTransferController::actionCreate` | Filiallar aro to'lov o'tkazmasi hujjati + debet Consumption yaratadi |
| Web (POST) | `PaymentTransferController::actionChangeStatus` | PaymentTransfer statusini oldinga suradi; ACCEPTED bo'lganda ClientTransaction yoki Consumption yozadi |
| Web — pivot P&L gridi | `PivotPnlController::actionIndex` | Cross-tab P&L pivot ko'rinishi |
| Web (POST) | `ConsumptionController::actionIndex` (POST tarmog'i) | Consumption xarajat qatorini qo'shadi, tahrirlaydi yoki o'chiradi |
| Web (POST) | `ConsumptionController::actionCredit` (POST tarmog'i) | Kredit (daromad) Consumption qatorini qo'shadi, tahrirlaydi yoki o'chiradi |
| Web | `PnlController::actionIndex` | `Finans::pnlTempTable` orqali `pnl` vaqtinchalik jadvalini quradi, P&L ko'rinishiga birlashtiradi |

---

### Soha entitylari

```mermaid
erDiagram
    CashboxDisplacement {
        int ID PK
        int CB_FROM FK
        int CB_TO FK
        decimal SUMMA
        int TO_CURRENCY FK
        string CURRENCY FK
        decimal CO_SUMMA
        decimal RATE
        tinyint STATUS
        datetime DATE
    }
    PaymentTransfer {
        int PAYMENT_TRANSFER_ID PK
        int DOCUMENT_ID
        tinyint OPERATION_ID
        int FILIAL_ID FK
        int CURRENCY_ID FK
        decimal SUMMA
        tinyint STATUS
        string COMMENT
    }
    Consumption {
        int ID PK
        int CAT_PARENT FK
        int CAT_CHILD FK
        decimal SUMMA
        int CURRENCY FK
        int CASHBOX FK
        tinyint TYPE
        tinyint TRANS_TYPE
        int IDEN
        datetime DATE
        tinyint EXCLUDE_PNL
    }
    ConsumptionParent {
        int ID PK
        string NAME
        string XML_ID
        tinyint SYSTEM
    }
    ConsumptionChild {
        int ID PK
        int PARENT FK
        string NAME
        string XML_ID
        tinyint SYSTEM
    }
    Cashbox {
        int ID PK
        string NAME
        int KASSIR FK
        string ACTIVE
    }
    ClientTransaction {
        int CLIENT_TRANS_ID PK
        int CLIENT_ID FK
        int CASHBOX FK
        int CURRENCY FK
        decimal SUMMA
        tinyint TRANS_TYPE
        tinyint TYPE
        datetime DATE
    }

    CashboxDisplacement ||--|| Cashbox : "CB_FROM"
    CashboxDisplacement ||--|| Cashbox : "CB_TO"
    CashboxDisplacement ||--o{ Consumption : "IDEN / TRANS_TYPE=2"
    PaymentTransfer ||--o{ Consumption : "IDEN / TRANS_TYPE=4"
    Consumption }o--|| ConsumptionParent : "CAT_PARENT"
    Consumption }o--|| ConsumptionChild : "CAT_CHILD"
    Consumption }o--|| Cashbox : "CASHBOX"
    ConsumptionChild }o--|| ConsumptionParent : "PARENT"
```

---

### Workflow 1.1 — Kassa siljishi (kassalar o'rtasida ichki ko'chirish)

Kassir yoki moliya menejeri bir filial ichida bir kassadan boshqasiga mablag'larni ko'chiradi. Kontroller `cashbox_displacement` yozuvini va ikkita juftlangan `consumption` qatorini yozadi — manba kassadan debet (TYPE=0) va manzil kassaga kredit (TYPE=1) — bularning hammasi bitta DB tranzaksiyasida. Bekor qilish ikkala consumption qatorini o'chiradi va siljishni STATUS=2 deb belgilaydi.

```mermaid
sequenceDiagram
    participant Web
    participant CashboxDisplacementController
    participant DB

    Web->>CashboxDisplacementController: POST /finans/cashboxDisplacement/save
    CashboxDisplacementController->>DB: SELECT Cashbox WHERE ID=transferFrom
    DB-->>CashboxDisplacementController: Cashbox record
    CashboxDisplacementController->>DB: SELECT Cashbox WHERE ID=transferTo
    DB-->>CashboxDisplacementController: Cashbox record
    CashboxDisplacementController->>DB: BEGIN TRANSACTION
    CashboxDisplacementController->>DB: INSERT cashbox_displacement
    DB-->>CashboxDisplacementController: new displacement ID
    CashboxDisplacementController->>DB: INSERT consumption TYPE=0 TRANS_TYPE=2 CASHBOX=CB_FROM
    CashboxDisplacementController->>DB: INSERT consumption TYPE=1 TRANS_TYPE=2 CASHBOX=CB_TO
    CashboxDisplacementController->>DB: COMMIT
    DB-->>CashboxDisplacementController: ok
    CashboxDisplacementController-->>Web: JSON success
```

---

### Workflow 1.2 — Filiallar aro to'lov o'tkazmasi (yuborish → qabul qilish hayot davri)

Yuboruvchi filial boshqa filialga to'lov o'tkazmasini boshlaydi. Hujjat statuslar bo'ylab harakatlanadi (PENDING=2 → ACCEPTED=3 yoki REJECTED=4 / CANCELLED=5). Yaratishda yuboruvchining kassa balansi `consumption` (TRANS_TYPE=4, TYPE=0) orqali debet qilinadi. Qabul qiluvchi tomonidan qabul qilinganda mablag'lar `ClientTransaction` (TRANS_TYPE=3, agar `trans=1` bo'lsa) yoki `consumption` (TYPE=1, TRANS_TYPE=4) sifatida kredit qilinadi. Rad etish yoki bekor qilish debet consumption qatorlarini o'chiradi.

```mermaid
flowchart TD
    A[Web: POST /finans/paymentTransfer/create] --> B[PaymentTransferController::actionCreate]
    B --> C{Currency + Filial active?}
    C -- No --> ERR1[fail: reload_page]
    C -- Yes --> D{Cashbox balance sufficient?}
    D -- No --> ERR2[fail: insufficient funds]
    D -- Yes --> E[INSERT payment_transfer STATUS=2 OPERATION_ID=1 sender filial]
    E --> F[INSERT consumption TYPE=0 TRANS_TYPE=4 per payment item]
    F --> G[switchFilialAndSaveTransfer: INSERT payment_transfer STATUS=1 OPERATION_ID=2 receiver filial]
    G --> H[COMMIT - DOCUMENT_ID returned]

    H --> I[Web: POST /finans/paymentTransfer/changeStatus]
    I --> J{status requested?}
    J -- CANCELLED=5 or REJECTED=4 --> K[DELETE consumption WHERE IDEN=DOCUMENT_ID AND TRANS_TYPE=4]
    K --> L[UPDATE payment_transfer STATUS=4 or 5]
    J -- ACCEPTED=3 --> M{trans=1?}
    M -- Yes --> N[INSERT client_transaction TRANS_TYPE=3 then ClientFinans::correct]
    M -- No --> O[INSERT consumption TYPE=1 TRANS_TYPE=4]
    N --> P[UPDATE payment_transfer STATUS=3]
    O --> P
    L --> Q[COMMIT]
    P --> Q
```

---

### Workflow 1.3 — Xarajat / daromad qaydi va P&L ga kiritish

Moliya xodimlari operatsion xarajatlarni (TYPE=0) yoki kassa daromadini (TYPE=1) `ConsumptionController` orqali to'g'ridan-to'g'ri qayd etadi. Har bir qator fond (`ConsumptionParent`) va kategoriya (`ConsumptionChild`) bilan teglanadi. `PnlController::actionIndex` `Finans::pnlTempTable` savdo ma'lumotlaridan `pnl` vaqtinchalik jadvalini to'ldirgandan keyin operatsion xarajatlar va boshqa daromadlarni P&L jamilariga qo'shish uchun `consumption` ni WHERE `TRANS_TYPE=1 AND EXCLUDE_PNL=0` ni o'qiydi.

```mermaid
sequenceDiagram
    participant Web
    participant ConsumptionController
    participant PnlController
    participant DB

    Web->>ConsumptionController: POST /finans/consumption/index (name=consum_add)
    ConsumptionController->>DB: CHECK Closed::check_update finans date
    DB-->>ConsumptionController: period open
    ConsumptionController->>DB: INSERT consumption TYPE=0 TRANS_TYPE=1 EXCLUDE_PNL=0
    DB-->>ConsumptionController: saved ID
    ConsumptionController->>DB: TelegramReport::newConsumption async notify
    ConsumptionController-->>Web: redirect GET

    Web->>PnlController: GET /finans/pnl/index with date range
    PnlController->>DB: Finans::pnlTempTable creates pnl temp table
    DB-->>PnlController: pnl temp table ready
    PnlController->>DB: SELECT SUM SUMMA FROM consumption TRANS_TYPE=1 TYPE=0 EXCLUDE_PNL=0
    DB-->>PnlController: rasxod total
    PnlController->>DB: SELECT SUM SUMMA FROM consumption TRANS_TYPE=1 TYPE=1 EXCLUDE_PNL=0
    DB-->>PnlController: prixod total
    PnlController->>DB: SELECT SUM SUMMA FROM client_transaction TRANS_TYPE=8 TYPE=1
    DB-->>PnlController: bad_debt total
    PnlController-->>Web: render pnl/index with aggregated P&L result
```

---

### Modullar aro tutash nuqtalari

- O'qiydi: `pay.ClientTransaction` (TRANS_TYPE IN(3,4,5) — `CashboxDisplacementController::getCashboxBalance` va `PaymentTransferController::getCashboxBalance` da kassa balansini hisoblash uchun ishlatiladi)
- Yozadi: `pay.ClientTransaction` (`PaymentTransferController::savePaymentAsTransaction` orqali to'lov o'tkazmasi `trans=1` bayrog'i bilan qabul qilinganda INSERT TRANS_TYPE=3, TYPE=1)
- Yozadi: `pay.ClientFinans` (o'tkazma qabul qilingach ClientTransaction yozilgandan keyin `ClientFinans::correct` chaqiriladi)
- O'qiydi: `settings.Closed` (`ConsumptionController` da har qanday xarajat yozuvidan oldin `Closed::model()->check_update('finans', date)` orqali davr-qulfi tekshiruvi)
- O'qiydi: `warehouse.LotDistribution` / `orders.Order` (`ServerSettings::enableLotManagement()` true bo'lganda `Finans::pnlTempTable` tomonidan ishlatiladi)

---

### Tuzoqlar

- `CashboxDisplacement` va `PaymentTransfer` ikkalasi ham `BaseFilial` ni kengaytiradi, shuning uchun ularning jadval nomlari runtimeda filial-prefiksli. `PaymentTransferController::actionChangeStatus` dagi filiallar aro so'rovlar qabul qiluvchining `payment_transfer` jadvalini so'rashdan oldin `BaseFilial::setFilial($prefix)` orqali aktiv filial kontekstini almashtiradi — qaytib o'zgartirmaslik sessiya filial kontekstini buzishi mumkin.
- `Consumption.TRANS_TYPE` P&L uchun load-bearing: faqat `TRANS_TYPE=1` qatorlari `PnlController` ga oqadi. Siljish (`TRANS_TYPE=2`) va to'lov-o'tkazma (`TRANS_TYPE=4`) tomonidan yozilgan qatorlar P&L birlashtirishidan jim ravishda chiqarib tashlanadi.
- `Consumption.EXCLUDE_PNL=1` qo'lda override bo'lib, `TRANS_TYPE=1` bo'lsa ham qatorni P&L'dan olib tashlaydi. U `ConsumptionController` da add va edit yo'llarining ikkalasida ham belgilanishi mumkin.
- `PaymentTransferController::actionChangeStatus` bir xil HTTP so'rovida ham yuboruvchi, ham qabul qiluvchi filial DB kontekstlariga yozadi. DB tranzaksiyasi (`$safeTrans`) faqat joriy filial ulanishini qamrab oladi; `switchFilialAndSaveTransfer` dagi remote-filial insert tranzaksiyadan tashqarida va muvaffaqiyatsizlikda rollback qilinmaydi.
- `ConsumptionController::actionCredit` (kassa daromadi, TYPE=1) `TelegramReport::newConsumption` ni **chaqirmaydi**; faqat xarajat yozuvlari (`actionIndex` da TYPE=0) Telegram bildirishnomasini ishga tushiradi.
- P&L hisoblash `ServerSettings::enableLotManagement()` orqali bloklangan ikki kod yo'liga ega. Yoqilganda, `Finans::pnlTempTable` `LotDistribution` asosidagi SQL'ni ishlatadi; o'chirilganda, eski `Finans::pnlSql` ga qaytadi. Ikkalasi ham bir xil `pnl` vaqtinchalik jadvalini to'ldiradi, ammo bir xil ma'lumotlarda **turli P&L raqamlarini** ishlab chiqaradi. Tarixiy taqqoslashlarga ishonishdan oldin maqsadli instans qaysi rejimda ishlayotganini tekshiring.
- `PaymentTransferController::actionChangeStatus` `allowedStatus` ni ikki marta ishlatadi — birini yuboruvchining filial kontekstida (~229–231 qatorlar), birini `BaseFilial::setFilial` dan keyin qabul qiluvchining filialida (~293–297 qatorlar). STATUS yangilanishi va orasidagi Consumption o'chirishlari (~237–247 qatorlar) ikkinchi himoyadan **oldin** bajariladi, shuning uchun qabul qiluvchi tomonidagi tekshiruv muvaffaqiyatsiz bo'lsa, qisman mutatsiya qolishi mumkin. Ikki yarmini atomik bo'lmagan deb hisoblang.
