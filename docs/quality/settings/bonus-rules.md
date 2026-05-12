---
sidebar_position: 6
title: Bonus rules
audience: QA
---

# Bonus rules — the auto- and manual-bonus rule book

## What this feature is for

A **bonus** is something extra the dealer gives to the client on top of the products they ordered — most often free product (buy three get one), sometimes a percentage off the next line, sometimes a points-style accrual. The rule book lives here in Settings; the order engine reads it whenever a new order is being priced.

There are two flavours:

- **Auto bonus.** The order engine matches every line against every active auto rule and fires the rule when the conditions hold.
- **Manual bonus.** The rule exists in the rule book but does not fire by itself — the salesperson picks it on the order line. This is signalled by the `MANUAL=1` flag.

Most of the QA effort goes into **matching**. A rule's match conditions are `client / agent / city / trade direction / price type / threshold`. Each is optional; missing means "any". A rule fires when *every populated condition* matches the order, the date is inside `DATE_FROM`–`DATE_TO`, and the active flag is `Y`.

## Who uses it and where they find it

| Role | Action | Path |
|---|---|---|
| Admin (1), Operator (3) | Full create / edit / deactivate / extend period | Web → Settings → Bonus and discount → Bonuses |
| Operations (5) | Same | Same |
| Agent (4) | Reads — sees the resulting bonus on the order line, can pick manual bonuses on mobile | — |
| Supervisor (8), Manager (2), Key-account (9) | Read for orders they oversee | — |

## The workflow

```mermaid
flowchart LR
    A[Admin opens Bonuses tab] --> B[New rule]
    B --> C[Pick name, date window,<br/>products, bonus products,<br/>tier table, client filters,<br/>agent / city / trade /<br/>price-type filters, MANUAL Y/N]
    C --> D[Save — parent and child rows<br/>are created in the same transaction]
    Note over C,D: A bonus rule is a parent row plus one or<br/>more child rows. Each child row is one<br/>threshold tier (Min, Max, Value, Bonus).
    D --> E{Used by any non-cancelled order?}
    E -->|No| E1[Free editing]
    E -->|Yes| E2[Edit blocked with banner<br/>except for period-extension]
    F[Order saved or edited] --> G[Engine reads active rules]
    G --> H{Match conditions all hold?<br/>Date inside window? ACTIVE=Y?}
    H -->|Yes| H1[Bonus written onto the order line<br/>and into the bonus-detail table]
    H -->|No| H2[Skip rule, try next]
    Note over G,H: QA-relevant: the most common bug<br/>is a rule that "should fire" missing<br/>one condition or being outside the date.
```

## Step by step

1. The admin opens **Settings → Bonus and discount** and switches to the **Bonuses** tab. *The system lists every parent rule with its tier summary, the public flag, and date range.*
2. The admin presses **Create bonus** and fills the form: name, date window (`DATE_FROM`–`DATE_TO`), products, optional "bonus products" list (for buy-X-get-Y rules), client categories, client types, client channels, currencies, price types, agents, cities, and the manual flag.
3. The admin adds one or more tiers — each tier is `Min` count, `Max` count, `Value` (the trigger threshold), `Bonus` (the reward), optional `MaxBonus`.
4. The admin picks a public mode: **all clients** (`IS_PUBLIC = Y`) or **selected clients** (`IS_PUBLIC = N`).
5. Optional flags: `ONLY_ONE_TIME` (the bonus fires only once per client lifetime), `IN_BLOCK`, `BOGO` (buy-one-get-one wording).
6. *On save, the system opens a database transaction, writes the parent row, copies its id into its own `PARENT` field, then writes every tier child row with the same `PARENT` reference.* If any child fails to save, the whole transaction rolls back.
7. *The system also writes one row per selected agent into the bonus-agent table, and one row per selected city into the bonus-city table* — many-to-many filters live in those side tables.
8. To **edit** an existing rule: the admin opens it. *Before showing the form, the system checks whether any non-cancelled order references any row in the parent group.* If yes, the form is read-only with a "this bonus is used in orders or a linked bonus" banner — the only thing the admin can still do is **Extend period**.
9. **Extend period** updates only `DATE_TO`. *The system refuses to set `DATE_TO` earlier than the latest order date that already used the bonus*, with a "max allowed date" message.
10. To **deactivate** a rule, the admin saves it with the active flag off. The rule disappears from the picker; historical orders are not changed.

## What can go wrong (errors the user sees)

| Trigger | What the user sees | Plain-language meaning |
|---|---|---|
| Edit a rule used by any non-cancelled order | "Невозможно изменить. Этот бонус используется в заказах или связанном бонусе." | The rule is locked except for period extension. |
| Extend period to a date earlier than the latest order using the rule | "Макс. разрешенная дата для (X): YYYY-MM-DD HH:mm" | The extension would invalidate an existing order. |
| Set tier with negative threshold or negative bonus | Tier silently skipped on save | The save loop drops invalid tiers without aborting the others. |
| Save the rule with an empty tier list (every tier dropped) | Parent row never gets a `PARENT` reference, transaction rolls back | The rule does not appear after save. |
| Activate a rule with a date window already in the past | Saves; the rule is inactive in matching anyway | Status banner should warn; engine check uses the date window. |
| Two rules match the same order line | Both fire by default | Bonus dependencies and exclusions (relation / exclude tables) shape this; out of scope of the basic rule form. |
| Manual rule but no salesperson picks it on the order | Bonus never fires | `MANUAL=1` rules do not match automatically — by design. |
| Public-selected rule on a client not in the chosen list | Rule skipped on that client's orders | Working as designed. |

## Rules and limits

- **Active flag (`ACTIVE = Y` / `N`)** is the master switch. `N` removes the rule from matching immediately on next order save.
- **Manual flag (`MANUAL = 1`)** means the rule is in the picker but not in auto-matching. `MANUAL = 0` means auto-matching.
- **Public mode (`IS_PUBLIC`).** `Y` = available to all clients; `N` = available only to clients explicitly attached to the rule.
- **`ONLY_ONE_TIME`.** When set, the rule fires at most once per client. Useful for first-order bonuses.
- **Date window.** `DATE_FROM` and `DATE_TO` are both honoured; matching only happens *between* them.
- **Tier table.** Each child row represents one tier — `Min` count, `Max` count, `Value`, `Bonus`, optional `MaxBonus`. Tiers with invalid values are silently dropped on save.
- **Filter fields.** Empty means *any*. Multi-value fields (agents, cities, client categories, client types, client channels, currencies, price types) are stored as a comma-joined list or in many-to-many side tables.
- **Price-type filter is limited to sell price types.** The picker on the form is pre-filtered to price types whose kind is sell (the "kind = 2" set on the [Price types](./price-types.md) page).
- **Editing is gated** by the "used in any non-cancelled order" probe. To unlock, either cancel those orders or use the period-extension shortcut.
- **Period extension refuses going backward** when an order already used the rule with a later date.
- **Side tables.** `BonusAgent` and `BonusCity` carry the agent and city filters. The bonus form rewrites them on every save.
- **Relations and excludes.** `BonusRelation` and `BonusExclude` define dependencies between rules (e.g. *if rule A fires, also try rule B; never fire rule C alongside D*). These are managed on the same screen but are out of scope for the basic matching test.

## What to test

**Happy paths**
- Create a buy-3-get-1 rule on product P with no agent / city / channel filter and date window covering today. Submit an order with 3×P and verify the line shows the bonus and the order total reflects the freebie.
- Create a tiered rule — 3→1, 6→2, 9→3. Submit orders at 2, 3, 5, 6, 8, 9 and verify the tier picked matches the threshold.
- Create a manual bonus. On a new order, do *not* see it fire automatically; pick it from the salesperson's manual bonus picker and verify it lands on the line.

**Validation**
- Save with empty tier table → rule does not appear (silently dropped child rows).
- Set a tier with a negative value → that tier is dropped on save, others save.
- Try to edit a rule used by a non-cancelled order → the read-only banner appears.
- Try to shorten `DATE_TO` to a date before the latest order's date → the system blocks with "max allowed date".

**Role gating**
- Admin / operator can open the rule book; agent cannot.
- Mobile agent can pick a manual bonus when one applies to their client.

**Cross-module impact** (most important for bonus rules)
- Restrict a rule to trade direction A. Submit an order in trade direction B — rule must not fire. Switch the order to A — rule fires on the next refresh.
- Restrict a rule to city X. Test a client in city X (fires) and a client in city Y (does not).
- Restrict a rule to a sell price-type Z. Submit an order in price type Z (fires) and price type W (does not). See [Price types](./price-types.md).
- Restrict a rule to public-selected with client list `{c1, c2}`. Test on c1 (fires), c2 (fires), c3 (does not).
- Deactivate the rule. Re-submit any matching order. Verify the rule does not fire.
- Toggle `ONLY_ONE_TIME`. First order with client c1 fires; second order with c1 does not; first order with c2 fires.
- Deactivate the trade direction the rule references — the rule should silently stop matching even though it is still active. Re-activate; rule resumes. See [Trade and channel](./trade-and-channel.md).
- Set `DATE_FROM` to tomorrow. Submit an order today; rule must not fire. Move the system clock or `DATE_FROM` to yesterday; rule fires.

**Side effects**
- Extend period on a rule that is already used. Verify the extension applies to every child tier row (the date is written on every row in the parent group).
- Look at the auto-bonus matching path used by mobile (`api3`, `api4`) for van-sellers and sellers — those endpoints also read this rule book; cross-check that a rule fires identically on mobile and on web.
- The reports module reads bonus rows for KPI / budget; verify the bonus budget figure on the rule list reflects orders in statuses 1–3.

## Where this leads next

- For how a bonus appears on the order itself, see [Bonuses](../orders/bonuses.md) in the Orders QA guide.
- For the catalogues that bonus rules filter on, see [Trade and channel](./trade-and-channel.md), [Price types](./price-types.md), and the city / client-category catalogues.
- For the discount rule book (similar shape, different effect), see [Discount rules](./discount-rules.md).

## For developers

Developer reference: `protected/modules/settings/controllers/BonusController.php`, `protected/models/Bonus.php`, `protected/models/BonusAgent.php`, `protected/models/BonusCity.php`, `protected/models/BonusRelation.php`, `protected/models/BonusExclude.php`, `protected/models/BonusLimit.php`, `protected/models/BonusOrderDetail.php`.
