---
title: "api-v4-online · Inventory"
sidebar_position: 1
---

# api-v4-online · `InventoryController`

Endpoints for `InventoryController` (`protected/modules/api4/controllers/InventoryController.php`). 8 action(s).

### `GET /api4/inventory/add`

- **Controller**: `InventoryController::add` (`protected/modules/api4/controllers/InventoryController.php:226`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api4/controllers/InventoryController.php:226](#) directly._

**Response**

_Response shape not auto-detected — TBD._

### `GET /api4/inventory/edit`

- **Controller**: `InventoryController::edit` (`protected/modules/api4/controllers/InventoryController.php:248`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api4/controllers/InventoryController.php:248](#) directly._

**Response**

_Response shape not auto-detected — TBD._

### `GET /api4/inventory/list`

- **Controller**: `InventoryController::list` (`protected/modules/api4/controllers/InventoryController.php:269`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api4/controllers/InventoryController.php:269](#) directly._

**Response**

_Response shape not auto-detected — TBD._

### `GET /api4/inventory/removePhoto`

- **Controller**: `InventoryController::removePhoto` (`protected/modules/api4/controllers/InventoryController.php:429`)

**Request**

| Name | In | Type | Required |
|---|---|---|---|
| `lang` | query | _string_ | TBD |

**Response**

_Response shape not auto-detected — TBD._

### `GET /api4/inventory/scanning`

- **Controller**: `InventoryController::scanning` (`protected/modules/api4/controllers/InventoryController.php:60`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api4/controllers/InventoryController.php:60](#) directly._

**Response**

_Response shape not auto-detected — TBD._

### `POST /api4/inventory/scanningPhoto`

- **Controller**: `InventoryController::scanningPhoto` (`protected/modules/api4/controllers/InventoryController.php:170`)

**Request**

| Name | In | Type | Required |
|---|---|---|---|
| `id` | body | _string_ | TBD |

**Response**

_Response shape not auto-detected — TBD._

### `POST /api4/inventory/setPhoto`

- **Controller**: `InventoryController::setPhoto` (`protected/modules/api4/controllers/InventoryController.php:371`)

**Request**

| Name | In | Type | Required |
|---|---|---|---|
| `photo` | body | _string_ | TBD |
| `timestamp` | body | _string_ | TBD |
| `inventory_id` | body | _string_ | TBD |

**Response**

_Response shape not auto-detected — TBD._

### `GET /api4/inventory/types`

- **Controller**: `InventoryController::types` (`protected/modules/api4/controllers/InventoryController.php:364`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api4/controllers/InventoryController.php:364](#) directly._

**Response**

_Response shape not auto-detected — TBD._

## See also

- [api-v4-online overview](./)
- [Authentication](../authentication.md)
- [Error codes](../error-codes.md)
