---
sidebar_position: 2
title: Authentication
---

# Authentication

## Token-based (api3, api4)

### Login

```http
POST /api3/login/index
Content-Type: application/x-www-form-urlencoded

login=agent1&password=plainPassword&deviceToken=fcm_or_apns_token
```

Successful response:

```json
{
  "success": true,
  "agent_id": 42,
  "user_id": 17,
  "diler_id": "ACME",
  "fio": "Иванов И.И.",
  "role": 4,
  "phone_number": "+998901234567",
  "token": "..."
}
```

Failure:

```json
{ "success": false, "error": "Неправильный логин или пароль" }
```

### Authorising subsequent calls

Pass `token` (and `deviceToken` for some endpoints) on every request, as a
form field or `Authorization: Bearer ...` header:

```http
POST /api3/order/create
Authorization: Bearer <token>
Content-Type: application/json

{ "client_id": "...", "lines": [...] }
```

Tokens are **per-device**: signing in from a second device invalidates the
first unless multi-device is explicitly enabled.

## License gating

`User::hasSystemActive(int $systemId)` is checked on login. Sample IDs:

| ID | System |
|----|--------|
| 1 | Web admin |
| 2 | Audit |
| 4 | Mobile agent |
| 5 | Online store |

If the licence has expired, login returns:

```json
{ "success": false, "error": "Срок лицензии программы истёк" }
```

## Logout

```http
POST /api3/logout/index
Authorization: Bearer <token>
```

Returns `{ "success": true }`. Clears the device token server-side.
