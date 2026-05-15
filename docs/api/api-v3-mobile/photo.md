---
title: "api-v3-mobile · Photo"
sidebar_position: 1
---

# api-v3-mobile · `PhotoController`

Endpoints for `PhotoController` (`protected/modules/api3/controllers/PhotoController.php`). 4 action(s).

### `GET /api3/photo/category`

- **Controller**: `PhotoController::category` (`protected/modules/api3/controllers/PhotoController.php:219`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api3/controllers/PhotoController.php:219](#) directly._

**Response**

_Response shape not auto-detected — TBD._

### `GET /api3/photo/prTgNotify`

- **Controller**: `PhotoController::prTgNotify` (`protected/modules/api3/controllers/PhotoController.php:127`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api3/controllers/PhotoController.php:127](#) directly._

**Response**

_Response shape not auto-detected — TBD._

### `POST /api3/photo/set`

- **Controller**: `PhotoController::set` (`protected/modules/api3/controllers/PhotoController.php:7`)

**Request**

| Name | In | Type | Required |
|---|---|---|---|
| `base64` | body | _string_ | TBD |
| `photo` | body | _string_ | TBD |
| `customerId` | body | _string_ | TBD |
| `createdAt` | body | _string_ | TBD |
| `tags` | body | _string_ | TBD |
| `tagIds` | body | _string_ | TBD |
| `categoryId` | body | _string_ | TBD |
| `longitude` | body | _string_ | TBD |
| `latitude` | body | _string_ | TBD |

**Response**

_Response shape not auto-detected — TBD._

### `GET /api3/photo/test`

- **Controller**: `PhotoController::test` (`protected/modules/api3/controllers/PhotoController.php:184`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api3/controllers/PhotoController.php:184](#) directly._

**Response**

_Response shape not auto-detected — TBD._

## See also

- [api-v3-mobile overview](./)
- [Authentication](../authentication.md)
- [Error codes](../error-codes.md)
