---
sidebar_position: 1
title: Loyiha tuzilishi
---

# Loyiha tuzilishi

```
sd-main/
├── Dockerfile                 PHP 7.3 + Nginx + extensions
├── docker-compose.yml         web / db / redis / phpmyadmin
├── nginx.conf                 vhost config
├── composer.json/.lock        third-party packages (vendor only)
├── index.php / index2.php     Yii bootstraps
├── console.php                CLI bootstrap (yiic)
│
├── framework/                 Vendored Yii 1.x (do not modify)
├── vendors/                   Pinned vendored libs
├── js/                        First-party JS (~120 files)
├── js_plugins/                3rd-party JS (jQuery, Highcharts, fancybox, …)
├── css/                       Stylesheets
├── ng-modules/                Angular feature modules (gps, neakb, …)
├── assets/                    Yii published asset bundles (auto-generated)
├── images/, img/              Static images
├── upload/                    Runtime upload root
├── api-docs/                  Existing API doc dump (legacy)
├── doc/                       Existing scattered design docs
│
└── protected/                 Yii application root
    ├── config/
    │   ├── main.php           Tenant-bound overrides
    │   ├── main_local.php     Local-only overrides (gitignored)
    │   ├── main_static.php    Shared base config (modules, components)
    │   ├── main_sample.php    Reference template
    │   ├── auth.php           Static auth role hierarchy
    │   └── params.json/.php   Runtime params
    ├── controllers/           Top-level controllers (Catalog, Company, Site …)
    ├── models/                323+ ActiveRecord models
    ├── modules/               40+ feature modules (see Module Reference)
    ├── components/            Cross-cutting services (TenantContext, Queue, …)
    ├── extensions/            Vendored Yii extensions (phpexcel, qrcode, …)
    ├── helpers/               Utility static classes
    ├── messages/              i18n catalogs (ru/en/uz/tr/fa)
    ├── migrations/            DB migrations
    ├── views/                 Server-rendered templates
    ├── runtime/               Logs, cache, compiled views
    └── yiic / yiic.php        CLI entrypoint
```

## Nima qaerda yashaydi

- **Biznes mantig'i** → `protected/components/*Service.php` va modul
  darajasidagi `services/`. Modellar yupqa qoladi (validatsiya + munosabatlar).
- **Uzoq davom etadigan ish** → `protected/components/jobs/*.php` (`BaseJob`
  ga qarang) — hech qachon kontrollerlarda inline emas.
- **HTTP marshrutlash** → `protected/config/main_static.php`
  `urlManager.rules` plus aniqlangan joylarda har bir modul url qoidalari.
- **Modul boshiga kontrollerlar** → `protected/modules/{name}/controllers/`.
- **API endpointlari** → `protected/modules/api{,2,3,4}/controllers/`.
- **Frontend assetlari** → yuqori darajadagi `js/`, `css/`, `js_plugins/`.
  Yii ning `clientScript` ularni ro'yxatdan o'tkazadi.

## E'tibor bermasligingiz mumkin bo'lgan fayllar

| Pattern | Nega |
|---------|-----|
| `*.obsolete` | Arxeologiya uchun saqlangan olib tashlangan kod. Tahrirlamang. |
| `assets/<hash>/` | Avtomatik generatsiya. O'chirish xavfsiz; qayta generatsiya qilinadi. |
| `runtime/` | Loglar va kompilyatsiyalangan view kesh. |
| `framework/` | Yii ning o'zi. Faqat oxirgi chora sifatida patch qiling. |
| `index2.php`, `a.php` | Eski entrypointlar, bir martalik skriptlar. |
