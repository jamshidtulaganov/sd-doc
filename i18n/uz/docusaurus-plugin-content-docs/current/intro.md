---
sidebar_position: 1
title: Kirish
slug: /intro
audience: Yangi dasturchilar, jamoaning barcha a'zolari
summary: SalesDoctor / Novus Distribution — bu ko'p ijarali (multi-tenant) Distribyutsiya CRM platformasi. Uchta loyiha — sd-cs (HQ), sd-main (diler CRM), sd-billing (obunalar). Ushbu sayt dasturchilar hujjatlari hisoblanadi va jamoa RAG / vektor bazasiga ham yetkazib beriladi.
topics: [overview, introduction, distribution, crm, multi-tenant]
---

# Kirish

**SalesDoctor** (ichki nomi **Novus Distribution**, kod bazasi papkasi
`sd-main`) — bu maydon savdosi, vansel sotuv, merchandayzing va marshrut
hisobotiga yo'naltirilgan ko'p ijarali (multi-tenant) **Distribyutsiya CRM**
platformasi.

Ushbu hujjatlar tizimni quradigan, deploy qiladigan va ishlatadigan
**dasturchilar** uchun mo'ljallangan. Yakuniy foydalanuvchilar uchun
hujjatlar alohida saqlanadi va ushbu saytga kirmaydi.

## Tizim nima qiladi

| Soha | Imkoniyatlar |
|------|--------------|
| Savdo | Buyurtma qabul qilish (web + mobil), narxlash, chegirmalar, bonuslar, defektlar, qaytarishlar |
| Maydon jamoasi | Marshrutlar, tashriflar, GPS kuzatuvi, agentlar va supervayzerlar uchun KPI |
| Merchandayzing | Auditlar, feyseling, so'rovnomalar, foto-hisobotlar |
| Katalog | Tovarlar, kategoriyalar, SKU lar, brendlar, narx turlari |
| Ombor | Ko'p omborli zaxira, ko'chirishlar, inventarizatsiyalar, partiyalar, tara/qadoq |
| Moliya | Debitorlik, to'lovlar, kassa, agent va filial bo'yicha P&L |
| Hisobotlar | 80+ hisobotlar, dashboardlar, Excel eksport |
| Integratsiyalar | 1C, Didox EDI, Faktura.uz, Smartup, Telegram, FCM, SMS |
| Onlayn | Internet-do'kon, B2B-portal, Telegram-bot, rejalashtirilgan hisobotlar |

## Auditoriya xaritasi

- **Siz backend dasturchisi bo'lsangiz** — [Arxitektura umumiy ko'rinishidan](./architecture/overview.md)
  boshlang, keyin [Loyiha tuzilishi](./project/structure.md).
- **Siz frontend / mobil dasturchi bo'lsangiz** —
  [Frontend umumiy ko'rinishi](./frontend/overview.md) va
  [API ma'lumotnomasi](./api/overview.md) dan boshlang.
- **Siz DevOps / SRE bo'lsangiz** — [Deployment](./devops/deployment.md) sahifasiga o'ting.
- **Siz tashqi tizimni integratsiya qilayotgan bo'lsangiz** —
  [Integratsiyalar](./integrations/overview.md) va
  [REST API ma'lumotnomasi](./api/overview.md) ga qarang.

## Hujjatdagi konventsiyalar

- Kod yo'llari repo ildiziga (`sd-main` papkasiga) nisbatan beriladi.
- `protected/` — bu Yii ilovasining ildizi.
- Modul nomlari papkasiga mos `lowerCamel` formatida yoziladi, masalan, `orders`,
  `onlineOrder`.
- Rollarga raqamli ID *va* tavsiflovchi nom orqali murojaat qilinadi, masalan,
  `4 / Agent`.
- Barcha buyruq qatori misollari **macOS / Linux** va `bash` ni nazarda
  tutadi. Windows da WSL2 dan foydalaning.
