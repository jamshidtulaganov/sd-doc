---
sidebar_position: 2
title: 1C / Esale
---

# 1C / Esale

Most tenants run **1C: Enterprise** as their accounting system. The
integration synchronises:

| Direction | Entities |
|-----------|----------|
| 1C → SD | Catalog (products, categories, prices, units), clients (master), warehouses, payments |
| SD → 1C | Orders (header + lines), defects, returns, payments collected by agents |

## Endpoints

- `POST /api/json1c/<action>` — JSON, recent.
- Legacy XML: `/api/xml1c/...` — frozen.

Operations:

```
POST /api/json1c/import?type=products
POST /api/json1c/import?type=clients
POST /api/json1c/export?type=orders
POST /api/json1c/ack?type=order&id=O-2026-0123
```

Auth: shared secret (`Authorization: SDocSecret <token>`).

## Mapping

`XML_ID` on `Product`, `Client`, `Order`, etc. holds the 1C reference.
`integration_log` keeps every request/response.

## Failure handling

If 1C returns an error mid-batch:

1. The whole batch is rolled back **on the SD side**.
2. The `integration_log` row gets `status=ERROR`.
3. The job re-enqueues with backoff (max 6 retries).
4. After 6 failures, an alert is dispatched to `adminEmail`.

## Controller endpoints in sd-main

The active 1C surface lives under `protected/modules/api/controllers/`:

| Controller | File | Notable actions |
|-----------|------|----------------|
| `Json1CController` | `protected/modules/api/controllers/Json1CController.php` | `getOrders` — primary JSON pull endpoint |
| `Mef1cController` | `protected/modules/api/controllers/Mef1cController.php` | `getClients`, `getOrders`, `getOrderBonus`, `setClients`, `setFinans`, `setPrices`, `setProducts`, `setPurchase` — the bidirectional surface |

Live URL shape (from `routes.json`):

```
POST /api/json1C/getOrders
POST /api/mef1c/getClients
POST /api/mef1c/setProducts
POST /api/mef1c/setOrders
```

All `api/*` 1C actions resolve under the `api` module's controller path
(Yii URL manager rewrites `/api/json1C/foo` → `Json1CController::actionFoo`).
RBAC tag in `routes.json` is `noRbac` for every endpoint — auth is by
shared secret in the `Authorization` header, not by RBAC role.

**Frozen / obsolete (do not extend):**
`Xml1CController.php.obsolete`, `OnecController.php.obsolete`,
`OneController.php.obsolete`, `EsaleController.php.obsolete`,
`Export1CController.php.obsolete` (under `api3/`). New 1C surfaces
must extend `Json1CController` or `Mef1cController`.

## See also

- [`integration` module](../modules/integration.md)
- [`sync` module](../modules/sync.md)
- [API v3 mobile reference](../api/api-v3-mobile/) — for the mobile-app
  side of the same data flow.
