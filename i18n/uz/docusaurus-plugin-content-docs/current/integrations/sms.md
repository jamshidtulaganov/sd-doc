---
sidebar_position: 8
title: SMS gateway
---

# SMS gateway

Sozlangan provayder (Eskiz, Playmobile va h.k.) orqali chiquvchi SMS.

## Konfiguratsiya

Har bir ijara uchun, **Sozlamalar → SMS → Provayderlar** da:

| Maydon | Eslatmalar |
|--------|------------|
| Provayder | `eskiz`, `playmobile`, `custom` |
| API kalit / login | Provayder hisob ma'lumotlari |
| Yuboruvchi ID | Tasdiqlangan alfa yuboruvchi |
| Kunlik chegara | Yumshoq chegara |

## Yuborish

Shablonlar → `SmsTemplate`. Hodisani ishga tushirish → `SendSmsJob`
navbatga qo'yiladi → provayder HTTP chaqiruvi → `CallbackController` ga
callback yetkazib berish holatini yangilaydi.

## DLR (yetkazib berish kvitansiyasi)

`POST /sms/callback/index` — provayder bu yerga yuboradi.
`SmsMessage.STATUS` ni `pending / sent / delivered / failed` dan biriga
yangilang.

## Xarajatlar haqida hisobot

`SmsPackage` foydalanishni jamlab beradi; SMS moduli ro'yxatida ko'rsatiladi.
