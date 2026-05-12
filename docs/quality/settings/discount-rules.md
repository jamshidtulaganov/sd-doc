---
sidebar_position: 7
title: Discount rules
audience: QA
---

# Discount rules — header auto-discounts and per-line manual caps

## What this feature is for

The dealer offers price reductions through two parallel rule books:

- **Auto discount.** A rule book matched against every new order. Each rule has a date window, a tier table, filters by client / agent / city / price type / category, and on save fires automatically. This is the "Скидки" tab in the rule-book screen.
- **Manual discount cap.** A second rule book defining *how much* an individual salesperson is allowed to type into the per-line discount field of an order. Each row caps one agent (or set of agents) at one percentage on a chosen product list and price type. This is the "Ручные скидки" tab.

The two books work together. The auto book paints discounts onto the order header on save; the manual book defines the upper bound on what the salesperson can hand-key per line.

## Who uses it and where they find it

| Role | Action | Path |
|---|---|---|
| Admin (1), Operator (3) | Full create / edit / deactivate / extend period for both books | Web → Settings → Bonus and discount → Discounts / Manual discounts |
| Operations (5) | Same | Same |
| Agent (4) | Reads — sees the resulting discount on the order line, and is capped by manual rules | — |
| Supervisor (8), Manager (2) | Read for orders they oversee | — |

## The workflow

```mermaid
flowchart LR
    A[Admin opens Discount tab] --> B[New rule]
    B --> C[Pick name, date window,<br/>discount type, tier table,<br/>products, client / agent /<br/>city / price-type filters,<br/>currency, only-one-time]
    C --> D[Save — parent + tier children<br/>in one transaction]
    Note over C,D: For per-SKU discount type the form<br/>uses a separate set of fields, but<br/>the engine still writes parent + children.
    D --> E{Used by any order?}
    E -->|Yes & not configured to allow updates| E1[Edit blocked,<br/>only Extend period available]
    E -->|No or override on| E2[Free editing]
    F[Admin opens Manual discount tab] --> G[New row]
    G --> H[Pick name, discount value,<br/>agents, products, price types]
    H --> I[Save — row + per-agent rows<br/>in side table]
    Note over G,I: QA-relevant: manual discount has no<br/>date window; it is on or off via ACTIVE.
    J[Order saved or edited] --> K[Auto engine: walk active rules,<br/>match filters and date, fire]
    J --> L[Manual line: agent's typed<br/>discount is clamped by their<br/>most-specific manual rule]
```

## Step by step — auto discount (Skidka)

1. The admin opens **Settings → Bonus and discount** and switches to the **Discounts** tab. *The system lists every parent rule with its tier summary and the budget consumed by orders in statuses 1–3.*
2. The admin presses **Create discount** and fills the form: name, date window, discount type, tier table (`Value` threshold, `Skidka` reward, optional `MaxValue` cap), product list, client categories, client types, client channels, agents, cities, currencies, price types, public-mode.
3. For "per-SKU" discount type the form swaps a different field set in: `ValueSku`, `SkidkaSku`, `MaxValueInSKu`. The saved rule is the same shape.
4. Optional flags: `ONLY_ONE_TIME` (rule fires once per client lifetime), the "fire only every N-th order" mode (`N_TYPE`, `N_STATUS`, `N_VALUE`, `N_MIN_SUMMA`).
5. *On save, the system writes the parent row, copies its id into its own `PARENT` field, and writes every tier child with the same `PARENT`.*
6. *The agent filter is rewritten on every save* — the row's previous side-table entries are wiped and re-inserted from the picker.
7. To **edit**: the admin opens it. *Before showing the form, the system probes orders that reference any child rule.* If any non-cancelled order is found and the global `skidkaAllowUpdate` flag is *not* on, the form is read-only with "Невозможно изменить. Эта скидка использовалась в заказах". Period-extension is still available.
8. **Extend period** updates only `DATE_TO`. *The system refuses a date in the past* ("Макс. разрешенная дата: now").
9. To **deactivate**, the admin toggles the active flag from the list. *The system flips every child row in the parent group to `N`.*

## Step by step — manual discount cap (SkidkaManual)

1. The admin opens the **Manual discounts** tab.
2. The admin presses **Add** and fills name, discount percentage (`SKIDKA`), agent multi-select, product multi-select, price-type multi-select.
3. *On save, the system stores the row and writes one side-table entry per selected agent.* The agent side table is rewritten on every edit.
4. To toggle on / off, the admin uses the active-toggle endpoint. *The active flag flips between `Y` and `N` on save.* There is no date window — the row is either on or off.

## What can go wrong (errors the user sees)

| Trigger | What the user sees | Plain-language meaning |
|---|---|---|
| Edit an auto rule used by a non-cancelled order while `skidkaAllowUpdate` is off | "Невозможно изменить. Эта скидка использовалась в заказах" | The auto rule is locked. Use period-extend or cancel-the-orders. |
| Period-extend an auto rule with a date before now | "Макс. разрешенная дата: YYYY-MM-DD HH:MM:SS" | Backward extension is blocked. |
| Save an auto rule with zero or negative `Value` on a tier | The tier is silently dropped | A whole rule with every tier invalid never gets a `PARENT` and rolls back. |
| Save an auto rule with zero / negative `Value` on an *existing* tier during edit | The tier is hard-deactivated (`ACTIVE = N`) | The rest of the tiers keep going. |
| Manual discount row left with no agents | Saves; the cap then applies to every agent | Empty agent filter means "every agent". |
| Salesperson types a per-line discount above their cap on mobile | Mobile order screen rejects the line | The cap is enforced on the line, not on the rule book itself. |
| Two auto rules match the same order | Both can fire | Like bonuses, `SkidkaRelation` and `SkidkaExclude` shape coexistence; basic rule form does not. |

## Rules and limits

### Auto discount (Skidka)

- **Active flag is on every child row.** Toggling the parent flips them all together.
- **Date window** (`DATE_FROM`–`DATE_TO`) is honoured; matching only fires inside the window.
- **Public mode (`IS_PUBLIC`)** = `Y` for all clients, `N` for selected clients only.
- **`ONLY_ONE_TIME`** = once per client lifetime.
- **"Fire every N-th order"** is the alternative repeat mode — fire on the N-th, 2N-th, 3N-th order in the chosen statuses, optional minimum sum. Set via `N_TYPE`, `N_STATUS`, `N_VALUE`, `N_MIN_SUMMA`.
- **`skidkaAllowUpdate`** is a global toggle that lifts the "used by order" lock on edits — risky and usually off.
- **Tier table** drops invalid rows on save without aborting the others.
- **Side table** `SkidkaAgent` (and `SkidkaStore`, `SkidkaCity` via the city field on the parent) carries the multi-value filters. Always rewritten on save.

### Manual discount (SkidkaManual)

- **No date window.** On / off only via the active flag.
- **Agent filter is the cap's scope.** Empty agent list = applies to every agent.
- **Product and price-type filters narrow the cap.** Empty = applies anywhere.
- **One row per cap.** Multiple rows can coexist; the order engine takes the most-specific one when a salesperson types a discount.
- **Active toggle is one click** from the list — the active-flag endpoint flips `Y` ↔ `N` without a form submit.

## What to test

**Happy paths — auto**
- Create an auto rule, "5% off when line value ≥ 100,000", date window covering today, no other filters. Submit a 120,000 order line and verify 6,000 is deducted on save.
- Create a tiered auto rule (100k → 3%, 250k → 5%, 500k → 8%) and submit each tier; verify the matched tier is applied.
- Toggle `ONLY_ONE_TIME` on. Submit two orders for the same client — the second should not get the discount.
- Submit an order in a price type that is not in the rule's filter — the discount must not fire.

**Happy paths — manual**
- Create a 10% cap row scoped to agent A on product P. Log in as A and submit an order line for P; type 5% and verify it saves; type 12% and verify it is rejected or clamped.
- Create the same cap with empty agent list; verify every agent is now capped at 10%.

**Validation**
- Edit an auto rule used by a non-cancelled order while `skidkaAllowUpdate` is off → expect the read-only banner.
- Period-extend the same rule to a past date → expect the "max allowed date" error.
- Save a tier with negative `Value` → tier silently dropped (auto rule); the rest of the tiers save.

**Role gating**
- Admin / operator can open both tabs; agent cannot.
- Mobile agents are subject to the manual cap on the order line.

**Cross-module impact** (most important for discount rules)
- Auto rule restricted to price type Z: order in Z fires, order in another price type does not. See [Price types](./price-types.md).
- Auto rule restricted to trade direction A: order in A fires, order in B does not. See [Trade and channel](./trade-and-channel.md).
- Auto rule restricted to client category C: only clients in C see the discount.
- Manual cap on agent A on product P: A types 5% on P (OK), A types 5% on a different product (no cap row, default applies), A's colleague B types 12% on P (no row for B, default applies).
- Deactivate the manual cap; the salesperson can type any percentage again (subject to other defaults).
- Auto rule's date window starts tomorrow: submit today — no discount; submit tomorrow — discount.
- Mobile order creation (van-seller, seller, agent) reads the same rule book; cross-check that an auto rule fires identically on mobile and on web. See [Create order (mobile)](../orders/create-order-mobile.md).

**Side effects**
- The bonus-and-discount engine handles bonus and discount in one matching pass; document the order on a per-line basis and verify both line totals match expectations.
- Renaming a product, category, or city does not retroactively rewrite the rule's filter; the rule keeps matching the old foreign key.
- Reports group by `SKIDKA_PARENT`; verify a renamed rule still shows the correct grouped total.

## Where this leads next

- For how a discount appears on the order itself, see [Discounts](../orders/discounts.md) in the Orders QA guide.
- For the bonus rule book (similar shape, free product instead of price reduction), see [Bonus rules](./bonus-rules.md).
- For the catalogues these rules filter on, see [Trade and channel](./trade-and-channel.md) and [Price types](./price-types.md).
- For the global `skidkaAllowUpdate` flag, see [Server toggles and period close](./server-toggles-and-period-close.md).

## For developers

Developer reference: `protected/modules/settings/controllers/SkidkaController.php`, `protected/modules/settings/controllers/SkidkaManualController.php`, `protected/modules/settings/controllers/BonusController.php` (the bonus screen also lists manual discount rows), `protected/models/Skidka.php`, `protected/models/SkidkaManual.php`, `protected/models/SkidkaAgent.php`, `protected/models/SkidkaManualAgent.php`, `protected/models/SkidkaStore.php`, `protected/models/SkidkaRelation.php`, `protected/models/SkidkaExclude.php`.
