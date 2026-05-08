---
sidebar_position: 5
title: ADR-0004 — Versiyalangan API modullari
---

# ADR 0004 — Versiyalangan API modullari (api / api2 / api3 / api4)

- Status: **Accepted**
- Date: 2024-08-08
- Deciders: API working group

## Kontekst

Mobil mijozlarni majburlab yangilab bo'lmaydi. 2018 yildagi v1 mobil
build hali ham maydondagi qurilmalarda. Shartnomani buzish variant
emas.

## Qaror

Har bir API avlodi `protected/modules/api*` ostida **o'z Yii moduli**
da yashaydi. Yangi endpointlar so'nggi faol versiyaga (hozirda mobil
uchun v3, onlayn / B2B uchun v4) boradi. v1 / v2 muzlatilgan.

## Oqibatlar

- Eski mijozlar o'zgartirilmagan holda ishlashda davom etadi.
- Muhandislar qaysi yuzaga tegayotganlarini bir qarashda ko'rishadi.
- Kod takrorlanishi: o'xshash endpointlar v3 va v4 da mavjud. Mantiqni
  umumiy xizmatlarga surish orqali yumshatiladi.
- Tashqi iste'molchilar uchun discoverability — ushbu hujjat sayti
  orqali hal qilinadi.
