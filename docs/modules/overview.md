---
sidebar_position: 1
title: Module overview
---

# Module overview

SalesDoctor is organised as **40+ Yii modules** under
`protected/modules/`. Each module is a self-contained feature area with its
own controllers, models, views, and (optionally) services.

## Domain grouping

| Domain | Modules |
|--------|---------|
| **Core / Platform** | `dashboard`, `settings`, `access`, `staff`, `team`, `sync` |
| **Sales & CRM** | `orders`, `clients`, `agents`, `partners`, `onlineOrder`, `planning`, `rating`, `vs` |
| **Warehouse & Stock** | `warehouse`, `inventory`, `stock`, `store`, `markirovka` |
| **Finance** | `finans`, `pay`, `payment` |
| **Field Ops** | `gps`, `gps2`, `gps3`, `audit`, `doctor`, `adt` |
| **Comms & Reporting** | `sms`, `report`, `integration`, `aidesign`, `neakb` |
| **APIs** | `api`, `api2`, `api3`, `api4` |

The Module Map FigJam diagram visualises the dependencies.

## Module anatomy

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

## Activation

Every module is listed in `protected/config/main_static.php` under the
`modules` key. Adding a folder is **not enough** — the array entry is
required.

## Cross-module communication

- ✅ **Models** are shared globally via `application.models.*` autoload, so
  any module can use any model.
- ✅ **Services** in `protected/components/` are shared.
- ✅ **Events**: a few hot paths use `Yii::app()->onAfter*` — used sparingly.
- ❌ **Controllers** of one module should not directly call controllers of
  another. Push shared code into `components/` or a service class.

## Where to add new code

| Need | Where |
|------|-------|
| New listing screen for an existing entity | The owning module's `controllers/` |
| New cross-cutting service | `protected/components/<Service>.php` |
| New scheduled job | `protected/components/jobs/<Job>.php` |
| New API endpoint for mobile | `protected/modules/api3/controllers/` |
| New API endpoint for B2B / online | `protected/modules/api4/controllers/` |
| New domain area | A new module under `protected/modules/` + register it |
