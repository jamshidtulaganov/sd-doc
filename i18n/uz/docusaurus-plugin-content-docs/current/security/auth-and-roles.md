---
sidebar_position: 2
title: Auth va rollar
---

# Autentifikatsiya va rollar

:::note Qamrov
Ushbu sahifa **sd-main** (diler CRM) dagi rollarni hujjatlashtiradi. Bu yerdagi raqamli rol ID lari [sd-billing](../sd-billing/auth-and-access.md) dagi rol ID lari bilan bir xil EMAS, garchi butun sonlar bir-biriga mos kelsa ham. sd-main modul sahifasida "Tasdiqlash: 1, 2, 9" deyilsa, ushbu sahifadagi jadvalga murojaat qiling.
:::

## Rollar (kanonik)

`protected/config/auth.php` da aniqlangan:

| ID | Rol | Izohlar |
|----|-----|---------|
| 1 | Super Administrator | Barcha filiallar, barcha imkoniyatlar |
| 2 | Administrator Filial | Bitta filial, to'liq imkoniyatlar to'plami |
| 3 | Diler | Diler, cheklangan admin |
| 4 | Agent | Mobil savdo agenti |
| 5 | Operator | Backoffice operatori |
| 6 | Kassir | Kassir |
| 7 | Hamkor (Partner) | Tashqi hamkor kirish huquqi |
| 8 | Supervayzer | Nazoratchi / jamoa rahbari |
| 9 | Menejer | Savdo menejeri |
| 10 | Ekspeditor | Yetkazib berish |
| guest | Mehmon | Anonim |

Iyerarxiya qisman: `1 → 2 → 3 → 4 → guest`. 5–10 rollar faqat
`guest` dan meros oladi va `authassignment` dagi har bir ruxsat
grantiga tayanadi.

## Autentifikatsiya yo'llari

| Yuza | Mexanizm |
|------|----------|
| Web admin | sessiya cookie + `WebUser` |
| Mobil ilova | `LoginController` orqali Bearer token (api3) |
| Onlayn portal / WebApp | api4 orqali Bearer token + Telegram-imzolangan init |
| Server-to-server | Har bir integratsiya uchun umumiy maxfiy kalit |

## Parol siyosati

- Yaratish / o'zgartirish vaqtida minimal uzunlik **8**.
- Hashlash (har bir hisob bo'yicha): **faqat MD5** —
  `UserIdentity::authenticate` ham, `User::validatePassword` ham
  saqlangan `PASSWORD` ustunga `md5($plain)` ni solishtiradi.
  `password_hash()` (bcrypt) ga migratsiya kutilmoqda.
- Umumiy parollar ro'yxati yo'q; bu rejalashtirilgan yaxshilash.

## Xatolarni boshqarish

- Bitta loginga ketma-ket 5 ta muvaffaqiyatsiz urinish → 1 daqiqalik blokirovka.
- 10 daqiqada bitta IP dan 30 ta muvaffaqiyatsiz login → IP gateway da throttling.
