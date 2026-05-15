---
title: "api-v3-mobile · Client"
sidebar_position: 1
---

# api-v3-mobile · `ClientController`

Endpoints for `ClientController` (`protected/modules/api3/controllers/ClientController.php`). 17 action(s).

### `GET /api3/client/index`

- **Controller**: `ClientController::index` (`protected/modules/api3/controllers/ClientController.php:87`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api3/controllers/ClientController.php:87](#) directly._

**Response**

_Response shape not auto-detected — TBD._

### `GET /api3/client/addClient`

- **Controller**: `ClientController::addClient` (`protected/modules/api3/controllers/ClientController.php:388`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api3/controllers/ClientController.php:388](#) directly._

**Response**

_Response shape not auto-detected — TBD._

### `POST /api3/client/avatar`

- **Controller**: `ClientController::avatar` (`protected/modules/api3/controllers/ClientController.php:1933`)

**Request**

| Name | In | Type | Required |
|---|---|---|---|
| `base64` | body | _string_ | TBD |
| `photo` | body | _string_ | TBD |
| `client_id` | body | _string_ | TBD |
| `is_main` | body | _string_ | TBD |
| `id` | body | _string_ | TBD |

**Response**

_Response shape not auto-detected — TBD._

### `GET /api3/client/dayTransactions`

- **Controller**: `ClientController::dayTransactions` (`protected/modules/api3/controllers/ClientController.php:2068`)

**Request**

| Name | In | Type | Required |
|---|---|---|---|
| `weekTypes` | query | _string_ | TBD |
| `v` | query | _string_ | TBD |

**Response**

_Response shape not auto-detected — TBD._

### `GET /api3/client/debitor`

- **Controller**: `ClientController::debitor` (`protected/modules/api3/controllers/ClientController.php:945`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api3/controllers/ClientController.php:945](#) directly._

**Response**

_Response shape not auto-detected — TBD._

### `POST /api3/client/delete`

- **Controller**: `ClientController::delete` (`protected/modules/api3/controllers/ClientController.php:2009`)

**Request**

| Name | In | Type | Required |
|---|---|---|---|
| `photo_id` | body | _string_ | TBD |

**Response**

_Response shape not auto-detected — TBD._

### `GET /api3/client/inventory`

- **Controller**: `ClientController::inventory` (`protected/modules/api3/controllers/ClientController.php:832`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api3/controllers/ClientController.php:832](#) directly._

**Response**

_Response shape not auto-detected — TBD._

### `GET /api3/client/orderDebt`

- **Controller**: `ClientController::orderDebt` (`protected/modules/api3/controllers/ClientController.php:1304`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api3/controllers/ClientController.php:1304](#) directly._

**Response**

_Response shape not auto-detected — TBD._

### `GET /api3/client/orders`

- **Controller**: `ClientController::orders` (`protected/modules/api3/controllers/ClientController.php:1400`)

**Request**

| Name | In | Type | Required |
|---|---|---|---|
| `client_id` | param | _string_ | TBD |
| `clientId` | param | _string_ | TBD |
| `from` | param | _string_ | TBD |
| `to` | param | _string_ | TBD |
| `limit` | param | _string_ | TBD |
| `offset` | param | _string_ | TBD |

**Response**

_Response shape not auto-detected — TBD._

### `GET /api3/client/pending`

- **Controller**: `ClientController::pending` (`protected/modules/api3/controllers/ClientController.php:8`)

**Request**

| Name | In | Type | Required |
|---|---|---|---|
| `deviceToken` | param | _string_ | TBD |
| `limit` | param | _string_ | TBD |
| `offset` | param | _string_ | TBD |

**Response**

_Response shape not auto-detected — TBD._

### `GET /api3/client/revise`

- **Controller**: `ClientController::revise` (`protected/modules/api3/controllers/ClientController.php:1089`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api3/controllers/ClientController.php:1089](#) directly._

**Response**

_Response shape not auto-detected — TBD._

### `GET /api3/client/reviseDebt`

- **Controller**: `ClientController::reviseDebt` (`protected/modules/api3/controllers/ClientController.php:1771`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api3/controllers/ClientController.php:1771](#) directly._

**Response**

_Response shape not auto-detected — TBD._

### `GET /api3/client/sendNotification`

- **Controller**: `ClientController::sendNotification` (`protected/modules/api3/controllers/ClientController.php:57`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api3/controllers/ClientController.php:57](#) directly._

**Response**

_Response shape not auto-detected — TBD._

### `POST /api3/client/setMain`

- **Controller**: `ClientController::setMain` (`protected/modules/api3/controllers/ClientController.php:2045`)

**Request**

| Name | In | Type | Required |
|---|---|---|---|
| `photo_id` | body | _string_ | TBD |

**Response**

_Response shape not auto-detected — TBD._

### `GET /api3/client/spravochnik`

- **Controller**: `ClientController::spravochnik` (`protected/modules/api3/controllers/ClientController.php:320`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api3/controllers/ClientController.php:320](#) directly._

**Response**

_Response shape not auto-detected — TBD._

### `GET /api3/client/toptrending`

- **Controller**: `ClientController::toptrending` (`protected/modules/api3/controllers/ClientController.php:248`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api3/controllers/ClientController.php:248](#) directly._

**Response**

_Response shape not auto-detected — TBD._

### `GET /api3/client/transactions`

- **Controller**: `ClientController::transactions` (`protected/modules/api3/controllers/ClientController.php:888`)

**Request**

_No parameters detected from source. May be a no-arg endpoint, or params are derived via action-class properties. Inspect [protected/modules/api3/controllers/ClientController.php:888](#) directly._

**Response**

_Response shape not auto-detected — TBD._

## See also

- [api-v3-mobile overview](./)
- [Authentication](../authentication.md)
- [Error codes](../error-codes.md)
