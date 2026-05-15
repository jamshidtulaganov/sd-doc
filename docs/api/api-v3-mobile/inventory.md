---
title: "api-v3-mobile · Inventory"
sidebar_position: 1
---

# api-v3-mobile · `InventoryController`

Endpoints for `InventoryController` (`protected/modules/api3/controllers/InventoryController.php`). 4 action(s).

### `POST /api3/inventory/removePhoto`

- **Controller**: `InventoryController::removePhoto` (`protected/modules/api3/controllers/InventoryController.php:141`)

**Request**

| Name | In | Type | Required |
|---|---|---|---|
| `photoId` | body | _string_ | TBD |
| `inventoryId` | body | _string_ | TBD |

**Response**

_Response shape not auto-detected — TBD._

### `GET /api3/inventory/set`

- **Controller**: `InventoryController::set` (`protected/modules/api3/controllers/InventoryController.php:6`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api3/controllers/InventoryController.php:6](#) directly._

**Response**

_Response shape not auto-detected — TBD._

### `POST /api3/inventory/setPhoto`

- **Controller**: `InventoryController::setPhoto` (`protected/modules/api3/controllers/InventoryController.php:86`)

**Request**

| Name | In | Type | Required |
|---|---|---|---|
| `photo` | body | _string_ | TBD |
| `inventoryId` | body | _string_ | TBD |
| `createdAt` | body | _string_ | TBD |

**Response**

_Response shape not auto-detected — TBD._

### `GET /api3/inventory/type`

- **Controller**: `InventoryController::type` (`protected/modules/api3/controllers/InventoryController.php:58`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api3/controllers/InventoryController.php:58](#) directly._

**Response**

_Response shape not auto-detected — TBD._

## See also

- [api-v3-mobile overview](./)
- [Authentication](../authentication.md)
- [Error codes](../error-codes.md)
