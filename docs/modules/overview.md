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

## Skeleton / cleanup modules

A small set of modules exist on disk but carry **no controllers / no
routed actions**, or are documented under a sibling module rather
than as a standalone page. They are listed here for completeness so
the module map matches the source tree.

| Module | Controllers | Routes | Status | Where documented |
|--------|-------------|--------|--------|------------------|
| `aidesign` | 0 | 0 | **Skeleton** — only empty `controllers/` and `views/` folders; no `AidesignModule.php`. Placeholder for a future AI-design surface. | This row only. Treat as not-yet-implemented. |
| `neakb` | 0 | 0 | **Obsolete skeleton** — `NeakbModule.php.obsolete` is renamed off, `controllers/` empty; `models/`, `views/` and `assets/` retained. Was once an "non-active client base" tool. | This row only. Do **not** wire into routing or RBAC. |
| `pay` | 3 (`ApelsinController`, `ClickController`, `PaymeController`) | 3 (one action each — payment-gateway callback endpoints) | **Active** — only consumed by external providers (Click, Payme, Apelsin). | Documented inside [`payment`](./payment.md) (the `payment / pay` page). No standalone page. |

Key cross-references for these skeletons:

- For **`pay`** routes (`/pay/click/index`, `/pay/payme/index`,
  `/pay/apelsin/index`), see the **"`pay` callback endpoints"**
  section of [`modules/payment`](./payment.md) — that page already
  documents the gateway-side state machines (`ClickTransaction`,
  `ClientPaymeTransaction`) and the `OnlinePayment` envelope rows.
- For **`aidesign`** and **`neakb`**, the source-walker
  (`walk-source-routes.py`) emits **zero rows** in
  `static/data/routes.json`. If a controller is ever added, those
  routes will appear and this overview should be updated.

