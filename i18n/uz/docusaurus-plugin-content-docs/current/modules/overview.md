---
sidebar_position: 1
title: Modullar umumiy ko'rinishi
---

# Modullar umumiy ko'rinishi

SalesDoctor `protected/modules/` ostida **40+ Yii moduli** sifatida tashkil etilgan. Har bir modul o'z kontrollerlari, modellari, ko'rinishlari va (ixtiyoriy ravishda) xizmatlariga ega bo'lgan mustaqil funksional sohadir.

## Sohalar bo'yicha guruhlash

| Soha | Modullar |
|--------|---------|
| **Asos / Platforma** | `dashboard`, `settings`, `access`, `staff`, `team`, `sync` |
| **Savdo va CRM** | `orders`, `clients`, `agents`, `partners`, `onlineOrder`, `planning`, `rating`, `vs` |
| **Ombor va Zaxira** | `warehouse`, `inventory`, `stock`, `store`, `markirovka` |
| **Moliya** | `finans`, `pay`, `payment` |
| **Dala operatsiyalari** | `gps`, `gps2`, `gps3`, `audit`, `doctor`, `adt` |
| **Aloqalar va Hisobotlar** | `sms`, `report`, `integration`, `aidesign`, `neakb` |
| **API'lar** | `api`, `api2`, `api3`, `api4` |

Module Map FigJam diagrammasi bog'liqliklarni vizuallashtiradi.

## Modul anatomiyasi

```
protected/modules/<name>/
├── <Name>Module.php          Module bootstrap, init(), defaultController
├── controllers/              Web/JSON controllers
├── models/                   Module-local models (most live in protected/models/)
├── views/                    Module views, mirroring controller folders
├── services/                 (optional) Domain services for the module
├── components/               (optional) Module-internal components
├── actions/                  (optional) Reusable action classes
└── docs/                     (optional) Inline notes
```

## Aktivatsiya

Har bir modul `protected/config/main_static.php` faylida `modules` kaliti ostida ro'yxatga olingan. Papka qo'shish **yetarli emas** — massivga yozuv kerak.

## Modullar aro aloqa

- Modellar `application.models.*` autoload orqali global ulashilgan, shuning uchun istalgan modul istalgan modeldan foydalana oladi.
- `protected/components/` ichidagi xizmatlar ulashilgan.
- Hodisalar: ba'zi muhim joylarda `Yii::app()->onAfter*` ishlatiladi — kamdan-kam.
- Bir modulning kontrollerlari boshqa modul kontrollerlarini to'g'ridan-to'g'ri chaqirmasligi kerak. Umumiy kodni `components/` yoki xizmat sinfiga ko'chiring.

## Yangi kodni qayerga qo'shish kerak

| Ehtiyoj | Qayerga |
|------|-------|
| Mavjud entity uchun yangi ro'yxat ekrani | Tegishli modulning `controllers/` papkasi |
| Yangi cross-cutting xizmat | `protected/components/<Service>.php` |
| Yangi rejalashtirilgan job | `protected/components/jobs/<Job>.php` |
| Mobil uchun yangi API endpoint | `protected/modules/api3/controllers/` |
| B2B / online uchun yangi API endpoint | `protected/modules/api4/controllers/` |
| Yangi soha | `protected/modules/` ostida yangi modul + uni ro'yxatga olish |
