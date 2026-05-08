---
sidebar_position: 1
title: Arxitektura umumiy ko'rinishi
audience: Backend / DevOps muhandislari
summary: sd-main yuqori darajadagi arxitekturasi — Nginx orqasidagi server-rendered Yii 1.x PHP web ilova + REST API, MySQL + Redis (3 mantiqiy DB) + navbat ishchilari + cron.
topics: [architecture, sd-main, yii, nginx, mysql, redis, queue, cron]
---

# Arxitektura umumiy ko'rinishi

SalesDoctor — bu mobil va integratsiyalar uchun **REST API** ga ega
klassik **server-rendered PHP web ilova**. U Nginx orqasidagi kichik
to'plam stateless ilova konteynerlari sifatida deploy qilinadi va MySQL
hamda Redis bilan tayyorlanadi.

## Yuqori darajadagi diagramma

Kanonik diagramma FigJam da yashaydi —
[Diagrammalar sahifasi](./diagrams.md) ga qarang. Lokal renderlangan
Mermaid versiyasi:

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

## Qatlamlar

### Edge

Bitta **Nginx** TLS terminator, vhost router (har bir tenant subdomeni uchun
bitta vhost) va statik asset serveri vazifasini bajaradi.
[`nginx.conf`](../project/structure.md) repo ildizida va
[DevOps dagi Nginx](../devops/nginx.md) ga qarang.

### Ilova

PHP 7.3 + Yii 1.x. Bir xil kod bazasi quyidagilarga xizmat qiladi:

- **Web admin** (server-rendered Yii view lari, jQuery, ba'zi Angular va Vue
  islandlari)
- **API v1, v2, v3, v4** `protected/modules/api*` ostida
- **Navbat ishchilari** — Redis db1 dan tortib olinadigan `BaseJob`
  pastki sinflarini ishga tushiradi
- **Cron** yozuvlari rejalashtirilgan ishlarni ishga tushiradi

Ilova konteynerlari **stateless**. Holatga ega bo'lgan har qanday narsa
MySQL, Redis yoki fayl tizimi mountiga boradi.

### Ma'lumotlar

- **MySQL 8** — har bir tenant uchun bitta mantiqiy ma'lumotlar bazasi
  (mijoz boshiga DB multi-tenancy). `protected/config/main.php` DB ni
  `HTTP_HOST` orqali tanlaydi.
  [Multi-tenancy](./multi-tenancy.md) ga qarang.
- **Redis 7** — uchta mantiqiy ma'lumotlar bazasi:
  - **db0** sessiyalar (`CCacheHttpSession`)
  - **db1** navbat (`Queue` komponenti)
  - **db2** ilova keshi (`TenantContext` orqali `ScopedCache`)
- **Fayl saqlash** — yuklangan fotolar, eksportlar, generatsiyalangan
  hujjatlar. Konteynerlarga umumiy hajm sifatida o'rnatilgan.

## Ko'ndalang komponentlar

| Komponent | Maqsadi | Joylashuv |
|-----------|---------|----------|
| `TenantContext` | So'rov host idan DB + filialni hal qiladi | `protected/components/TenantContext.php` |
| `DbAuthManager` | `authitem`, `authitemchild`, `authassignment` ustidagi keshlangan RBAC | `protected/components/DbAuthManager.php` |
| `WebUser` | Auto-login va filial scoping bilan Yii foydalanuvchi komponenti | `protected/components/WebUser.php` |
| `BaseJob` | Barcha navbat ishlari uchun bazaviy klass | `protected/components/BaseJob.php` |
| `Queue` | Redis asosidagi dispatcher | `protected/components/Queue.php` (yoki framework komponenti) |
| `ScopedCache` | Tenant- va filial-scope qilingan Redis kesh wrapperi | `protected/components/ScopedCache.php` |

## Nega bunday stack

Tarixiy qarorlar uchun [ADR 0001 — Yii 1 da qolish](../adr/yii1-stay.md) va
[ADR 0002 — Mijoz boshiga DB](../adr/multi-tenant-db-per-customer.md)
ga qarang.
