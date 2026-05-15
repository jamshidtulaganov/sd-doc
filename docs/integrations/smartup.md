---
sidebar_position: 5
title: Smartup
---

# Smartup

Inbound integration with Smartup (a competing/complementary distribution
ERP). Tenants who run both systems use SalesDoctor for field force and
Smartup for HQ accounting.

## What we import

- Orders created in Smartup that need to flow to SalesDoctor for
  delivery / cashier execution.
- See `protected/modules/integration/actions/smartupx/ImportOrdersAction.php`.

## Client matching

Configurable per tenant via `client_search_attribute_salesdoc`:

| Value | Match by |
|-------|----------|
| `code` | `Client.CODE` |
| `id` | `Client.CLIENT_ID` |
| `inn` | `Client.INN` |

## Payment type mapping

`salesdoc_payment_type_code` ↔ Smartup payment type XML ID. Stored on the
imported order so round-tripping preserves it.

## Controller endpoints in sd-main

### `api/SmartUpController` — public ingest

File: `protected/modules/api/controllers/SmartUpController.php`. Live
routes (from `routes.json`):

| Action | Route | RBAC |
|--------|-------|------|
| `saveAuth` | `POST /api/smartUp/saveAuth` | `noRbac` |
| `removeAuth` | `POST /api/smartUp/removeAuth` | `noRbac` |
| `getOrders` | `POST /api/smartUp/getOrders` | `noRbac` |
| `setOrders` | `POST /api/smartUp/setOrders` | `noRbac` |
| `setStock` | `POST /api/smartUp/setStock` | `noRbac` |

### `settings/SmartUpController` — admin UI

| Action | Route | RBAC |
|--------|-------|------|
| `index` | `GET /settings/smartUp/index` | `operation.settings.smartUp` |

### Action class

`protected/modules/integration/actions/smartupx/ImportOrdersAction.php`
holds the order-import logic. Wired into `SmartUpController::setOrders`.

## See also

- [`integration` module](../modules/integration.md)
- [`orders` module](../modules/orders.md) — destination of imported orders.
