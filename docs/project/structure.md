---
sidebar_position: 1
title: Project structure
---

# Project structure

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

## What lives where

- **Business logic** → `protected/components/*Service.php` and module-level
  `services/`. Models stay thin (validation + relations).
- **Long-running work** → `protected/components/jobs/*.php` (see
  `BaseJob`) — never inline in controllers.
- **HTTP routing** → `protected/config/main_static.php` `urlManager.rules`
  plus per-module url rules where defined.
- **Per-module controllers** → `protected/modules/{name}/controllers/`.
- **API endpoints** → `protected/modules/api{,2,3,4}/controllers/`.
- **Frontend assets** → top-level `js/`, `css/`, `js_plugins/`. Yii's
  `clientScript` registers them.

## Files you can ignore

| Pattern | Why |
|---------|-----|
| `*.obsolete` | Removed code kept around for archaeology. Don't edit. |
| `assets/<hash>/` | Auto-generated. Safe to delete; will be regenerated. |
| `runtime/` | Logs and compiled view cache. |
| `framework/` | Yii itself. Patch only as a last resort. |
| `index2.php`, `a.php` | Legacy entrypoints, one-off scripts. |
