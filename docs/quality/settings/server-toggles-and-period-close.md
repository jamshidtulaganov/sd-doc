---
sidebar_position: 8
title: Server toggles and period close
audience: QA
---

# Server toggles and period close — the master switches

## What this feature is for

Three things live on this page:

- **Global parameters** — single key/value flags persisted into a JSON file (`params.json`) through the params admin screen. Each flag changes behaviour somewhere in Orders, Finans, or Stock the moment it is saved.
- **The sub-status config file** — a plain-text JSON file at `/upload/status_config.txt`. Each line declares one fine-grained "sub-status" label on top of the five main order statuses. Read by the order screen on every page render.
- **Period close** — per-data-model date locks. Once a model is locked at date `D`, rows in that model dated before `D` can no longer be created, edited, or deleted (except by listed roles).

Why these belong together: every one of them is a *meta switch* on the dealer's runtime, set once by an admin, read everywhere else. None of them have their own user-facing screen of consequence — the consequence is felt one module over.

## Who uses it and where they find it

| Role | Action | Path |
|---|---|---|
| Admin (1) | Edit every global parameter, the status config file, the period close | Web → Settings → Parameters (params); Web → Settings → Close day |
| Operator (3) | Same (some endpoints are admin-only — verify per dealer) | Same |
| Operations (5) | Read most parameters | Same |
| Anyone listed in a Close-day row's `ROLES` field | Bypass that specific period lock | — |
| Everyone else | No access | — |

## The workflow

```mermaid
flowchart LR
    A[Admin opens Parameters] --> B[Tabs: Financial, Features,<br/>Mobile, Visit, Integration, …]
    B --> C[Edit a flag — boolean, integer,<br/>selection, datetime, array]
    C --> D[Save → params.json updated]
    Note over C,D: QA-relevant: changes apply on the next request<br/>across every other module. No service restart needed.
    E[Admin opens /upload/status_config.txt<br/>via the status-config screen] --> F[Edit JSON]
    F --> G[Save — sub-status dropdown<br/>on the order screen refreshes]
    H[Admin opens Close day] --> I[Pick a data model<br/>Order, Finans, Purchase,<br/>Exchange, Corrector, Excretion,<br/>Purchase refund]
    I --> J{Lock by absolute date<br/>or by rolling day count?}
    J --> K[Optionally name the roles<br/>allowed to bypass the lock]
    K --> L[Save → Closed table updated.<br/>Edits on rows before the lock<br/>are blocked from the next request.]
```

## Step by step

### Global parameters

1. The admin opens **Settings → Parameters**. *The system shows tabs grouped by theme: financial, features, mobile, visit, integration, and a freeform list.*
2. The admin opens a flag and edits its value. Boolean flags are an on/off toggle; integer flags accept a number within `min-value` / `max-value`; selection flags accept one of the listed options; datetime flags accept a date.
3. *On save, the system writes the new value into the JSON file behind the scenes and reloads it on the next request.*
4. Each flag has a default value, used when the JSON file is missing or the key is absent.

### Sub-status config file

1. The admin opens the **status config** screen (the file behind it is `/upload/status_config.txt`).
2. *The system reads the file's content into a JSON object and shows it for editing.*
3. The admin edits the list and saves.
4. *On next page load, the order screen's sub-status dropdown lists exactly what is in the file.* An empty / missing file means no sub-status is offered.

### Period close

1. The admin opens **Settings → Close day**. *The system shows every data model that supports locks: order, finans, purchase, exchange, corrector, excretion, purchase refund.*
2. For each model the admin can either tick "by absolute date" and pick a date, or tick "by rolling day count" and pick a number (e.g. lock everything older than 7 days from today).
3. The admin can also list **roles allowed to bypass** the lock for that model.
4. *On save, the system upserts a row per model into the close-day table.* A model with no row is unlocked.
5. To unlock a model, the admin clears its tick and saves. *The system deletes that model's row.*
6. From the next request onward, every create / edit / delete on rows older than the lock is refused for any user not in the bypass list.

## What can go wrong (errors the user sees)

| Trigger | What the user sees | Plain-language meaning |
|---|---|---|
| Set an integer flag outside its `min`–`max` | Form-level validation error | Each parameter declares its bounds. |
| Save a malformed JSON in `status_config.txt` | Sub-status dropdown becomes empty | The system silently swallows the parse failure and renders zero sub-statuses. |
| `enableDeleteOrders` is off, user tries to delete an order | "Delete" button is hidden or refuses on submit | The whole delete-order flow is gated. |
| `enableImportOrders` is off, user opens the import-orders screen | Screen redirects or shows access-denied | Some installations also use a per-role check on top. |
| `enableMarkupPerProduct` is off, user opens the markup-per-product report | Report disappears from the menu | The menu is built from these flags on every render. |
| `debtNewOrder` is off, user creates an order through mobile as a van-seller / seller | The order skips the "delivered" status and is auto-set delivered; the debt row is created later | This is the most failure-prone toggle to test. |
| `disableOrderListV1` is on, user opens the old order-list page | The menu hides the entry | UI gating only. |
| `limitDayChangeDateload` set to 7, user tries to set an order's `DATE_LOAD` more than 7 days from the order's date | The system rejects the save with a "too far apart" message | The window applies to the `DATE` vs `DATE_LOAD` pair. |
| Period close on Finans at 2025-05-01, user with no bypass role tries to edit a payment dated 2025-04-15 | The save is refused | Working as designed. |
| Period close active, user with bypass role does the same edit | The save goes through | Working as designed. |

## Rules and limits

### Global toggles (commonly tested)

- **`enableDeleteOrders`** — controls the delete-order button on the orders module. Default behaviour with this off: orders can only be cancelled (status 5), not hard-deleted.
- **`enableImportOrders`** — gates the import-orders screen.
- **`enableMarkupPerProduct`** — toggles the markup-per-product report (and its menu entry).
- **`debtNewOrder`** — when on, a client-debt transaction is created the moment the order is created (status 1) for van-selling and seller agents. When off (the default), the debt row is created only when the order is delivered (status 3), and orders from those agent types are auto-set to delivered. Cross-tested in [Bonuses](../orders/bonuses.md), [Settlement](../finans/settlement.md), and the mobile order create flow.
- **`limitDayChangeDateload`** — max number of days between an order's `DATE` and `DATE_LOAD`. Default 21. Determines how far ahead / behind an order's delivery date can drift from its creation date.
- **`disableOrderListV1`** — hides the old order-list page from the menu.
- **`enableLotManagement`** — toggles lot-based stock; affects every stock workflow.
- **`enableInventoryDeletion`** — toggles the delete button on inventory documents.
- **`appAllowPriceTypes`** — allows manual price typing on the van-sell mobile flow.
- **`allowManualPriceForAgent`** — same idea for the agent mobile flow.
- **`stockModel`** — `FEFO` (first-expire-first-out, the default) or `FIFO`. Affects every stock-out write.
- **`enableBonusEvaluation`** — toggles the bonus-evaluation engine entirely.
- **`isDemo` / `Demo`** — demo lockdown. Forbids password and login changes; UI labels demo behaviour.
- **`liteVersion`** — strips advanced features from the UI.
- **`integration-<vendor>`** — per-integration on/off, e.g. `integration-idokon`, `integration-1c`.
- **`roundingDecimalsMoney` / `roundingDecimalsQuantity` / `roundingDecimalsVolume`** — global number-format precision.
- **`visitDistance`** — accepted only between 50 and 250; controls when a visit counts as fulfilled.
- **`skidkaAllowUpdate`** — lifts the "discount used by order" edit lock. See [Discount rules](./discount-rules.md).

### Sub-status config file

- **Path: `/upload/status_config.txt`.** Plain text JSON.
- **Missing or unparseable → empty sub-status dropdown.** The system never raises an error for this.
- **Hot reload.** No service restart needed; the next page render reads the new file.

### Period close (Closed table)

- **Supported models** on the admin screen: `order` (sale, exchange, return), `finans` (cashbox payments and expenses), `purchase` (goods receipt), `exchange` (stock transfer), `corrector` (stock correction), `excretion` (stock write-off), `purchase_refund` (return to supplier).
- **Two lock modes per model.** Absolute date, *or* a rolling day count. The admin picks one of the two at save time via the "by_date" / "by_day" radio.
- **Bypass roles** are a comma-joined list. Users in those roles can save rows dated before the lock.
- **Unlock** = clear the tick for that model and save; the system deletes that row.
- **`access_dealer` row is special** — the admin save loop explicitly skips it; that lock is dealer-cross and not configurable here.

## What to test

**Happy paths**
- Toggle `enableDeleteOrders` on; verify the delete button appears for an admin on an open order. Toggle off; verify the button hides.
- Toggle `enableImportOrders` on / off; verify the import-orders entry appears / hides from the menu.
- Set `limitDayChangeDateload` to 7; create an order with `DATE_LOAD` 8 days later → expect rejection. Set it 3 days later → accepted.
- Save a fresh sub-status JSON; verify the order screen's dropdown shows the new options.
- Lock the order period at 30 days ago. Edit an order from 60 days ago as a non-bypass user → blocked; as a bypass user → allowed.

**Validation**
- Set an integer flag outside its bounds → form-level error.
- Save a parameter with the wrong type (e.g. an array where boolean is expected) → form-level error.
- Save corrupted JSON to the status config → next page render shows zero sub-statuses with no error banner.
- Save a Closed row without picking either "by date" or "by day" → no save (the form drops it).

**Role gating**
- Admin can open the parameters screen; operator usually can; agent / cashier / expeditor cannot.
- Close-day screen is gated on the close-day permission. Verify the bypass roles list works for each model separately.

**Cross-module impact** (most important for these toggles)
- `debtNewOrder` off: create an order on mobile as a van-seller; verify the order lands on status 3 (delivered) and a debt row exists on the client. Switch `debtNewOrder` on; create another order; verify the order stays at status 1 and the debt row is also created immediately.
- `debtNewOrder` on: pair with the [Settlement](../finans/settlement.md) tests — the COMPUTATION on the new invoice row should be open.
- `enableDeleteOrders` off: try every entry-point that previously deleted orders — web admin, mobile expeditor, API. All should refuse.
- `enableLotManagement` on: the stock screens grow a lot picker; off — the picker disappears. See the stock QA pages.
- `stockModel = FIFO`: a stock-out picks earliest-arrived lot; `FEFO`: earliest-expiring lot. Run the same outflow in both modes and verify the lot picked differs.
- `appAllowPriceTypes` and `allowManualPriceForAgent`: on mobile, verify the manual-price field on the line is editable only when the right toggle is on (and the price type has hand-edit). See [Price types](./price-types.md).
- Sub-status config: lock the order to a sub-status only available in the new JSON, then revert the JSON; the order keeps its sub-status value because the order screen reads the field directly, but the dropdown stops offering that value.
- Period close on Finans: try to create a payment dated before the lock from the finans screen, from the mobile, from API — all paths should refuse.
- Period close on Order: try to edit, return, defect, or cancel an order before the lock; all should refuse.

**Side effects**
- Many toggles are read once per request — flipping a flag does not affect an already-loaded page until the user navigates.
- Saving a parameter writes the JSON file; verify the file's mtime updates and the new value survives a page reload.
- Period-close rows are deleted (not soft-deleted) when the model is unticked. To audit history, capture the row before unlocking.
- Bypass-role list is the only way to let a person edit a locked period — it cannot be done from the UI without putting the user's role into the list.

## Where this leads next

- For order creation paths affected by `debtNewOrder`, see [Create order (web)](../orders/create-order-web.md), [Create order (mobile)](../orders/create-order-mobile.md), and [Mobile payment](../orders/mobile-payment.md).
- For period-close interactions with finans, see [Settlement](../finans/settlement.md) and [Manual correction](../finans/manual-correction.md).
- For the stock model (`FIFO` vs `FEFO`) consequences, see the stock-balance and stock-receipt pages in the Stock QA guide.
- For the discount-rule edit lock and the `skidkaAllowUpdate` override, see [Discount rules](./discount-rules.md).
- For sub-status visibility on the order screen, see [Status transitions](../orders/status-transitions.md).

## For developers

Developer reference: `protected/models/ServerSettings.php`, `protected/modules/settings/components/ParamStoreService.php`, `protected/modules/settings/controllers/ParamsController.php`, `protected/modules/settings/controllers/ClosedController.php`, `protected/models/Closed.php`, `protected/modules/settings/views/params/params-list.php`.
