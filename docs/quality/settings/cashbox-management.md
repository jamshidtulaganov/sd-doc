---
sidebar_position: 2
title: Cashbox management
audience: QA
---

# Cashbox management — the till catalogue

## What this feature is for

A *cashbox* is one named payment channel — a physical cash drawer, a card terminal, a bank account. The list of cashboxes is the source of truth for *"where did this money land?"* on every payment screen and finance report.

The list also encodes **who is allowed to operate which till**. Each cashbox carries a single cashier-user link. A cashier (role 6) only sees the cashboxes that point at them — unless an override permission lifts that scoping.

## Who uses it and where they find it

| Role | Action | Path |
|---|---|---|
| Admin (1) | Full create / edit / deactivate | Web → Settings → Cashbox catalogue |
| Operator (3) | Same | Same |
| Operations (5) | Read in most installations | Same |
| Cashier (6) | No access to the catalogue — they only see *their* cashboxes in the payment screen | — |
| Anyone with the cashbox-access override | Read every cashbox even if they are a cashier | — |

## The workflow

```mermaid
flowchart LR
    A[Admin opens cashbox list] --> B[Add or edit row]
    B --> C{Currency picked?}
    C -->|empty| C1[Row saves, all-currency cashbox<br/>fed by every payment]
    C -->|fixed| C2[Row saves, currency-scoped<br/>only same-currency payments]
    B --> D{Cashier picked?}
    D -->|empty| D1[Open till — every role with cashbox<br/>access can post against it]
    D -->|user X| D2[Locked till — role-6 X sees it,<br/>other cashiers do not]
    Note over B,D2: QA-relevant: the cashier field<br/>controls cashbox scoping everywhere<br/>downstream — finans, mobile expeditor, reports.
    C1 & C2 & D1 & D2 --> E[Save]
    E --> F[Catalogue dropdowns in Finans,<br/>Orders, mobile app refresh]
```

## Step by step

1. The admin opens **Settings → Cashbox catalogue**. *The system shows every cashbox row owned by this dealer, separated into active and inactive groups.*
2. The admin presses **New** and fills `NAME`, optional `CURRENCY`, optional `KASSIR` (one cashier user), optional `SORT` order and `XML_ID` (external code).
3. *The system requires `NAME` and rejects `NAME` longer than 200 characters.*
4. *The system stamps create-by / create-at on save, and write-by / write-at on every later edit.* (See [For developers](#for-developers).)
5. The admin can later *deactivate* a cashbox by clearing the active flag.
6. *The system hides inactive cashboxes from new-payment dropdowns but keeps them visible in reports filtered on historical rows.*
7. When the admin edits the `KASSIR` field on an existing cashier user (via the user form), *the system clears the old cashbox-to-cashier links and re-creates them from the multi-select on that form*. Editing the cashbox row's `KASSIR` field is the same operation from the other direction.

## What can go wrong (errors the user sees)

| Trigger | What the user sees | Plain-language meaning |
|---|---|---|
| Empty name | Field-level red "required" message | The catalogue does not save unnamed rows. |
| Name longer than 200 chars | Field-level red truncation warning | Hard length cap. |
| Duplicate name across active rows | No native uniqueness; both rows save | **QA flag.** Document the dealer's convention; the system itself does not block duplicates. |
| Two cashboxes both point at cashier X | Both rows save | One cashier can have many tills; this is by design. |
| Cashier (role 6) logs in but sees an empty payment-cashbox dropdown | No cashbox row has their user-id in the cashier slot | Scoping is working but the admin forgot to bind a till. |
| Cashier hard-deletes their user (admin action) | The system clears the cashier field on every cashbox that pointed at them | Cashboxes are not deleted — just become "open" until a new cashier is assigned. |
| Deactivate a cashbox that has historical payment rows | Row hides from dropdowns; old payments still report correctly | Deactivation is non-destructive. |

## Rules and limits

- **Name is required.** Maximum 200 characters.
- **Currency is optional.** When set, the cashbox should only receive same-currency payments; the catalogue itself does not enforce this — the payment form does.
- **Cashier is optional.** When set, only that cashier (role 6) sees the cashbox in their dropdowns, unless an override permission is granted.
- **One cashbox → at most one cashier.** Setting a new cashier replaces the old one. There is no "co-cashier".
- **One cashier → any number of cashboxes.** The list is many-to-one from cashbox to cashier.
- **Deactivation is not deletion.** Historical references survive; reports and old payments stay readable. No row is hard-deleted from this screen.
- **`ACTIVE`, `SYNC` and similar flags are one-character columns** with `Y` / `N` semantics — when in doubt, expect `Y` = visible / on, `N` = hidden / off.

## What to test

**Happy paths**
- Create a cashbox with name only; verify it appears on the payment form and in the cashbox-balance screen.
- Edit the name; verify the new name appears in every dropdown after refresh.
- Set a currency on a cashbox; verify that a payment in a different currency is either rejected or quietly skips the currency-scoped balance.

**Validation**
- Save with an empty name → red "required" error.
- Save with a 201-character name → length validation error.
- Save two cashboxes with the same name → both save (document the gap, no block expected).

**Role gating**
- Admin / operator can open the catalogue.
- Cashier (role 6) cannot open the catalogue.
- After binding cashier X to cashbox C: log in as X, verify C appears in their payment screen; verify other cashboxes do not.
- Grant the cashbox-access override to user X and re-test — every cashbox now appears regardless of scoping.
- URL-hack to a cashbox the cashier does not own (open `/finans/...?cashbox_id=other`) and verify the request is empty / rejected.

**Cross-module impact** (most important for this catalogue)
- Bind cashier X to cashbox C; log in as X; post a payment; reload **Finance → Cashbox balance** and verify C's total changed by the payment amount.
- Deactivate cashbox C while X is using the mobile app; X's payment form should refresh and C should disappear from the picker.
- Edit cashbox C's currency from blank to "USD"; create a UZS payment; verify either the form blocks the currency mismatch or the USD-cashbox-balance does not change.
- Re-bind cashier from X to Y on cashbox C: X stops seeing C, Y starts seeing C, no historical payment row is rewritten.

**Side effects**
- Soft-delete a user who is the cashier on cashbox C; verify the cashbox catalogue blanks the cashier field on C automatically (this is done when the user form switches off role 6).
- Deactivate a cashbox referenced by an open shipper-payment document; verify the open document can still be saved (it should not break on a now-inactive cashbox).

## Where this leads next

- For the per-cashbox running total and how cashier scoping shows up there, see [Cashbox balance](../finans/cashbox-balance.md) in the Finans QA guide.
- For the per-client running balance, see [Client debt view](../finans/client-debt-view.md).
- For payment screens that consume the cashbox list, see [Settlement](../finans/settlement.md) and [Transaction types](../finans/transaction-types.md).
- For the user form that performs the reverse binding (cashier → cashboxes), see [RBAC and users](./rbac-and-users.md).

## For developers

Developer reference: `protected/models/Cashbox.php`, `protected/modules/settings/views/user/_form.php` and `_form_update.php` (the cashier→cashboxes multi-select), `protected/modules/settings/controllers/UserController.php` (the rebinding on user save).
