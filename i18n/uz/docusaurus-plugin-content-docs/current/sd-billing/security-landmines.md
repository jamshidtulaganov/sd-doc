---
sidebar_position: 9
title: Xavfsizlik landminalari
---

# Xavfsizlik landminalari (va tuzatish)

Bu sahifa **faqat ichki**, lekin hissa qo'shuvchilar uni ko'rishi uchun
hujjatlarda yashaydi. Har bir element jiddiyligini, muammo qayerda yashashini
va maqsadli tuzatishni ro'yxatlaydi. Holatning haqiqat manbai
`sd-billing/doc/IMPROVEMENTS.md`.

| # | Muammo | Jiddiyligi | Qayerda | Maqsadli tuzatish |
|---|--------|------------|---------|-------------------|
| 1 | **MD5 parol heshlash** | Kritik | `UserIdentity::authenticate`, `User::generatePassword` (faqat sd-billing — sd-main holati: [security/auth-and-roles](../security/auth-and-roles.md) ga qarang) | `password_hash()` (bcrypt)ga ko'chirish. Keyingi muvaffaqiyatli loginda shaffof yangilash. |
| 2 | **Kodda qattiq kodlangan SMS / Telegram sirlari** | Kritik | `protected/components/Sms.php` (Eskiz ma'lumotlari, Mobizon API kaliti); `SiteController::actionLogin` (Telegram bot tokeni) | Env o'zgaruvchilarga ko'chiring; ommaviy oshkor bo'lgan tokenlarni darhol almashtiring. |
| 3 | **`Distr::getFilter()` SQL-injektabel** | Kritik | foydalanuvchi ma'lumotlarini satr-interpolyatsiya qiladi | Chaqiruvchilarni `protected/helpers/QueryBuilder.php` ga ko'chiring. Bu vaqt davomida `Distr::getFilter()` yuzasini kengaytirmang. |
| 4 | **`Controller::hasAccessIpAddress()` qisqa-tutashtiradi** | Yuqori | Birinchi qator `return true;`, quyidagi IP allowlist erishish mumkin emas. | Haqiqiy allowlist tekshiruvi bilan almashtiring; testlar qo'shing. |
| 5 | **`index.php`da `YII_DEBUG = true`** | Yuqori | Stack izlari ishlab chiqarish javoblarida tarqaladi. | Env dan boshqaring (`YII_DEBUG=getenv('APP_DEBUG')`). |
| 6 | **`Curl::run` `CURLOPT_TIMEOUT => 0`ni ishlatadi** | O'rta | Chiquvchi chaqiruvlar abadiy osilib qolishi mumkin. | Mantiqiy standartlarni o'rnating (15 s) + qayta urinish. |
| 7 | **`composer.lock` `composer.json`siz** | O'rta | Bog'liqlik holati takrorlanmaydi. | `composer.json` ni qayta tiklang (`doc/TESTING_PLAN.md` 0-bosqichi). |
| 8 | **Hamkor kirish tekshiruvi izohga olingan** | Yuqori | `protected/components/Controller.php:63` | Izohdan chiqaring; testlar bilan tasdiqlang. |
| 9 | **Litsenziya `TOKEN`i qattiq kodlangan konstanta** | Yuqori | `protected/modules/api/controllers/LicenseController.php` | Env ga ko'chiring; almashtiring; har-manba imzolashni qo'shing. |
| 10 | **Test qoplamasi qurilmoqda** | yo'q | Sinovsiz yo'llarni yuqori xavf sifatida ko'ring. | `doc/TESTING_PLAN.md` ga amal qiling. |

## Xabar berish oqimi

Yangi muammoni topganingizda:

1. Loyiha kuzatuvchisida ticket oching (`security` yorlig'i).
2. Agar ishlab chiqarishda ekspluatatsiya qilinishi mumkin bo'lsa,
   **P0** deb belgilang va tuzatishni birlashtirishdan oldin xavfsizlik
   kanalini xabardor qiling.
3. Tuzatishdan oldin regressiya testini qo'shing (CLAUDE.md §7 qattiq qoidasiga ko'ra).
4. `doc/IMPROVEMENTS.md` ga holat (Open / In progress / Closed) bilan qator qo'shing.

## Mudofaa-chuqurlikda (joriy holat)

Yuqoridagi narsalar ochiq bo'lsa-da, kompensatsiya qiluvchi nazoratlar xavfni kamaytiradi:

- Barcha sd-billing endpointlari oldida WAF.
- Konteyner xostlarining tez-tez OS darajasidagi yamoqlash.
- `api/license` chaqiruvchilar uchun tarmoq darajasidagi allowlist.
- Analitik replikalar uchun faqat-o'qish DB foydalanuvchisi.

## Qilmasligingiz kerak narsalar

- ❌ Boshqa MD5 parol ustunini kiritmang.
- ❌ Yangi qattiq kodlangan sirlarni qo'shmang.
- ❌ `Distr::getFilter()` chaqiruvchilarini kengaytirmang — ularni ko'chiring.
- ❌ Telegram bot tokenlarini yoki Eskiz ma'lumotlarini ticketlarda, Slack yoki
  PR tavsiflarida joylamang.
