---
title: "api-v3-mobile · Order"
sidebar_position: 1
---

# api-v3-mobile · `OrderController`

Endpoints for `OrderController` (`protected/modules/api3/controllers/OrderController.php`). 4 action(s).

### `GET /api3/order/getDraft`

- **Controller**: `OrderController::getDraft` (`protected/modules/api3/controllers/OrderController.php:23`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api3/controllers/OrderController.php:23](#) directly._

**Response**

_Response shape not auto-detected — TBD._

### `POST /api3/order/post`

- **Controller**: `OrderController::post` (`protected/modules/api3/controllers/OrderController.php:37`)

**Request**

| Name | In | Type | Required |
|---|---|---|---|
| `longitude` | body | _string_ | TBD |
| `latitude` | body | _string_ | TBD |
| `forceDate` | query | _string_ | TBD |

**Response**

_Response shape not auto-detected — TBD._

### `GET /api3/order/postDraft`

- **Controller**: `OrderController::postDraft` (`protected/modules/api3/controllers/OrderController.php:7`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api3/controllers/OrderController.php:7](#) directly._

**Response**

_Response shape not auto-detected — TBD._

### `GET /api3/order/update`

- **Controller**: `OrderController::update` (`protected/modules/api3/controllers/OrderController.php:1165`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api3/controllers/OrderController.php:1165](#) directly._

**Response**

_Response shape not auto-detected — TBD._

## See also

- [api-v3-mobile overview](./)
- [Authentication](../authentication.md)
- [Error codes](../error-codes.md)
