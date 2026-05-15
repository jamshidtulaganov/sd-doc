---
title: "api-v3-mobile · Task"
sidebar_position: 1
---

# api-v3-mobile · `TaskController`

Endpoints for `TaskController` (`protected/modules/api3/controllers/TaskController.php`). 3 action(s).

### `GET /api3/task/get`

- **Controller**: `TaskController::get` (`protected/modules/api3/controllers/TaskController.php:158`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api3/controllers/TaskController.php:158](#) directly._

**Response**

_Response shape not auto-detected — TBD._

### `POST /api3/task/photo`

- **Controller**: `TaskController::photo` (`protected/modules/api3/controllers/TaskController.php:68`)

**Request**

| Name | In | Type | Required |
|---|---|---|---|
| `deviceToken` | body | _string_ | TBD |
| `photo` | body | _string_ | TBD |
| `photoTask` | body | _string_ | TBD |
| `photoResult` | body | _string_ | TBD |
| `clientId` | body | _string_ | TBD |
| `dateCreate` | body | _string_ | TBD |

**Response**

_Response shape not auto-detected — TBD._

### `GET /api3/task/set`

- **Controller**: `TaskController::set` (`protected/modules/api3/controllers/TaskController.php:6`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api3/controllers/TaskController.php:6](#) directly._

**Response**

_Response shape not auto-detected — TBD._

## See also

- [api-v3-mobile overview](./)
- [Authentication](../authentication.md)
- [Error codes](../error-codes.md)
