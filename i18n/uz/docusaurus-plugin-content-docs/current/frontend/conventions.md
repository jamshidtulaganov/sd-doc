---
sidebar_position: 3
title: Frontend konvensiyalari
audience: Frontend engineers
summary: Fayl tartibi, nomlash, qachon jQuery vs Angular oroli vs Vue sahifasidan foydalanish, view-larda i18n, nimaga tegmaslik kerak. Loyiha bo'yicha umumiy Conventions sahifasiga frontend qo'shimchasi.
topics: [frontend, conventions, style]
---

# Frontend konvensiyalari

Bu sahifa frontend qatlamiga xos konvensiyalarni qamrab oladi. PHP / DB / Git konvensiyalari uchun [loyiha Conventions](../project/conventions.md) ga qarang. Stack *anatomiyasi* uchun [Frontend overview](./overview.md) ga qarang.

## Narsalar qayerda joylashgan

| Agar siz qo'shsangiz… | Buni qo'ying… |
|--------|---------|
| Sahifaga xos JS fayli | `js/<area>.js` (first-party) |
| 3rd-party kutubxona | `js_plugins/<name>/` |
| Sahifaga xos stylesheet | `css/<area>.css` |
| Sahifalar bo'ylab qayta foydalaniladigan view partial | `protected/views/partial/` |
| Qayta foydalanish mumkin bo'lgan modal partial | `protected/views/modals/` |
| Interaktiv orol (Angular) | `ng-modules/<feature>/` |
| Vue tajribasi | `protected/views/vue/` (kam-kamdan) |

`js/` allaqachon ~120 first-party fayllarni o'z ichiga oladi ([Project structure](../project/structure.md) ga ko'ra) va `js_plugins/` 3rd-party vendored uy (Bootstrap 3, Chosen, fancybox, jQuery UI, Highcharts, DataTables FixedColumns, noty — qarang [JS plagins](./js-plugins.md)).

## Qachon nimadan foydalanish kerak

Frontend ataylab aralash. Tartibdagi qaror qoidasi:

1. **Oddiy Yii view + jQuery snippet** — default. Buni list sahifalari, formalar, modallar va mavjud sahifa hayotiy davriga mos keladigan har narsa uchun ishlating (qarang [Frontend overview](./overview.md#sahifa-hayotiy-davri)).
2. **Yii view + first-party `js/<area>.js`** — sahifa darajasidagi JS view-ni bezovta qiladigan bo'lsa, uni `js/` ostidagi faylga ko'taring va `clientScript->registerScriptFile` orqali ro'yxatdan o'tkazing.
3. **Mavjud `js_plugins/` kutubxonasi** — ma'lum ehtiyoj uchun: chart → Highcharts, search-select → Chosen, table → DataTables, modal → fancybox2, toast → noty.
4. **Yangi `js_plugins/` kutubxonasi** — faqat hech qanday mavjud plagin ehtiyojni qoplay olmaganda *va* uni o'z qo'limizda yozish bo'yicha jamoa konsensusi mavjud bo'lmaganda. Har bir qo'shimcha doimiy (qarang [JS plagins · Plagin qo'shish](./js-plugins.md#plagin-qoshish)).
5. **`ng-modules/` ostidagi Angular oroli** — faqat mazmunli interaktiv UI (jonli xarita, drag-drop kanban, murakkab ko'p qadamli forma) uchun. Har bir orolda o'z build-i, o'z routing-i, o'z xizmat ko'rsatish xarajati bor. Yangi oroli qo'shishdan oldin maslahatlashing ([Frontend overview](./overview.md#qachon-angular-oroli-qoshish-kerak)).
6. **Vue sahifasi** — yangilarini qo'shmang. `protected/views/vue/` da bir nechta mavjud tajribalar saqlanadi; yangi SPA-lar `ng-modules/` ga, agar ular umuman bo'lishi kerak bo'lsa.

Qaysi darajaga mos kelishini bilmasangiz, pastrog'ini tanlang. jQuery snippet-dan Angular oroliga o'tish teskari yo'ldan kamdan-kam arzonroq bo'ladi.

## Nomlash

### `js/` dagi JS fayllari

- **Sahifaga xos** — kontroller/sohaning nomi bilan: `orders.js`, `clients.js`, `invoice.js`. Kichik harf bilan saqlang.
- **Qayta foydalanish mumkin bo'lgan utility-lar** — manfaat nomi bilan: `date-utils.js`, `money.js`. `helpers.js` / `common.js` dan saqlaning — har bir legacy kodbazada bittasi bor va ichida nima borligini hech kim bilmaydi.
- **`js/` ostida yangi papka** — faqat feature ≥ 3 fayl jo'natganda. Aks holda flat saqlang.

### `js_plugins/` dagi JS fayllari

- **Bitta papka kutubxona uchun** — `<name>/` upstream nomiga mos keladi (`chosen/`, `fancybox2/`, `jquery-highcharts-10.3.3/`).
- **Versiyani papka nomiga mahkamlang** plagin eskisining yonida yangilanish ehtimoli bo'lsa (Highcharts papkasi pretsedent).

### CSS fayllari

- **Sahifaga xos** — `css/<area>.css`, JS nomlashini aks ettiradi.
- **Sayt bo'ylab** — minimal saqlanadi; bugungi kunda ko'p stillash Bootstrap 3 klasslari ustida ishlaydi.

### Yii view-lari

[Conventions](../project/conventions.md) ga ko'ra:

- **Kontrollerga papka** — `views/<controller>/`.
- **Bir fayl harakat uchun** — `views/<controller>/<action>.php`, kichik harf.
- **Qayta foydalanish mumkin bo'lgan partial-lar** — `views/partial/<name>.php`, `$this->renderPartial('partial.<name>', [...])` orqali kiritiladi.

## View-larda i18n

Har bir ko'rinadigan qatorni o'rab oling:

```php
<?= Yii::t('orders', 'Create order') ?>
```

- **Kategoriya** birinchi argument (`'orders'`, `'common'`, …). O'zingiz bo'lgan modul / sohaga moslang — hammasini `'common'` ga yig'masdan.
- **Manba qator** ikkinchi argument. Manba tilini kategoriya ichida izchil saqlang (mavjud kataloglar RU va EN manbalarini aralashtiradi; qo'shganda atrofdagi faylga ergashing).
- Kataloglar `protected/messages/<locale>/<category>.php` da yashaydi. Faol locale-lar: **`ru` (default)**, `en`, `uz`, `tr`, `fa` ([Tech stack](../architecture/tech-stack.md) ga ko'ra).
- RU-birinchi feature uchun yangi kalit faqat `ru` da qo'shish maqbul, ammo bir xil release ichida EN + UZ ni rejalashtiring. Bu sabab uchun [onboarding starter ticket](../team/onboarding.md#week-1) ro'yxatida "yetishmayotgan tarjimalarni to'ldirish" vazifalari mavjud.

## Frontend dan API-larni chaqirish

[Birinchi oydagi muammolar](../team/onboarding.md#pitfalls-to-avoid-in-your-first-month) ga ko'ra:

- **Qilmang** `api` (v1) yoki `api2` ga yangi endpoint qo'shing.
- **Mobil** oqimlar → `api3` ([API v3 — mobile](../api/api-v3-mobile.md)).
- **Online / web** oqimlar → `api4` ([API v4 — online](../api/api-v4-online.md)).

Angular orollari uchun, qarang [ng-modules · PHP bilan aloqa](./ng-modules.md#php-bilan-aloqa) — kontekst (tenant, user va boshqalar) Yii view-dan Angular bundle-ga host elementdagi `data-*` atributlari orqali oqadi.

## Tegmasligingiz kerak bo'lgan narsa

| Yo'l | Nima uchun |
|------|-----|
| `framework/` | Vendored Yii 1.x. Faqat oxirgi chora sifatida va faqat jamoa jarayoni orqali patch qiling. |
| `assets/<hash>/` | Avtomatik yaratilgan. Tahrirlar yozib yuboriladi va papka istalgan vaqtda o'chirilishi mumkin. |
| `*.obsolete` | Arxeologiya uchun saqlangan olib tashlangan kod. |
| `index2.php`, `a.php` | Legacy kirish nuqtalari / bir martalik skriptlar. |
| `vendors/`, `protected/extensions/` | Mahkamlangan vendored kutubxonalar. |

## Olib tashlash uchun nomzodlar (kengaytirmang, nafaqaga chiqarishni rejalashtiring)

[JS plagins · Olib tashlash uchun nomzodlar](./js-plugins.md#olib-tashlash-uchun-nomzodlar) dan:

- **`bootstrap/`** — vaqt o'tishi bilan utility CSS bilan almashtiring.
- **`json2/`** — zamonaviy brauzerlarga kerak emas.
- **`fancybox/` (v1)** — faqat `fancybox2` ni saqlang.

Agar siz ulardan biriga tegayotgan bo'lsangiz, agar o'zgarish hajmi haqiqatan ham joyida tuzatilgan-bug bo'lmasa, zamonaviy almashtirishga ustunlik bering.

## Ochiq savollar / TODO

- **`js/` qabristoni** — qaysi `js/*.js` fayllari biron-bir kontrollerning `registerScriptFile` tomonidan havola qilinganligi va qaysilari tashlab ketilganligining aniq ro'yxati bormi? Bu ro'yxat mavjud bo'lmaguncha, notanish `js/` fayllarni shubhali deb hisoblang va ular jonliligini taxmin qilishdan oldin havolalar uchun `grep` qiling.
- **Iconography manbasi** — Bootstrap 3 glyphs? maxsus sprite? ikkalasi ham? [JS plagins](./js-plugins.md#hozirgi-paytda-foydalanilayotganlar) ga ko'ra ipuchlari uchun qarang.
- **Mavjud JS tomonidan ochiq qilingan sayt bo'ylab globals** (masalan, `Distr` va boshqalar) — tasdiqlangandan keyin bu yerda sanab chiqilishi kerak.
