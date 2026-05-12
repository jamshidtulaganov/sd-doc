---
sidebar_position: 9
title: Discounts
audience: QA
---

# Discounts on orders

## What this feature is for

Discounts let the operator or agent give the client a price reduction — either on a single product line, or on the whole order. Discounts can be **manually picked** by the user from a list of approved discount rules, or **automatically applied** by the system based on rules the company has set up (client tier, trade direction, product category, threshold value, etc.).

The discount mechanic looks simple from the outside but actually has several independent paths that can fire at the same time, with different precedence. **Most discount-related QA bugs come from misunderstanding which discount path is firing**, so this page maps them out explicitly.

## The four discount paths

| Path | Where it's entered | How it's chosen | Stored where |
|---|---|---|---|
| **Per-line manual discount** | Operator (web) or agent (mobile) picks a discount rule for a specific line | The user picks from a list of approved manual discount rules | Stored on the line itself; flagged as manual |
| **Per-line manual amount** | Operator types a per-unit amount on a line (price-type permitting) | Free-text entry | Stored on the line |
| **Header auto-discount** | System decides from rules at save time | Rules match against client / agent / trade / threshold | Stored as a separate link record between the order and the rule |
| **Header bonus** (a form of discount-in-goods) | System or user picks bonus products | See [Bonuses](./bonuses.md) | Stored as a linked bonus order |

This page covers the first three. Bonuses are on their own page.

## Who uses it and where they find it

| Role | What they do here | How they get to the screen |
|---|---|---|
| Operator (3) / Operations (5) / Key-account (9) | Picks a per-line manual discount on the web order form | Web → New / Edit order → on each line, **Discount** dropdown |
| Field agent (4) | Picks a per-line manual discount on the mobile order form | Mobile app → Take order → on each line, discount picker |
| System | Applies auto-discounts at save time | Automatic — fires on every successful save |

## Which discount wins where?

This is the trickiest question for QA. The simple rule:

> **The per-line discount is what shows up on the line.** The header auto-discount is recorded separately. **Both can be active at the same time.**

Reports and invoices may sum these differently depending on the report:

- The order's **line discount total** (sum of per-line discounts) is what shows on the printed invoice.
- The **auto-discount** (header) shows in the audit log and in the discount-rules report but not always on the printed invoice.
- For business reporting, **the per-line value is the authoritative one** — that's what was charged.

A QA test plan should always include cases that exercise each path independently and the combined case.

## The workflow — at a glance

```mermaid
sequenceDiagram
    autonumber
    participant U as Operator or Agent
    participant Form as Order form
    participant Sales as Sales DB
    participant Skidka as Discount rules engine

    U->>Form: Build order
    opt user picks a per-line discount rule
        U->>Form: Pick discount on line X
        Form->>Skidka: Is this rule active? Is this agent allowed?
        alt rule invalid
            Form-->>U: Field error
        else
            Form->>Form: Apply the rule's percentage to that line's total
        end
    end
    opt user types a per-line amount (price-type permitting)
        U->>Form: Type per-unit discount amount on line Y
        Form->>Form: Multiply by line quantity → stored as line discount
    end
    U->>Form: Press Save
    Form->>Sales: Save order + lines (line discounts inline)
    Note over Sales,Skidka: ⚠ Auto-discount runs AFTER save.<br/>The order is already written; this adds<br/>a link record between the order and the rule.
    Sales->>Skidka: Find any auto-discount rule that matches the order
    alt match found
        Skidka->>Sales: Insert link record between order and rule
        Sales->>Sales: Update the auto-discount-related totals
    else no match
        Skidka-->>Sales: Nothing happens
    end
    Sales-->>U: Saved (with whatever combination of discount paths applied)
```

## Step by step

1. The user opens the order form (web or mobile).
2. **Per-line manual discount path.** For any line, the user can pick a manual discount rule from a dropdown. *The system checks the rule is active, applies to this price-type, and is allowed for this agent / client.* ⛔ Inactive or wrong-agent rules are rejected.
3. **Per-line manual amount path.** If the price type allows it (`HAND_EDIT` flag), the user can also type a per-unit discount directly. *The system multiplies by quantity to get the line's discount amount.*
4. The user presses **Save**.
5. *The order saves with each line's discount recorded.* Lines with a manual rule are flagged as such, with a reference to which rule.
6. *The auto-discount engine runs after save.* It searches for header-level discount rules that match the order's client, agent, trade, threshold value, etc. ⚠ Notably this happens **post-save** — the order is already on disk when the auto-discount link is written.
7. *If any rule matches, a link record is inserted* between the order and the rule.
8. *The order's totals are recomputed* to reflect any auto-discount effect.

## What can go wrong

| Trigger | Error / behaviour | Plain-language meaning |
|---|---|---|
| Picked manual discount rule is deactivated | Field error: "Discount rule not found" | The rule was deactivated between form load and save. |
| Picked manual discount rule does not allow this agent | Field error | The rule has an allowed-agent list and this agent is not on it. |
| Picked manual discount rule does not apply to this price type | Field error | Rule scoped to a different price type. |
| Manual per-unit amount entered, but price type does not allow manual price | Field error | The price field — including discount entry — is locked for that price type. |
| Discount amount negative | Field error | Cannot be negative. |
| Discount makes line total go negative | Save rejected | Can't owe the client money. |
| No auto-discount rule matches | Silent (nothing happens) | This is **not** an error — auto-discount simply doesn't fire if no rule matches. Test plans should explicitly check for "no auto-discount" cases. |

## Rules and limits

- **Manual discounts are sticky** — if the order is later edited, the manual discount on a line stays put. Recalculation honours the per-unit manual amount.
- **Auto-discount is computed at save time.** Editing the order can change whether the auto-discount rule still applies — verify what happens on edit.
- **Discounts cannot make a line negative.** A 110% discount on a 100,000 UZS line is rejected.
- **Discount rules can be agent-specific.** The dropdown is filtered by who's saving the order; tests should cover both an allowed agent and a forbidden one.
- **Discount rules can be product-category-specific.** A line whose product isn't in the rule's allowed-category list cannot use that rule.
- **Discount rules are time-bounded.** Rules have a start/end date — using one outside its window fails.
- **The line-versus-header reporting fork is real.** Always specify in a test case which discount value you're verifying.

## What to test

### Per-line manual discount

- Add a line with a valid manual discount rule. Verify the line total drops by the rule's percentage / amount.
- Same with a rule that is **just** within its active date window. Verify it works on day 1 and day N, fails on day N+1.
- Try a rule that's inactive. Expect: field error.
- Try a rule whose allowed-agents list excludes the current agent. Expect: field error.
- Try a rule scoped to a price type different from the order's. Expect: field error.

### Per-line manual amount

- On a line whose price type allows manual editing, type a per-unit discount of 1,000 UZS. Verify line discount = 1,000 × quantity.
- Same on a line whose price type forbids manual edits. Expect: field error.

### Header auto-discount

- Create an order on a client/agent/trade combo that matches an auto-discount rule. Verify after save: the order has a link record to that rule, and the discount total reflects it.
- Create an order on a combination that matches **no** auto-discount rule. Verify after save: no link record exists, no auto-discount on the order.
- Create an order whose **total value** crosses the rule's threshold (e.g. 1M UZS triggers a 5% discount). Test just below the threshold (no discount) and just at / above (discount applied).

### Combined-path tests

- Add a per-line manual discount **and** save into an order that also matches an auto-discount rule. Verify both are recorded; verify the printed invoice shows the per-line one; verify the discount-audit report shows both.
- Edit such an order so the line quantity drops below the auto-discount threshold. Verify the auto-discount link is removed (or flagged as no-longer-applicable).
- Edit a line's manual discount to a different rule. Verify the old rule's link is replaced.

### Edge cases

- Discount that would push the line total to exactly zero. Verify accepted.
- Discount that would push the line total negative. Verify rejected.
- Discount on a line whose quantity is later marked defective. Verify the line's discount amount is recalculated proportionally (e.g. defect of half the quantity drops the discount by half).
- An order with two lines of the same product but different discounts on each. Verify both are saved and the printed invoice shows them separately.

### Role gating

- Operator and Operations on web — can pick manual discounts. ✅
- Agent (4) on mobile — can pick manual discounts on lines. ✅
- A user from filial A cannot pick filial B's discount rules.

### Side effects to verify

- The order's totals reflect the discount.
- The line's stored discount amount matches the displayed amount.
- Auto-discount link record exists if and only if a rule matched.
- The client's debt drops by the discount-reduced order total, not by the gross.
- The order history records the discount choice.
- The printed invoice shows the per-line discounts as line entries.

## Where this leads next

- For bonus orders (free gifts) and how they interact with discount totals, see [Bonuses](./bonuses.md).
- For how editing an order affects the discount paths above, see [Edit order](./edit-order.md).

## For developers

Developer reference: `docs/modules/orders.md` — see *Cross-module touchpoints* (discount.SkidkaManual reads).
