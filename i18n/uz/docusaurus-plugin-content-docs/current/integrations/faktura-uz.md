---
sidebar_position: 4
title: Faktura.uz
---

# Faktura.uz

O'zbekistondagi davlat tomonidan majburlangan e-hisobvaraq darvozasi.
Muvofiqlik uchun QQS o'z ichiga olgan hisobvaraqlarni yuboradi.

## Yoqish

`params` da `'enableFakturaUZ' => true`.

## Oqim

1. Buyurtma `Loaded` ga yetadi (yoki ijara qoidasi bo'yicha).
2. `FakturaJob` hisobvaraqni QQS qatorlari bilan paketga joylashtiradi.
3. Faktura.uz ga yuboradi; ro'yxatga olish javobini oladi.
4. Ijaraning hisobchisi Faktura.uz UI da imzolaydi (EIMZO).
5. Kontragent qabul qiladi.
6. Har bir o'tish so'rov ishi orqali aks ettiriladi.

## Umumiy xatoliklar

| Xatolik | Sabab |
|---------|-------|
| Yomon TIN | `Client.INN` bo'sh yoki noto'g'ri uzunlikda |
| Birlik mos kelmaydi | Mahsulot birligi Faktura.uz katalogida yo'q |
| Narx > QQS-ruxsat etilgan | Ijara konfiguratsiyasi muammosi |
