---
sidebar_position: 1
title: Integratsiyalar umumiy ko'rinishi
---

# Integratsiyalar umumiy ko'rinishi

| Integratsiya | Yo'nalish | Modul | Sahifa |
|--------------|-----------|-------|--------|
| 1C / Esale | ikki tomonlama | `integration` + `sync` + `api` | [1C / Esale](./1c-esale.md) |
| Didox | chiquvchi (EDI) | `integration` | [Didox](./didox.md) |
| Faktura.uz | ikki tomonlama | `integration` | [Faktura.uz](./faktura-uz.md) |
| Smartup | kiruvchi | `integration` | [Smartup](./smartup.md) |
| Telegram | ikki tomonlama | `onlineOrder`, bot | [Telegram](./telegram.md) |
| Firebase FCM | chiquvchi | `api` push | [FCM](./fcm.md) |
| SMS | chiquvchi | `sms` | [SMS](./sms.md) |
| GPS provayderlari | kiruvchi | `gps3` | [GPS](./gps.md) |

## Umumiy tamoyillar

- Har bir integratsiya **`IntegrationLog`** ga (so'rov, javob, holat,
  xatolik) yozadi. Disk to'g'rilashda uni birinchi to'xtash sifatida
  ishlating.
- Barcha chiquvchi chaqiruvlar navbat ishi orqali o'tadi — hech qachon
  so'rov ishlovchisi ichida emas.
- Idempotentlik kalitlari har bir tashqi obyekt ustida (`XML_ID`,
  `EXT_ID`).
- Vaqt tugashlari standart **15 s**; 1 soatgacha eksponensial backoff
  bilan qayta urinish.
