---
sidebar_position: 1
title: sd-main · Diler CRM
slug: /sd-main
audience: Barcha sd-main dasturchilari, PM, QA
summary: sd-main loyihasining bosh sahifasi — diler CRM (Yii 1.x PHP, multi-tenant, mobil + web + B2B onlayn). Quyi-daraxtlar Tizim Arxitekturasi, Ish jarayonlari (modullar + API + integratsiyalar + frontend + UI) va Ma'lumotlar sxemalarini qamrab oladi.
topics: [sd-main, dealer-crm, yii, distribution]
---

# sd-main — Diler CRM

**sd-main** (ichki nomi *Novus Distribution*) — bu SalesDoctor platformasining
qoq markazidagi har bir diler uchun alohida CRM. Har bir diler o'zining
`sd-main` instansini o'z MySQL sxemasiga (`d0_` prefiksli) qarshi ishga
tushiradi. U buyurtmalarni qabul qiladi, maydon jamoasini boshqaradi,
zaxira va omborlarni boshqaradi, to'lovlarni qayd etadi, 1C / Didox /
Faktura.uz bilan integratsiya qiladi va mobil + B2B onlayn kanallarni
ochadi.

Quyidagi quyi-daraxtlar sd-main hujjatlarini uch yo'nalishda taqsimlaydi.
Qilmoqchi bo'lgan ishingizga mos keladiganini tanlang.

## Uchta quyi-daraxt

| Quyi-daraxt | Ichida nima bor | Qachon shu yerdan boshlash kerak… |
|----------|---------------|------------------|
| **[Tizim Arxitekturasi](../architecture/overview.md)** | Tech stack, multi-tenancy, keshlash, ishlar va rejalashtirish, loyiha tuzilishi, xavfsizlik, deployment | Onboardingdan o'tayotganingizda, ko'ndalang xulq-atvorni debug qilayotganingizda yoki platformani ishlatayotganingizda |
| **[Ish jarayonlari](../modules/overview.md)** | Har bir modul + API yuzasi + integratsiyalar + frontend + UI patternlari | Xususiyatni qurayotganingizda yoki o'zgartirayotganingizda |
| **[Ma'lumotlar sxemalari](../data/overview.md)** | ERD, asosiy mavjudotlar, sxema konventsiyalari, migratsiyalar | Ma'lumotlar bazasiga tegayotganingizda yoki hisobot yozayotganingizda |

## Bir qarashda

| Xususiyat | Qiymat |
|----------|-------|
| Stack | PHP 7.3 · Yii 1.x · Nginx + php-fpm · MySQL 8 · Redis 7 |
| Tenancy | Mijoz boshiga DB, `TenantContext` orqali subdomenga marshrutlanadi |
| Mobil | Agent ilovasi uchun api3 yuzasi (Bearer-token autentifikatsiyasi) |
| B2B onlayn | api4 yuzasi (token + Telegram-imzolangan init) |
| Modullar | `protected/modules/` ostida 40+ Yii moduli |
| Diagrammalar | Manba hujjatlarida ichki Mermaid; kanonik FigJam [diagramma galereyasida](../diagrams/index.md) |

## sd-main boshqa ikkita loyiha bilan qanday bog'liq

- **`sd-billing`** yuqori oqimda — u har bir sd-main ga litsenziya fayllari va
  telefon ma'lumotnomasi yangilanishlarini yuboradi va dilerlarga platforma
  uchun hisob-kitob qiladi. [Loyihalararo integratsiya xaritasi](../ecosystem.md#inter-project-integration-map) ga qarang.
- **`sd-cs`** quyi oqimda — u HQ darajasidagi konsolidatsiyalangan hisobotlarni
  yaratish uchun har bir sd-main ning DB siga faqat o'qish uchun ulanishlarni
  ochadi. [sd-cs ↔ sd-main integratsiyasi](../sd-cs/sd-main-integration.md) ga qarang.

Loyihalararo yuza kichik va bir tomonlama: sd-main `api/billing` va
`api/license` endpointlarining mahkam to'plamini ochadi; qolgan barchasi
bitta diler bilan chegaralangan.
