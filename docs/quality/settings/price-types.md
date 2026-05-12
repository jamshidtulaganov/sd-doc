---
sidebar_position: 3
title: Price types
audience: QA
---

# Price types — the price-book catalogue

## What this feature is for

Every product can have **several prices** at the same time: a purchase price (what the dealer paid), one or more sell prices (retail, wholesale, HoReCa, …), and sometimes a "manual" price the salesperson types in on the order line. Each named price book is a **price type**, and the price type catalogue is the master list of those books.

The price type chosen on an order decides which numbers come out of the price-book onto the line. The fields on each row — kind, currency, manual-edit allowed, active flag — feed every order, every mobile app price screen, and every report grouped by price book.

## Who uses it and where they find it

| Role | Action | Path |
|---|---|---|
| Admin (1) | Full create / edit / deactivate | Web → Settings → Price types |
| Operator (3) | Full create / edit / deactivate | Same |
| Operations (5) | Same in most installations | Same |
| Agent (4) | Reads the catalogue indirectly (on the order picker / mobile app) | — |
| Cashier (6), expeditor (10), merchandiser (11) | Read on the order they handle, no edit | — |

## The workflow

```mermaid
flowchart LR
    A[Admin opens price type list] --> B[Add or edit row]
    B --> C{Kind}
    C -->|Purchase| C1[Row joins purchase-side<br/>price book, fed by goods-receipt]
    C -->|Sell| C2[Row joins sell-side price book,<br/>picked by orders]
    B --> D{Hand-edit allowed?}
    D -->|Yes| D1[On the order line the salesperson<br/>can type any number — manual price]
    D -->|No| D2[The order line is read-only,<br/>numbers come from the price book]
    B --> E{Currency}
    E --> E1[Orders priced in that currency<br/>only — multi-currency dealers<br/>maintain one price type per currency]
    B --> F{Active}
    F -->|N| F1[Hidden from new-order pickers,<br/>old orders still readable]
    F -->|Y| F2[Visible on every price picker]
    Note over D,D2: QA-relevant: hand-edit on a sell price-type<br/>is the gate for the "manual price" workflow<br/>tested in the orders module.
```

## Step by step

1. The admin opens **Settings → Price types**. *The system shows every price type, separated into active and inactive groups, ordered by sort then id.*
2. The admin presses **New** and fills `NAME`, kind (Purchase or Sell), optional `DESCRIPTION`, optional `CURRENCY`, the hand-edit flag, an optional external `XML_ID`, and a sort order.
3. *The system sets the active flag to `Y` on create*, gives the row a parent reference based on the kind (purchase rows get parent `-1`, sell rows get parent `0`), and persists the row.
4. *If the hand-edit flag is on at create time, the system also saves a snapshot row in the "old price type" history table*, used to roll back rate changes.
5. On edit, *the system maps the on/off toggle from the form back to `Y`/`N` and re-applies the kind-based parent reference*.
6. *Editing is gated by a filial check.* A user who is not in the active filial is shown a generic error rather than the form submit.
7. To deactivate a price type, the admin un-ticks the active flag and saves.

## What can go wrong (errors the user sees)

| Trigger | What the user sees | Plain-language meaning |
|---|---|---|
| Empty name | Field-level red "required" message | The row will not save. |
| Save while logged into a non-active filial | Generic "save failed" error | Filial check prevents cross-filial edits. |
| Pick a deactivated price type on a mobile order | The price type disappears from the picker | Inactive rows are filtered out at the picker level. |
| Open an old order that references a now-deactivated price type | The order opens, the field shows the historical name | Deactivation does not break history. |
| Hand-edit allowed but the form on the order line is still read-only | The order line was created before the flag was switched on | Existing orders use the price-type snapshot taken at order time. |
| Two price types with the same name | Both save | No native uniqueness check on name. |

## Rules and limits

- **Name is required.** Maximum length is enforced by the database, not by the form.
- **Kind is required.** Purchase types feed the purchase-side price book; sell types feed orders.
- **Active flag is one character.** `Y` = visible everywhere, `N` = hidden from new screens but kept in history.
- **Hand-edit allowed** is the single most important flag for QA. When on, salespeople can override the price on an order line. When off, the price-book number is binding.
- **Currency is optional.** Multi-currency dealers maintain one price type per currency rather than one mixed-currency price type.
- **Sort order** is honoured on every dropdown — pickers show rows in `SORT` ascending, then `ID` ascending.
- **No cascade delete.** Deactivating does not affect historical orders, returns, or reports. Hard-deletion is not exposed from this screen.
- **Editing is filial-aware.** In multi-filial installations, only users inside the row's filial can edit it.

## What to test

**Happy paths**
- Create a sell price type with a currency; verify it appears on a new order's price-type picker.
- Create a purchase price type; verify it appears on a goods-receipt document.
- Edit the name; verify the rename propagates to new orders without renaming the historical label on closed orders.

**Validation**
- Save with empty name → field-level required error.
- Toggle active on then off; verify the row hops between the active and inactive tabs on the index screen.
- Switch the kind from sell to purchase on an existing row and verify the system re-assigns the parent reference.

**Role gating**
- Admin / operator can open the catalogue; agent / cashier / expeditor cannot.
- A filial user editing a row owned by another filial gets a "save failed" message.

**Cross-module impact** (most important for this catalogue)
- Toggle hand-edit on for a sell price type, then create a mobile order — the order line should let the salesperson type a custom price.
- Toggle hand-edit off for the same price type, refresh the mobile app, and verify the line becomes read-only again.
- Deactivate a price type currently shown on the mobile order picker; verify the picker no longer offers it.
- Open an order that already used a now-deactivated price type — the order should still open and the historical price should not change.
- Mobile expeditors and van-sellers also rely on `appAllowPriceTypes` (a server toggle); cross-check with [Server toggles](./server-toggles-and-period-close.md).
- Bonus and discount rules can be restricted to specific sell-side price types; test that a rule with a price-type filter only fires when an order uses that exact type. See [Bonus rules](./bonus-rules.md) and [Discount rules](./discount-rules.md).

**Side effects**
- Change the currency on a price type that is already on open orders — the open orders keep their old currency. Only new orders pick up the new value.
- Verify the price-type list on import jobs (1C, SmartUp) still maps cleanly after a rename — those integrations use `XML_ID`, not `NAME`.

## Where this leads next

- For how the price type drives an order's totals, see [Create order (web)](../orders/create-order-web.md) and [Create order (mobile)](../orders/create-order-mobile.md).
- For how bonus / discount rules filter on price types, see [Bonus rules](./bonus-rules.md) and [Discount rules](./discount-rules.md).
- For the `allowManualPriceForAgent` global toggle that interacts with hand-edit, see [Server toggles and period close](./server-toggles-and-period-close.md).

## For developers

Developer reference: `protected/modules/settings/controllers/PriceTypeController.php`, `protected/models/PriceType.php`, `protected/models/OldPriceType.php`.
