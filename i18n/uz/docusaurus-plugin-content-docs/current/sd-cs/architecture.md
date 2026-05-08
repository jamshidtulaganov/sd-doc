---
sidebar_position: 4
title: Arxitektura (tasdiqlangan)
---

# sd-cs — Arxitektura (ishlaydigan koddan tasdiqlangan)

Ushbu diagrammalar joylashtirilgan sd-cs ning **haqiqiy** xatti-harakatini aks
ettiradi: ikkita MySQL sxemasi (boshqaruv + ombor) va omborning ichida har-tenant
**filial** prefiks sxemasi. `cs3_demo` / `b_demo` sxemalariga va `BaseModel` /
`V2Controller` kod yo'llariga qarshi tasdiqlangan.

> Vizual taksonomiya [Diagramma galereyasi](/docs/diagrams) standartiga
> amal qiladi (ko'k = action, sariq = approval, yashil = success, qizil =
> reject, kulrang = external, binafsha = cron).

## Ikki-DB ulanish xaritasi

`Yii::app()->db` `cs3_demo` ga (boshqaruv tekisligi, 23 jadval, prefiks `cs_`)
ulanadi. `Yii::app()->dealer` `b_demo` ga (operatsion ombor, ~1 684 jadval,
prefiks `d0_`) ulanadi. Ikkalasi ham `protected/config/db.php`da konfiguratsiya
qilinadi.

```mermaid
flowchart LR
  U[HQ foydalanuvchi] --> APP[sd-cs · Yii 1.1]
  APP -->|Yii::app->db| CS[(cs3_demo<br/>prefiks cs_<br/>~23 jadval)]
  APP -->|Yii::app->dealer| BD[(b_demo<br/>prefiks d0_<br/>~1684 jadval)]
  APP --> RD[(Redis<br/>sessiyalar + kesh)]

  subgraph CS_role [Boshqaruv tekisligi]
    CS
  end
  subgraph BD_role [Operatsion ombor · ko'p-tenantli]
    BD
  end

  class U,APP,RD action
  class CS,BD action
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
```

`cs3_demo` auth, RBAC, geografiya, rejalar, telegram botlari, pivot
konfiguratsiyalarini saqlaydi. `b_demo` filial bo'yicha bo'lingan barcha
operatsion diler ma'lumotlarini saqlaydi.

## DBlar bo'ylab bog'lanish (filial ko'prigi)

Ikki sxema bo'ylab **chet el kalitlari yo'q** — ikki DB `filial_id` orqali
mantiqiy ravishda birlashtirilgan. Kanonik filial reestri `b_demo.d0_filial`da
yashaydi; `cs3_demo` har bir filialni davlat / hudud metaltlari va har-foydalanuvchi
ACLlari bilan boyitadi.

```mermaid
erDiagram
  CS_COUNTRY ||--o{ CS_REGION : has
  CS_REGION  ||--o{ CS_TERRITORY : has
  CS_TERRITORY ||--o{ CS_FILIAL_DETAIL : describes
  CS_FILIAL_DETAIL }o--|| D0_FILIAL : "filial_id (DBlar bo'ylab)"
  CS_USER ||--o{ CS_USER_FILIAL : owns
  CS_USER_FILIAL }o--|| D0_FILIAL : "filial_id (DBlar bo'ylab)"
  CS_FILIAL_GROUP }o--|| D0_FILIAL : "filial_id (DBlar bo'ylab)"
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

## `b_demo` ichidagi ko'p-tenant joylashuvi

`b_demo` ikki turdagi jadvallarni aralashtiradi: diler-global (filial
prefiksi yo'q) va har-filial (`d0_fN_*`). Demo o'lchami: 7 faol filial
(`f1..f7`), har filial uchun ~227 jadval, plyus ~50 diler-global jadvallar.

```mermaid
flowchart TB
  BD[(b_demo)]
  BD --> REG[d0_filial<br/>tenant reestri]
  BD --> GLB[Diler-global jadvallar<br/>d0_product, d0_price,<br/>d0_skidka_*, d0_royalty_*,<br/>d0_knowledge_*, …]
  BD --> F1[d0_f1_* · ~227 jadval]
  BD --> F2[d0_f2_* · ~227 jadval]
  BD --> F3[d0_f3_* · ~227 jadval]
  BD --> FN[d0_fN_* · ~227 jadval]

  REG -. prefikslarni belgilaydi .-> F1
  REG -. prefikslarni belgilaydi .-> F2
  REG -. prefikslarni belgilaydi .-> F3
  REG -. prefikslarni belgilaydi .-> FN

  class BD,REG,GLB action
  class F1,F2,F3,FN action
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
```

Har-filial ob'ektlari `client`, `agent`, `order`, `visit`, `audit`,
`cashbox`, `bonus_*`, `cars`, `catalog_*` va h.k. ni o'z ichiga oladi —
har bir filial o'zining nusxasini oladi, `fN_` prefiksi bilan ko'lamlangan.

## `setFilial()` jadval qayta yozish

Bitta model sinfining ko'p tenantlarni murojaat qilish imkonini beradigan
mexanizm `protected/components/BaseModel.php` (`tableName()`,
`getFilialTable()`, `setFilial()`) da yashaydi. `setFilial('f3')` ni chaqirish
jadval tokeni `{{client}}` dan `{{f3_client}}` ga qayta yozadi, bu Yii ning
`dealer` ulanishining `tablePrefix='d0_'` bilan kengaytirgan, hosil qilingan
`d0_f3_client`.

```mermaid
flowchart LR
  C[Kontroller] -->|Model::model->setFilial 'f3'| M[BaseModel instansi]
  M --> R[refreshMetaData<br/>sxemani qayta yuklash]
  M --> T[tableName 'client' o'rniga<br/>'f3_client'ni qaytaradi]
  T --> Q[Yii::app->dealer<br/>SELECT FROM d0_f3_client]
  Q --> DB[(b_demo.d0_f3_client)]

  class C,M,R,T,Q action
  class DB action
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
```

## Login → filial ko'lamlash → so'rov

Uchidan-uchgacha so'rov oqimi: auth `cs3_demo`da sodir bo'ladi; ma'lumotlarni
olish `b_demo`da sodir bo'ladi, foydalanuvchining ruxsat berilgan filiallariga
`cs_user_filial` orqali (va ixtiyoriy ravishda `country_id` orqali) ko'lamlangan.

```mermaid
sequenceDiagram
  autonumber
  participant U as Foydalanuvchi (brauzer)
  participant W as sd-cs web
  participant CS as cs3_demo (db)
  participant BD as b_demo (dealer)

  U->>W: POST /user/login
  W->>CS: SELECT cs_user WHERE login=?
  CS-->>W: qator + bcrypt heshi
  W->>W: CPasswordHelper::verifyPassword
  W->>CS: ruxsatlar uchun cs_access_user / cs_access_role
  W-->>U: 302 + sessiya cookie (Redis-asosli)

  U->>W: GET /report/sale
  W->>CS: cs_user_filial (ko'rinadigan filiallar)
  W->>BD: SELECT * FROM d0_filial WHERE active='Y'
  Note over W: BaseModel::getOwnFilials()<br/>= cs_user_filial ∩ d0_filial<br/>(ixtiyoriy ravishda country_id orqali<br/>cs_filial_detail→cs_territory→cs_region orqali filtrlangan)
  loop har bir ko'rinadigan filial prefiksi fN uchun
    W->>BD: SELECT … FROM d0_fN_<entity>
  end
  W-->>U: yig'ilgan hisobot
```

## Modul → ulanish matritsasi

Kod-darajasidagi signal: `protected/`da `Yii::app()->dealer`ga ~440 chaqiruv
va `Yii::app()->db`ga ~14 chaqiruv. Boshqaruv DB kichik va metalt-shaklda;
diler DB ish sodir bo'ladigan joy.

```mermaid
flowchart LR
  USR[user] --> CS_C
  PLAN[reja jadvallari] --> CS_C
  TG[telegram_bot] --> CS_C
  ACL[access_role / access_user] --> CS_C
  PVC[pivot_config] --> CS_C
  GEO[country / region / territory] --> CS_C

  DIR[directory] --> BD_C
  DASH[dashboard] --> BD_C
  REP[report · 30+ hisobot] --> BD_C
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

## Eski tavsifga nisbatan eslatmalar

[Multi-DB ulanish](./multi-db.md) sahifasida sd-cs har bir diler uchun
qisqa muddatli `CDbConnection` ob'ektlarini quradigan model tasvirlangan
(ko'p alohida diler DBlari). Joriy joylashuv **bitta** diler DB (`b_demo`)
ni **filial prefikslari orqali ichki ko'p-tenantlik** bilan ishlatadi.
Yuqoridagi diagrammalar ishlaydigan kod bugun nima qilishini aks ettiradi;
eski eslatma tarixiy kontekst uchun saqlanadi.
