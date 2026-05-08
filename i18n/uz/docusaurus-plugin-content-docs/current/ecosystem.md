---
sidebar_position: 2
title: Ekotizim
audience: Jamoaning barcha a'zolari
summary: Uchta sherik loyiha (sd-cs HQ, sd-main diler CRM, sd-billing obunalar) va ular bir-biriga qanday bog'liqligi. Har qanday chuqurroq bo'limdan oldin shuni o'qing.
topics: [ecosystem, three-projects, sd-cs, sd-main, sd-billing, dependency]
---

# SalesDoctor ekotizimi

SalesDoctor platformasini birgalikda tashkil etuvchi **uchta sherik loyiha**
mavjud — ular `~/projects/salesdoctor/` ostida joylashgan:

```
sd-cs   ─►   sd-main   ─►   sd-billing
HQ            Diler CRM       Obunalar / litsenziyalar
```

| Loyiha | Roli | Auditoriya |
|---------|------|----------|
| **[`sd-cs`](#sd-cs)** | Bosh ofis / "Country Sales 3" | Ko'p dilerlarni konsolidatsiya qiluvchi brend egasi |
| **[`sd-main`](#sd-main)** | Diler CRM | Har bir dilerning kundalik operatsion tizimi |
| **[`sd-billing`](#sd-billing)** | Obunalar, litsenziyalash, to'lovlar | Diler hisoblarini boshqaruvchi platforma vendori |

Yuqoridagi strelkalar **iste'molchidan ishlab chiqaruvchiga** yo'naltirilgan
— ya'ni har bir strelka "o'qiydi" degan ma'noni anglatadi, "yuboradi" emas.
Ish vaqtidagi ma'lumotlar oqimi yo'nalishi litsenziya yuborish / status ping
larida strelkaga teskari bo'ladi, shuning uchun quyidagi Mermaid diagrammasi
ikkala munosabatni ham aniq ko'rsatadi:

- **`sd-cs`** HQ da joylashgan. U konsolidatsiyalangan hisobotlar yaratish
  uchun ko'plab `sd-main` ma'lumotlar bazalariga **o'qish** ulanishlarini ochadi.
- **`sd-main`** dilerning kundalik operatsiyalarining yozuv tizimi
  hisoblanadi. Har bir dilerning o'z `sd-main` instansi bor va o'z MySQL
  sxemasi (prefiks `d0_`) bilan ishlaydi.
- **`sd-billing`** har bir `sd-main` va `sd-cs` ning yuqorisida turadi. U
  litsenziya fayllarini yuboradi, telefon ma'lumotnomalarini sinxronlaydi,
  statusni so'roqlaydi va dilerga obuna uchun hisob-kitob yuboradi.
  `sd-main` va `sd-cs` Billing dan faqat litsenziya tekshiruvi uchun o'qiydi.

[FigJam doskasidagi](./architecture/diagrams.md) **Ekotizim** diagrammasiga
qarang.

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

## Loyihalararo integratsiya xaritasi

Uchta loyihani bir-biriga ulaydigan aniq endpoint lar, DB ulanishlar,
litsenziya fayli yo'llari va cron orqali yuborishlar. Bu "ular qanday
gaplashadi?" ko'rinishi — har qanday loyihalararo chegarani o'zgartirayotganda
shu yerdan boshlang.

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

Har bir endpoint bo'yicha batafsil protokol uchun
[sd-billing integratsiyasi](./sd-billing/integration.md) va
[sd-cs ↔ sd-main integratsiyasi](./sd-cs/sd-main-integration.md) ga qarang.

## Loyiha bo'yicha asosiy xususiyatlar katalogi

Har bir loyihaning asosiy imkoniyat sohalari. Buni manfaatdor tomonlar uchun
30 soniyalik kirish sifatida ishlating; chuqurroq ma'lumot uchun modul
sahifalariga o'ting.

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

## sd-cs {#sd-cs}

**Country Sales 3** ilovasi — Yii 1.x, ikkita MySQL ulanish (o'zining
`cs_*` sxemasi + har bir dilerning `d0_*` DB siga almashtiriladigan
`dealer` ulanish), konsolidatsiyalangan hisobotlar va pivotlarga
yo'naltirilgan.

[sd-cs bo'limi](./sd-cs/overview.md) ga qarang.

## sd-main {#sd-main}

Diler CRM — saytning katta qismi sd-main haqida. Quyidagilarga qarang:
[Arxitektura](./architecture/overview.md),
[Modullar ma'lumotnomasi](./modules/overview.md) va
[API ma'lumotnomasi](./api/overview.md).

## sd-billing {#sd-billing}

Platforma vendorining obuna hisob-kitob tizimi — Yii 1.1.15, MySQL,
Docker, distribyutorlar, dilerlar, paketlar, obunalar, to'lovlar (Click /
Payme / Paynet / MBANK / P2P), settlement, dunning ni qamrab oluvchi
13 modul. [sd-billing bo'limi](./sd-billing/overview.md) ga qarang.

## Boshqa papkalar

`sd-components/` (Vue + Vuetify UI kutubxonasi) va `manager-ai/` (bo'sh
AI yordamchisi karkasi) uchta asosiy loyiha yonida joylashgan. Ular
sherik mahsulotlar emas — ularni ichki kutubxonalar / kelajakdagi ish
sifatida qarang. [sd-components yozuvlari](./sd-cs/sd-components.md) ga
qarang.
