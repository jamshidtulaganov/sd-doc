---
sidebar_position: 4
title: ADR-0003 — Redis 3 DB ga bo'lingan
---

# ADR 0003 — Redis: uchta mantiqiy ma'lumotlar bazasi

- Status: **Accepted**
- Date: 2024-02-20
- Deciders: Platform team

## Kontekst

Sessiyalar, navbat va ilova keshi uchun bitta Redis instansiyasidan
foydalanilgan, ular bir xil kalit maydonini baham ko'rgan. Eskirgan
keshni tozalash uchun `FLUSHDB` sessiyalarni o'ldirgan. Navbat chuqurlik
metrikalari kesh kalitlari bilan ifloslangan.

## Qaror

Bir xil instansiyada **uchta mantiqiy Redis ma'lumotlar bazasi** dan
foydalaning:

| DB | Maqsad |
|----|--------|
| 0 | Sessiyalar (`HTTP_HOST` keyPrefix) |
| 1 | Navbat |
| 2 | Ilova keshi (`TenantContext` orqali scoped) |

Birida `FLUSHDB` endi boshqalariga ta'sir qilmaydi.

## Oqibatlar

- Tozaroq ajratish; har bir komponent o'z DB ga ega.
- Har bir muammo uchun aniq xotira metrikalari.
- Har bir muhitda biroz ko'proq konfiguratsiya marosimi.
- Dasturchilar `Yii::app()->cache` ni to'g'ridan-to'g'ri **hech qachon**
  ishlatmasliklarini eslab qolishlari kerak — `ScopedCache` orqali
  o'ting.
