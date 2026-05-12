---
sidebar_position: 3
title: Outgoing invoices (Реализация)
audience: QA
---

# Outgoing invoices — Реализация

## What this feature is for

When the dealer sells regulated goods (tobacco, alcohol, dairy, etc.) to a customer, the law requires an **electronic invoice (ESF)** to accompany the shipment, and the CIS codes on every pack must first be confirmed to be valid and owned by the dealer. The Markirovka *Реализация* (Sale) screen is where the dealer reviews their orders for the day, checks the CIS codes attached to each, creates the ESF on the chosen operator (Didox or Faktura.uz), and signs it with the company's electronic certificate.

In plain terms: this screen is the **outbound paperwork tray** for marked goods. It does not move stock or take payment — those flows happen in Orders and Finans. Реализация is where the CIS-code and ESF compliance steps get walked through, one order at a time or many at once.

## Who uses it and where they find it

| Role | Action | Path |
|---|---|---|
| Accountant / operator | Reviews orders with marked goods, creates ESFs, signs them | Web → Маркировка → Реализация |
| Compliance officer | Verifies CIS codes against the state tracker before ESF is issued | Same page → CIS status chip → *Проверить КИ* |
| Director / signatory | Signs the ESF with EIMZO when prompted | Same page → ESF status chip → flow continues on operator-side dialog |
| Same roles (bulk) | Run create/check/delete/code-check across many orders at once | Same page → tick row checkboxes → *Групповая обработка* |

RBAC permission required: **operation.marking.outgoing**. Users without it see no menu entry and get a 403 on the URL.

## The workflow

```mermaid
sequenceDiagram
    participant U as Dealer user
    participant W as Web page (Реализация)
    participant SD as sd-main backend
    participant AB as Aslbelgisi tracker
    participant OP as ESF operator<br/>(Didox / Faktura.uz)

    Note over U,W: 1. Page load — list orders with CIS codes
    U->>W: Open Маркировка → Реализация
    W->>SD: GET outgoing invoices (today's range)
    SD-->>W: orders + CIS status + ESF status

    Note over U,AB: 2. Check CIS codes for one order
    U->>W: Row menu → "Проверить КИ"
    W->>SD: POST /check-order-cises
    SD->>SD: Mark order CIS status = Processing<br/>+ queue background job
    W->>W: Chip spinner shown; page stays interactive
    SD->>AB: Verify each code (in background)
    AB-->>SD: per-code results
    SD->>SD: Set CIS status = OK / Codes-error /<br/>Quantity-mismatch
    W->>W: Poll completes; row reloads

    Note over U,OP: 3. Create ESF on operator
    U->>W: ESF chip → "Сформировать ЭСФ"
    W->>OP: Build & submit invoice<br/>(via stored login)
    OP-->>W: ESF document ID
    W->>SD: persist ESF link to order

    Note over U,OP: 4. Sign ESF (EIMZO)
    U->>W: Sign action (browser plugin)
    W->>OP: send signed payload
    OP-->>W: status = Signed
    W->>SD: refresh row

    Note over U,W: 5. Bulk variants
    U->>W: Tick rows + Групповая обработка → action
    W->>W: Loop with progress dialog<br/>(per-row success/failure)
```

## Step by step

1. *The user opens **Маркировка → Реализация***. The system loads orders whose lifecycle dates fall in the chosen range and displays them, joined with their CIS status and ESF status.
2. The user can switch the date field between **Дата заявки** (order date) and **Дата отгрузки** (shipment date) and pick a date range using the picker, then press *Загрузить*.
3. *The system shows each row with*: order ID, order date, shipment date, order status (Новый / Отгружен / Доставлен / Возврат / Отменён), CIS status chip, ESF status chip, client name and TIN, expeditor, totals, and the ESF document ID once issued.
4. *The system applies three top-row filters* (when the user picks them): *all orders / only orders with codes / only orders without codes*, an order-status multi-select, and a payment-method multi-select. The filters work on the local cache; no reload.
5. **To check CIS codes for one order:** the user opens the CIS-status chip menu and clicks *Проверить КИ*. ⛔ if the row says *Отсутствует КИ* (no CIS codes), the chip is read-only — there is literally nothing to check.
6. *The system flips the chip to **Проверка…** with a spinner* and queues a background job. The page stays fully interactive — the spinner only sits on that one row. ⛔ if the dealer has no Aslbelgisi API key on file, the request fails with an authentication error and the chip stays unchanged.
7. *The background job calls the state tracker* for each code on the order. When done, the chip flips to one of four resting states: *Ожидает проверку*, *Проверен*, *Содержит ошибку*, or *Кол. не совп.* (quantity mismatch).
8. **To download all valid CIS codes for an order** (after a successful check): the user clicks *Скачать КИ* on the chip menu. ⛔ this menu item is only visible when the order has CIS codes; the system serves them as a plain `.txt` file named `<orderId>_cises.txt`.
9. **To create the ESF on the operator:** the user opens the ESF chip menu and clicks *Сформировать ЭСФ*. ⛔ if the company's profile has no ESF operator selected, the system shows the warning *Пожалуйста, выберите оператора ЭСФ в настройках профиля компании* and stops.
10. *The system builds the invoice payload and submits it* to the chosen operator using the dealer's stored login. If the operator login has expired, the system pops the operator-login dialog first and only retries after a successful login.
11. *The system stores the returned ESF document ID against the order* and flips the chip from *Ожидает отправку ЭСФ* to *Ожидает вашей подписи*.
12. **To check the status of a pending ESF:** the user opens the ESF chip menu and clicks *Проверить статус*. *The system asks the operator* whether the document was signed since the last check and updates the chip if so.
13. **To sign an ESF:** the user invokes the operator-side sign flow which uses the EIMZO browser plugin and the company's electronic signature certificate. (The sign UI itself is provided by the operator's integration, not by this page.) On success, the chip becomes *Подписан* — green, with a shield icon — and stays read-only.
14. **To delete a pending (unsigned) ESF:** the user opens the chip menu, clicks *Удалить*, and confirms in the warning dialog *Вы уверены, что хотите удалить ЭСФ?*. ⛔ deletion is only offered while the ESF is still *Ожидает вашей подписи* — once signed, there is no delete action.
15. **For a group of orders:** the user ticks the row checkboxes and clicks *Групповая обработка* in the toolbar. The available bulk actions are: *Сформировать ЭСФ*, *Проверить статус ЭСФ*, *Удалить ЭСФ*, *Проверить коды*. ⛔ each opens a confirmation *Данная операция может занять некоторое время. Вы действительно хотите продолжить?* (or, for delete, *Вы уверены что хотите удалить ЭСФ для выбранных заявок?*).
16. *The system runs the chosen action one order at a time*, showing a circular progress dialog with a percentage. The user can press *Прервать* at any time to stop after the current order finishes. ⛔ if the company has no ESF operator selected, the bulk runs that need one show the same "please pick an operator" warning and abort.
17. *At the end of the bulk run, the system shows a result dialog*: count successful, count failed, and a list of failure messages prefixed by the order ID.
18. **To drill into one order's ESF detail page:** the user clicks the order ID, the document ID link, or the *Посмотреть КМ* item on the CIS chip menu.
19. **To open the ESF directly on the operator's web UI:** the user clicks the *Документ ЭСФ* cell — for *didox* it links to `didox.uz/documents/{id}`, for *faktura* it links to `app.faktura.uz/ru/document/details/{id}`.

## What can go wrong (errors the user sees)

| Trigger | Error / behaviour | Plain-language meaning |
|---|---|---|
| ESF operator not chosen in company profile | Warning: *Пожалуйста, выберите оператора ЭСФ в настройках профиля компании* | Pick Didox / Faktura.uz / Soliq Servis once in the company profile before this screen is usable. |
| Aslbelgisi API key missing or expired | Toast / snackbar with auth error | The dealer's connection to the state tracker is not configured. |
| Operator login expired during create/sign | Operator-login dialog opens; action retried after login | Routine — the dealer's session at Didox / Faktura.uz timed out. |
| Order has no CIS codes (chip shows *Отсутствует КИ*) | Read-only chip; no menu | This order has no scanned codes, so there is nothing to check or sell as regulated. |
| State tracker rejects at least one code | Chip = *Содержит ошибку* | One or more codes are unknown, in a wrong state, or owned by another INN. Investigate before issuing an ESF. |
| Number of codes ≠ order's product quantities | Chip = *Кол. не совп.* | The order is for 100 boxes but 95 or 105 codes were scanned. |
| Delete attempted on a *Подписан* ESF | No menu item is visible | Signed ESFs cannot be deleted from this screen — they must be cancelled on the operator side. |
| Bulk operation aborted mid-run | Progress halts; result dialog shows partial counts | The user pressed *Прервать*. The orders already processed keep their new state; the rest are untouched. |
| Bulk operation: one order fails | Failed count increments; the message is shown in the result dialog | The other orders continue — failures do not abort the batch unless the user presses *Прервать*. |
| User without `operation.marking.outgoing` opens the URL | 403 Access Denied | The role is not allowed to see outgoing invoices. |
| EIMZO plugin not installed when signing | Browser-side error from EIMZO | The signer's machine needs the EIMZO plugin and a loaded certificate. |

## Rules and limits

- **The screen reads from sd-main's local order table.** It is the same order data as the Orders module — this screen only adds the CIS and ESF columns on top.
- **An order without CIS codes is not actionable on this screen.** It will still appear in the list if it has the right date and the user chose *All orders* in the filter, but the chip will be read-only.
- **The CIS check must pass before issuing an ESF in practice.** The system does not technically block ESF creation on an error-state row, but compliance policy requires a green CIS chip. Test plans should confirm the policy with the team — the code does not enforce it.
- **Only Didox and Faktura.uz are wired up for ESF create/delete/check.** *Soliqservis* is listed as a valid operator in the data model but not implemented for these actions. If a company is configured for Soliqservis, the create/delete/check flows will not run.
- **Signing is delegated to the operator's own UI.** This screen never signs by itself — it just shows the post-signature state.
- **Bulk operations are per-row, not transactional.** A failure on order 5 of 50 does not roll back orders 1–4.
- **The page polls in the background after a CIS check is queued** — refreshing the browser does not lose the result; the next poll completes the chip transition.
- **Column-picker choices, sort order, and rows-per-page persist** to local storage under the key `markirovka.outgoing-esf.documents-table`. Switching browsers loses them.

## What to test

### Happy paths

- Open the screen and verify orders for today's date load with correct CIS and ESF chips.
- Switch the date field between *Дата заявки* and *Дата отгрузки*; reload; verify the rows change accordingly.
- On an order with valid codes, click *Проверить КИ*; watch the chip flip *Проверка…* → *Проверен*.
- On a verified order, click *Сформировать ЭСФ*; verify ESF chip becomes *Ожидает вашей подписи* and the document ID appears.
- Sign the ESF via the operator-side flow; click *Проверить статус*; verify chip becomes *Подписан*.
- Click *Скачать КИ* on a verified order; verify the `.txt` file downloads with one CIS per line.
- Run each bulk action (*Сформировать ЭСФ*, *Проверить статус ЭСФ*, *Проверить коды*) on 3–5 orders; verify the progress dialog and the per-row results.

### Validation failures

- Run *Проверить КИ* on an order whose codes are not in the state tracker. Expect chip = *Содержит ошибку*.
- Run *Проверить КИ* on an order where the count of codes differs from the order quantity. Expect chip = *Кол. не совп.*.
- Attempt *Сформировать ЭСФ* with no operator selected in the company profile. Expect the warning, no API call made.
- Attempt the same with an expired operator login. Expect the operator-login dialog and a clean retry after re-login.

### Role gating

- Open `/markirovka/view/outgoingInvoices` as a user without `operation.marking.outgoing`. Expect 403.
- Open it as a role that has the permission but no EIMZO certificate. Verify they can create an ESF but not sign it.

### Edge cases

- Filter to *Только заявки с КИ*; verify only orders with CIS codes are listed (CIS-status chip ≠ *Отсутствует КИ*).
- Filter to *Заявки без кодов*; verify only orders without CIS codes are listed.
- Combine a status filter (e.g. *Отгружен*) and a payment-method filter. Verify both apply on the local cache without a server reload.
- Tick rows, then change the date range and press *Загрузить*. Verify the selection is reset to match the new data.
- Run a bulk action of 50+ orders; press *Прервать* halfway. Verify the result dialog shows the partial counts and that the remaining rows are unchanged.
- Reload an order via the row's own *Проверить статус ЭСФ* — confirm only that one row reloads, not the whole table.
- Open an order with both `cises` data and `items` (count-and-product rows). Verify both lists render in the detail drilldown.

### Side effects to verify

- After *Сформировать ЭСФ*, an `OrderEsf` row exists for the order with the operator's document ID, the user who created it, and a created-at timestamp.
- After *Проверить КИ* completes, each `OrderCises` row has its `STATUS`, `OWNER_INN`, `PACKAGE_TYPE`, and `CHILD` columns updated to match the state tracker's response.
- After *Удалить ЭСФ*, the `OrderEsf` row is removed and the chip returns to *Ожидает отправку ЭСФ*.
- No stock has moved and no money rows have been written — this screen is paperwork only.

## Where this leads next

- The validation logic itself (asynchronous job, four resting states): [CIS code check](../orders/cis-code-check.md)
- The companion buy-side screen: [Incoming invoices (Приёмка)](./incoming-invoices.md)
- For the navigation map and RBAC paths: [Page-to-module map](../page-to-module-map.md)

## For developers

Developer reference: page rendered by `protected/modules/markirovka/controllers/ViewController.php::actionOutgoingInvoices`; data feeds in `protected/modules/markirovka/actions/GetOutgoingInvociesAction.php`, `CheckOrderCises.php`, `GetOrderCisesStatusAction.php`, `CancelOrderCisesCheck.php`, `DeleteOrderCises.php`; views under `protected/modules/markirovka/views/outgoing-invoices/`; models `protected/models/OrderCises.php`, `protected/models/OrderEsf.php`, `protected/models/CisesInfo.php`; background job `protected/components/jobs/CheckOrderCisesJob.php`.
