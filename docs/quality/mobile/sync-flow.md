---
sidebar_position: 3
title: Sync flow — login to ready
audience: QA
---

# Sync flow — login → config → clients → products → routes

## What this feature is for

When a field agent opens the app in the morning and signs in, a **chain of server calls** runs before the agent can take a single order. The chain hydrates the phone with everything it needs: the configuration packet, the list of clients, the product catalogue, the price lists, the warehouses, the route for the day. If any link in the chain is slow, broken or returns stale data, **the agent cannot work**.

This page is about the chain itself: what runs, in what order, where api3 and api4 diverge, and where the server's duplicate-protection lives.

## Who uses it and where they find it

The chain runs **transparently** every time the user signs in to the mobile app. The user sees a progress spinner; they do not pick which calls run. Internally:

| App | Role | What hits the server | Channel mix |
|---|---|---|---|
| sd-agents | Agent (4) | The full chain below | api3 + api4 |
| sd-delivery | Expeditor (10) | Login → config (expeditor packet) → deliveries → routes | api4 |
| sd-audit | Supervisor (8), Merchandiser (11) | Login → config → clients → audit forms | api3 + api4 |
| sd-stockman | Stockman (20) | Login → config → assigned orders | api4 |

This page focuses on the **sd-agents** chain because it is the largest and most-tested.

## The workflow

```mermaid
sequenceDiagram
    autonumber
    participant App as sd-agents app
    participant Auth as /login
    participant Cfg as /config
    participant Cli as /clients
    participant Cat as /catalog/products etc.
    participant Pr as /catalog/prices
    participant Vis as /visits
    participant DB as Sales DB

    App->>Auth: POST { login, password, deviceId, deviceModel, fcm_token, app:'agent' }
    Note over Auth: ⚠ Verifies password, license,<br/>role == 4, optional device-limit (3).<br/>Returns a device token.
    Auth->>DB: read User; write Device + DEVICE_TOKEN
    Auth-->>App: token, role, server_time, support phone

    App->>Cfg: GET /config (with deviceToken)
    Note over Cfg: ⚠ api3 also writes a GPS row<br/>(TYPE='sync') as a side effect.<br/>api4 does not.
    Cfg-->>App: ~100 KB JSON: packet + bonuses + visit operations + features

    App->>Cli: GET /clients (visiting-scoped)
    Cli-->>App: array of clients with balance, coordinates, phone, photo

    App->>Cat: GET /catalog/products, /trades, /warehouses, /unit, /tara…
    Cat-->>App: full catalogue arrays

    App->>Pr: GET /catalog/prices (allowed price types only)
    Pr-->>App: { product_id → price by price_type }

    App->>Vis: GET /visits for today (route)
    Vis-->>App: ordered list of clients to visit today

    Note over App: Now the agent can open a visit and take an order.

    rect rgb(230, 240, 250)
        Note over App,DB: When the agent submits an order:<br/>1. App generates a GUID (api4) or mobile_order_id (api3)<br/>2. Server checks for duplicate FIRST<br/>3. If new — validate, save, return.<br/>4. If duplicate — short-circuit.
    end
```

## Step by step

### 1. Login

1. *The app sends login, password, deviceId, deviceModel and an FCM push token to `/login`.* On api4 the request is JSON over POST; on api3 it is form-encoded.
2. *The server verifies, in order:*
    - The user exists, is active, and the password hash matches.
    - The dealer's license is still paid (`hasSystemActive(4)`).
    - On api4: the role matches the declared app (`app: 'agent'` requires `ROLE = 4`).
    - On api4: if the dealer has `enableDeviceControl` on, the user has fewer than 3 devices already registered — otherwise the login is rejected with `device_limit_reached`.
3. *The server returns a device token.* The phone stores it and includes it in every subsequent request.

### 2. Config fetch

4. *The app calls the config endpoint.* api3 returns a single massive blob (the agents-packet plus bonuses, visit operations, manual bonus IDs, etc.). api4 splits the same data into smaller per-role endpoints (e.g. `/api4/config/expeditor` for the delivery app).
5. *Side effect on api3:* if the body of the request contains a `device` object, the server **also writes a GPS row** with `TYPE = 'sync'`. This is how the server gets a position sample at app startup. api4 does not piggy-back GPS on config — it has a separate `/api4/create/gps` endpoint.

### 3. Clients

6. *The app fetches the client list.* The server returns only clients the agent is supposed to visit (scoped by the agent's visiting calendar / route). The response includes each client's master coordinates, balance, debt, last-visit date and any verification flags.
7. *The price-type, currency and finans toggles affect this call.* On a finans-enabled dealer the response includes per-currency balances; on a contragent-enabled dealer it uses the `ClientTransaction` table.

### 4. Products, prices, dictionaries

8. *The app fetches the catalogue.* api3 calls `/api3/product` (one big endpoint) plus a handful of helpers. api4 has many small endpoints under `/api4/catalog/`: products, categories, sub-categories, brands, trades, price types, payment types, prices, warehouses, units, tara, photo categories, reasons, etc.
9. *Prices are scoped.* The phone only receives the price types it is allowed to quote, configured per agent in the agents-packet.

### 5. Routes

10. *The app fetches today's visits.* The visit list is scoped to the agent's user id and today's date; it is the **ordered list of clients to call on**.

### 6. Ready

11. *The app shows the route screen.* From here, every check-in and every order submit flows through its own endpoint — but those are no longer "sync"; they are individual transactions and are covered on their own pages.

## Where api3 and api4 differ

| Concern | api3 | api4 |
|---|---|---|
| **Login transport** | Form-encoded GET/POST | JSON over POST |
| **Auth header** | `deviceToken` in query or `HTTP_DEVICETOKEN` header | `deviceToken` header, bound to a `Device` row |
| **Device limit** | None (up to 4 rolling tokens kept) | 3 devices max when `enableDeviceControl` is on |
| **Config shape** | One enormous JSON | Many small JSONs, scoped per role |
| **GPS at config** | Yes — `/api3/config` writes a sync GPS row as a side effect | No — GPS uses its own endpoint |
| **Error format** | `{ success: false, error: "Неправильный логин или пароль" }` | `{ status: false, error: "invalid_login_or_password", errorMessage: "..." }` |
| **Token in response** | The same `deviceToken` the phone sent (rolled into the user's `DEVICE_TOKEN` array) | A fresh `random_bytes(32)` token, stored in a `Device` row |
| **License-expired message** | Russian-only `"Срок лицензии программы истёк"` | Localised by `lang` header to ru / uz / en |
| **Order submit duplicate gate** | `SyncLog` row keyed by `deviceToken + mobile_order_id + DAY` | `SyncLog` row keyed by `mobile_uuid` + agent + client |
| **Behaviour on duplicate** | Returns the **cached success** of the first call (same order ID) | Returns `ERROR_CODE_SYNC_PROCESSING` if still in flight, or the **cached success** if already saved |

**Test plans must always say which channel.** Apps in production today are mostly api4 but a long-tailed minority still hit api3 endpoints.

## Duplicate-submit protection — how it works on each channel

### api4 — GUID (`mobile_uuid`)

The mobile app generates a fresh GUID for each new order at the moment the agent finishes building it. That GUID is included in the submit. The server:

1. Looks up `SyncLog` by `(agent_id, user_id, client_id, mobile_uuid, type='order', token, day)`.
2. If status is **PROCESSING** → returns `ERROR_CODE_SYNC_PROCESSING`. The phone should display *"order is in process"* and not retry immediately.
3. If status is **SUCCESS** → returns the **same response** as the original submit (the order id and the bonus id). Idempotent.
4. If no row exists → creates one with status `PROCESSING`, validates the order, saves it, flips the row to `SUCCESS`. On any validation failure the row is **deleted** so the agent can resubmit a corrected order with the **same** GUID.

The GUID survives app kills and OS-level retries: the phone keeps the GUID with the draft until the server confirms.

### api3 — `SyncLog` keyed by device + mobile order id

api3 has no GUID. Instead, the app sends a `mobileOrderId` (an integer the app generates on creation) plus the request's `deviceToken`. The server:

1. Deletes any stale `SyncLog` rows older than 20 seconds for the same device + mobile order id where status is not `success`. This is the **20-second window**.
2. Looks up `SyncLog` by `(day, deviceToken, mobileOrderId)`, or fallback by `(deviceToken, mobileOrderId)` without the day filter.
3. If status is `wait` → another submit is in flight. Returns nothing useful; the phone should retry.
4. If status is `success` → returns the cached `orderId`.
5. Otherwise → creates a `wait` row, validates, saves the order, flips the row to `success`.

**Consequence worth testing:** after 20 seconds with the same `mobileOrderId`, a stale `wait` row is *deleted* by the next submit, which then proceeds afresh. This means a long-delayed retry of the same `mobileOrderId` can create a duplicate order. The api4 GUID closes this hole because GUID lookup ignores time.

## What can go wrong

| Trigger | What the agent sees | Plain meaning |
|---|---|---|
| Wrong password | *"Неправильный логин или пароль"* (api3) or `invalid_login_or_password` (api4) | Check credentials. |
| License unpaid | *"Срок лицензии истёк"* | The dealer owes money — login is refused until paid. Test this on a demo tenancy. |
| Login with role != 4 to the agent app (api4) | `access_denied` | Operator/expeditor accounts cannot use the agent app. |
| Fourth phone tries to log in as the same user with `enableDeviceControl=Y` | `device_limit_reached` | Strip an old device in **Settings → Devices** first. |
| Config call fails mid-sync | Spinner stalls; app cannot show the visit list | Network or server error. Verify retry works without re-logging-in. |
| Clients call returns 0 clients | Empty visit list | Either the agent's calendar is empty for today or the agent's `AGENT_ID` is wrong. |
| Prices call returns no price for a product | Product shown but cannot be added to an order | A price type assignment is missing; the agent must pick a different price type or contact the operator. |
| Order submit with stale GUID (api4) | Server replays the same order id | This is correct behaviour, not a bug. |

## Rules and limits

- **The chain is sequential.** The app does not show the visit screen until every step has succeeded. Verify that a slow step does not produce a partial / broken state.
- **Tokens are per-device, kept in a JSON array.** Logging in from a fifth phone shifts out the oldest. With `enableDeviceControl` the fourth phone is refused outright.
- **`fcm_token` is stored on `User` at login.** It is overwritten on every successful login. Make sure logging out of one phone does not silently disable push to another phone — the FCM token is single-valued.
- **api3 config is huge.** Slow phones may take several seconds to parse the response. The packet's size depends on the per-dealer bonus, photo and visit-operation configuration.
- **The 20-second `SyncLog` window in api3 is a real edge case.** Test it: tap Submit, kill the app, wait 25 seconds, reopen. Some app builds will reuse the same `mobileOrderId` and create a duplicate. Some will mint a fresh one and avoid it. Document which.
- **`SyncLog` rows are not garbage-collected by a job.** They accumulate. A dealer that has been in production for years has millions. Investigate slow-submit reports against table size.
- **A failed validation deletes the `SyncLog` row (api4).** A re-submit with the same GUID after fixing the validation error should succeed. Verify.
- **Login bumps the user's `PASSWORD` field on api3** to the clear-text password (legacy bug — kept for back-compat). On api4 it doesn't. Don't flag this as a regression on api3.

## What to test

### Happy paths

- Cold start, fresh login, full sync chain completes; agent reaches the visit screen.
- Re-login from the same phone — sync chain shorter but still completes.
- Logout, then login with a different agent on the same phone — verify the old agent's data is wiped.

### Login failures

- Wrong password → error message + no token.
- Active=N user → same error as wrong password (timing-safe).
- License unpaid → license-expired error.
- Login as operator to the agent app (api4) → `access_denied`.
- Login from a fourth device with `enableDeviceControl=Y` → `device_limit_reached`.

### Config edge cases

- Dealer with **finans off** — config still completes; client balances are nil.
- Dealer with **contragent on** — verify balance source switches.
- Dealer with markirovka enabled (Uzbekistan) — config includes `features: ["labelcode"]`.

### api3 vs api4 channel parity

- Same agent, same data, sync chain on api3 vs api4: visit list identical, product list identical, price list identical.
- Logout from api4 → log in to api3 in an older app build → sync still completes (tokens are separate).

### Duplicate-submit protection (api4 — GUID)

- Tap Submit twice in quick succession. Second response is `ERROR_CODE_SYNC_PROCESSING`. Only one order exists.
- Tap Submit, kill the app immediately, reopen, let it resync. Only one order. Second submit returns the cached success.
- Tap Submit with all valid data; expect SUCCESS. Re-tap Submit with the same GUID and **different** lines. Server returns the original order — the second tap is ignored. **Verify the new lines are not applied.**

### Duplicate-submit protection (api3 — SyncLog)

- Tap Submit twice in quick succession. Second response is the cached success of the first.
- Tap Submit, wait 21 seconds, retap. Depending on app build, this can create a duplicate order. **Flag as a known limitation.**
- Two phones logged in as the same agent, both tap Submit on the same client at the same minute. Verify both succeed independently (different `mobileOrderId` or different `deviceToken` — both keep `SyncLog` rows separate).

### Side effects to verify

- A `Device` row exists per phone (api4 with device-control on).
- A `SyncLog` row exists per submitted order with `STATUS = 'success'`.
- An api3 sync writes a `Gps` row with `TYPE = 'sync'`; api4 does not.
- The `FCM_TOKEN` column on `User` reflects the latest login.
- Battery, signal and gps_status from the most recent ping land in `Gps` correctly.

## Where this leads next

Once the sync chain finishes the agent can start working through the route — see [Create order — mobile](../orders/create-order-mobile.md) for the order submit step. GPS pings flowing during the day are covered in [GPS tracking](./gps-tracking.md). Notifications fired off as a side effect of the day's events are covered in [Notifications](./notifications.md).

## For developers

Developer reference: `docs/modules/sync.md`, `docs/api/api-v3-mobile/index.md`, `docs/api/api-v4-mobile.md`. The duplicate-protection logic on api4 is in `application.modules.api4.actions.agent.CreateOrderAction::checkSyncLog`; on api3 it is inlined in `OrderController::actionIndex`.
