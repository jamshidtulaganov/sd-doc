---
sidebar_position: 4
title: Trade direction and channel
audience: QA
---

# Trade direction and channel — the two catalogues rules match against

## What this feature is for

The dealer's customers are not all alike. A retail kiosk, a wholesaler, a pharmacy, and a HoReCa restaurant all carry orders through the same system but pay different prices, get different bonuses, and may even be served by different agents. The dealer reflects this with two small catalogues:

- **Trade direction** — the *business segment* of the order (HoReCa, Modern Trade, Wholesale, …). Stamped on every order, on every product (the product's "home" segment), and on every finance row that carries a store reference.
- **Client channel** — the *retail channel* of the client (online shop, key account, traditional trade, …). Stamped on the client card.

Bonus rules and discount rules match on these fields. A rule that says *"+5% bonus on Modern Trade for HoReCa products in Tashkent"* needs the trade direction and channel catalogues to contain matching rows.

## Who uses it and where they find it

| Role | Action | Path |
|---|---|---|
| Admin (1) | Full create / edit / deactivate / delete-if-unused | Web → Settings → Trade direction; Web → Settings → Client channel |
| Operator (3) | Same | Same |
| Operations (5) | Same in most installations | Same |
| Agent (4) | Indirectly — picks a channel when registering a new client on mobile | — |
| Manager (2), key-account (9) | Read on the order and client cards they own | — |

## The workflow

```mermaid
flowchart LR
    A[Admin opens Trade direction] --> B[Add or edit row]
    B --> C{Has rows already used?}
    C -->|No order, finans, product references row| D[Row is fully editable;<br/>Delete button available]
    C -->|Row used somewhere| E[Row is editable but the system<br/>blocks Delete with an error<br/>and offers the deps screen]
    Note over C,E: QA-relevant: the system checks Order, ClientTransaction<br/>and Product before allowing delete. Test the message.
    A2[Admin opens Channel list] --> B2[Add or edit row]
    B2 --> F{ACTIVE Y/N}
    F -->|N| F1[Channel hidden from new-client form<br/>and from rule-matching pickers]
    F -->|Y| F2[Channel offered everywhere]
    B & B2 --> G[Save]
    G --> H[Bonus and discount rule pickers refresh.<br/>Rules referencing this row keep working.]
```

## Step by step

### Trade direction

1. The admin opens **Settings → Trade direction**. *The system shows every row alphabetically by name.*
2. The admin presses **New** and fills `NAME`, optional `DESCRIPTION`, active flag.
3. *On save, the system writes the row and re-shows the list.*
4. To delete: the admin opens the row's edit panel and presses **Delete**.
5. *The system runs a usage probe — it checks whether any order has this row as its trade direction, whether any finance row carries it as a store reference, and whether any product carries it as its home segment.*
6. *If any of those probes returns a row, delete is refused and the user is redirected to a "product references" view that lists where the row is in use.*
7. *If all probes are clean, the row is hard-deleted.*

### Client channel

1. The admin opens **Settings → Client channel**. *The system shows every channel with active flag and external code.*
2. On create / edit, the admin fills `NAME`, optional `XML_ID`, active flag.
3. *On save, the active flag is normalised — the form's truthy toggle stores as `Y`, falsy as `N`.*
4. There is no delete-after-use safety net on this screen; deactivation is the safe way to retire a channel.

## What can go wrong (errors the user sees)

| Trigger | What the user sees | Plain-language meaning |
|---|---|---|
| Delete a trade direction that an order, payment, or product references | The user is redirected to a dependency view rather than getting a delete success | The row is still alive; the user needs to clear dependencies (or just deactivate). |
| Deactivate a trade direction still referenced by open orders | Saves silently | Open orders keep working; only new pickers hide the row. |
| Save channel with empty name | Form-level "save failed" | Name is required by the model. |
| Two channels with the same name | Both save | No native name-uniqueness on this catalogue. |
| Mobile agent picks a now-deactivated channel via cached client data | Order saves; client card still references the old channel | Deactivation is non-destructive. |

## Rules and limits

- **Trade direction is "delete-protected"** when in use. The system probes orders, finance rows, and products before allowing a delete.
- **Channel does not have a delete probe.** Use the active flag instead.
- **The active flag is one character.** `Y` = visible everywhere, `N` = hidden from new pickers but kept in history.
- **Both catalogues carry an `XML_ID` (external code).** Integration imports key on this code, not on the human-readable name.
- **Renames are safe** on both catalogues. Historical orders display the new label automatically because the order stores only the foreign key.
- **The bonus and discount rule books match on the row id, not on the name.** Renaming a row does not break a rule that referenced it.

## What to test

**Happy paths — trade direction**
- Create a new trade direction with a unique name; verify it appears on the new-order screen and on the bonus-rule city/trade picker.
- Edit the name on a row that is in use; verify orders, the bonus-rule list, and reports all show the new name on refresh.
- Delete an unused row; verify it disappears.

**Happy paths — channel**
- Create a channel; verify it appears on the new-client form and on the bonus-rule channel picker.
- Edit the name on a channel that is bound to existing clients; verify those clients still show their channel reference, with the new label.

**Validation**
- Save an empty-name channel; expect a save-failed message.
- Delete a trade direction in use by an order — expect the redirect to the dependency view, not a success.

**Role gating**
- Admin / operator can open both catalogues; agent / cashier cannot.
- A non-admin attempting a direct URL to the catalogue gets the standard access-denied flow.

**Cross-module impact** (most important for these catalogues)
- Create a bonus rule restricted to trade direction X. Then deactivate X. Verify the rule no longer fires on a new order even though the rule itself is still active. Re-activate X and verify the rule resumes.
- Create a discount rule restricted to channel Y. Then deactivate Y and verify clients in Y still match by their historical channel, but new clients cannot be put into Y.
- Auto-bonus matching: an order in trade direction A should not pick up a rule that explicitly lists only trade direction B. See [Bonus rules](./bonus-rules.md).
- Auto-discount matching: same idea. See [Discount rules](./discount-rules.md).
- Reports that group by trade direction should still show the row label after a rename; old rows still appear under the new label.

**Side effects**
- Renaming a trade direction does not retroactively rewrite the order's data — only the displayed label changes via the foreign key.
- Deleting a trade direction that has *only* deleted-status (status 5) orders against it is still blocked by the probe, because the probe checks any-status references. Document the gap if the dealer expects "deleted orders shouldn't count".

## Where this leads next

- For how bonus rules consume these catalogues, see [Bonus rules](./bonus-rules.md).
- For how discount rules consume these catalogues, see [Discount rules](./discount-rules.md).
- For the order screens that stamp the trade direction onto each order, see [Create order (web)](../orders/create-order-web.md).
- For client cards that pick the channel, see [Create / edit client](../clients/create-edit-client.md) and [Categorisation](../clients/categorisation.md).

## For developers

Developer reference: `protected/modules/settings/controllers/TradeDirectionController.php`, `protected/modules/settings/controllers/ChannelController.php`, `protected/models/TradeDirection.php`, `protected/models/ClientChannel.php`.
