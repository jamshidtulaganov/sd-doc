---
sidebar_position: 3
title: Facing & SKU presence
audience: QA
---

# Facing (shelf-share) & SKU presence

## What this feature is for

These are the two **flagship reports** of the v1 audit module. Both answer a question the dealer asks of the field force every day:

- **Facing** — *"What is our share of the shelf at each outlet?"* The agent counts physical product faces on the shelf, bucketed by brand and audit-category. The web rolls them up to a **percentage share of category facings** per (outlet × category) and per (city × category) and per (client-category × audit-category).
- **SKU presence** — *"Out of all the products that should be on this shelf, how many are actually here?"* The agent ticks the SKUs they see in the outlet. The web reports an **assortment count** (how many SKUs in each audit-category were found) plus a roll-up by city and by client-category, and an **active-clients (АКБ)** total — how many distinct outlets contributed.

Both reports default to the last **30 days** and both work strictly with v1 data. On a v2 dealer the same questions are answered from inside the retail audit at `/adt/adtAudit/fullReport` (see [Visit audit](./visit-audit.md)).

## Who uses it and where they find it

| Role | What they do here | How they get to the screen |
|---|---|---|
| Operator (3) / Operations (5) / KAM (9) | Runs the report, filters by city / category / agent, exports | Web → Аудит → **Доля полки** (`/audit/facing`) or **Присутствие** (`/audit/sku`) |
| Supervisor's auditor (8) | Read access | Same URL |
| Field agent (4) | Captures the underlying data on the phone — does not see the web reports | Mobile app |

Both reports live **only** in the v1 menu. On v2 dealers these menu entries are hidden.

## The workflow — at a glance

```mermaid
flowchart TB
    Mob[Mobile audit form<br/>agent counts facings<br/>agent ticks SKU presence] -->|submit| F[(aud_facing rows)]
    Mob -->|submit| S[(aud_sku rows)]

    subgraph "Facing report — /audit/facing"
      F --> FQ[Filter by date / city / category / agent]
      FQ --> FR1[Per-outlet:<br/>category COUNT, AVG]
      FR1 --> FR2[Per (parent-category × city):<br/>share % = sum within / sum across]
      FR1 --> FR3[Per client-category:<br/>same share calc]
    end

    subgraph "SKU report — /audit/sku"
      S --> SQ[Filter by date / city / category / product / agent + min-max SKU count]
      SQ --> SR1[Per-outlet:<br/>SKU COUNT in each category]
      SR1 --> SR2[Per (parent-category × city):<br/>SKU count + active-clients АКБ]
      SR1 --> SR3[Per category × city:<br/>avg SKUs and total clients]
    end
```

## Step by step

### Facing — `/audit/facing`

1. The operator opens **Аудит → Доля полки**.
2. The page loads with **default date range = last 30 days** ending today.
3. The operator chooses filters: date range, city, client category, parent audit-category, audit-category, place type (e.g. cooler / shelf / promo zone), and agent. Plus an optional **min / max facing count** to exclude tiny or huge values.
4. The operator presses **Filter / Search**.
5. *The system groups the underlying facing data* by *(client × audit-category)* and sums the facing counts per group.
6. *The system rolls up the per-outlet sums* three ways:
   - **Per (parent-category × audit-category)** — share % = `facing_in_category / total_facing_in_parent × 100` summed across all outlets.
   - **Per city × audit-category** — same calculation, scoped to the city.
   - **Per client-category × audit-category** — same calculation, scoped to the client category.
7. *The system also computes the per-outlet AVG facing* — used for the "client view" tab.
8. The grid renders four tabs: **Total**, **By city**, **By client category**, **Per outlet**. Each shows shelf-share % cells coloured by threshold.
9. The operator can click a category column → drill down to the list of outlets feeding that cell.

### SKU presence — `/audit/sku`

1. The operator opens **Аудит → Присутствие**.
2. The page loads with **default date range = last 30 days**.
3. The operator chooses filters: date range, city, client category, parent audit-category, audit-category, specific product, agent.
4. The operator may set a **min SKU count** and a **max SKU count** — only outlets whose total SKUs-found in any audit-category fall in this band will appear. Both bounds, only one bound, or neither are all accepted.
5. The operator presses **Filter / Search**.
6. *The system queries* the SKU presence rows for the date range, grouped by *(client × audit-category)*, with the HAVING clause applied to honour the min/max filter.
7. *The system rolls up* the per-outlet SKU counts:
   - **Per (parent-category × audit-category)** — sum of SKUs across outlets.
   - **Per city × audit-category** — sum of SKUs across outlets in that city.
   - **Assortment per (city × audit-category)** — sum + outlet-count, so the report can show *"average SKUs per outlet"*.
   - **Active clients (АКБ)** — distinct outlet count per city and overall.
8. The grid renders the same four tabs as facing, plus the АКБ block at the top.

## What can go wrong (errors the operator sees)

| Trigger | What the user sees |
|---|---|
| Filters return zero outlets | *"По вашему запросу ничего не найдено"* / *"filtr parametrlarini to'g'ri kirit!"* — no error, just an empty result message. |
| Date range with no audits | Same as above. |
| min SKU > max SKU on `/audit/sku` | The query honours the swapped range and returns nothing. No validation message. ⚠ Test this — it surprised QA in the past. |
| Negative or non-numeric min/max | Coerced to zero. Filter behaves as if absent. |
| Category set to a parent-category in one filter and a child of a different parent in another | Empty result — no error. |
| All city options unchecked vs none of them checked | Treated the same — no filter applied. |
| Open the report on a v2 dealer | Menu entry is hidden; visiting `/audit/facing` directly will load but return zero data (the agents on v2 don't write to the v1 facing table). |

## Rules and limits

### Facing

- **A facing is a count of physical product faces visible on the shelf**, scoped by brand and category. One facing record means "I saw N faces of this category-brand in this place on this date in this outlet."
- **Shelf share is calculated *per parent audit-category*.** A 30% share of the *Beverages* parent does not mean 30% of the whole shelf — it means 30% of the *Beverages* sub-categories that the audit covered.
- **AVG facing per outlet** is what the per-outlet tab uses. The roll-up tabs use the SHARE % (a quotient), not the raw counts.
- **Place type matters.** Facings in the "cooler" place are not summed with facings on the "shelf" place unless the operator leaves the place filter empty.

### SKU presence

- **One SKU presence record = the agent ticked one product as present** in one outlet on one date. There is no quantity field — just presence.
- **АКБ (active clients) is a distinct-outlet count.** An outlet visited five times in the range counts once.
- **Filter by product narrows to outlets where *that specific product* was ticked.** It does **not** show "outlets where the product was missing" — only those where presence was recorded.
- **The HAVING filter (min/max SKU)** applies to the per-outlet, per-category total — not to the overall report.

### Both reports

- **Default 30-day window.** If a tester says *"yesterday's data isn't here"*, almost always it is — they just didn't widen the range.
- **No editing on these pages.** They are read-only roll-ups. Corrections happen on `/audit/audits` per-visit detail.
- **Agent filter requires the chosen agent to have ROLE = 4.** Audits submitted by a supervisor or auditor (roles 6 / 8) under their own ID will not match when filtered by *agent*.
- **No close date.** All dates from the dawn of the system are reportable as long as data exists.

## What to test

### Facing report

- Default open: 30-day window, no filters → grid renders with all cities, all categories.
- One-city filter → grid shrinks to that city's outlets only.
- Two cities checked → grid shows both.
- Client-category filter narrows correctly.
- Min/max facing filter excludes outlets outside the band — verify both bounds.
- Place-type filter — pick "cooler" only — verify shelf place is excluded.
- Date range with zero audits → *"Nothing found"* result, no error.
- Drill from the *Per (parent × category)* tab into the outlet list — verify each outlet's contribution matches its raw facing count.
- Two outlets in the same city, very different facing counts → check the share % calculation is *(sum within category) / (sum across parent) × 100*, not an average of percentages.
- One outlet missing facing data in a category → that outlet should not contribute to the denominator for that category in the share calc.

### SKU presence report

- Default open: 30-day window → grid renders, АКБ shown at the top.
- Filter by one product → only outlets where that product was ticked show up.
- Filter by one category → only outlets with at least one SKU in that category show up.
- Min SKU = 5 → only outlets with ≥ 5 SKUs in some category show up.
- Min SKU = 5, max SKU = 10 → outlets with at least one category in the 5-10 band show up.
- Min SKU = 10, max SKU = 5 (swapped) → expect either empty result or validation block.
- АКБ block: number of distinct outlets in the result. Verify against a manual count.
- Two agents visited the same outlet on different days → one outlet in АКБ, two days of SKU rows.

### Cross-feature

- Submit an audit on the phone, then open both reports — verify the visit appears in both within the same date range.
- Edit a SKU line on `/audit/audits` detail → return to `/audit/sku` → verify the edited line's data is reflected on next page reload.
- Delete a facing line on the detail → return to `/audit/facing` → that line is gone.
- Run the same report on day 30 vs day 31 — verify the row drops off when the 30-day window slides past it.

### Role gating

- Operator (3), Operations (5), KAM (9) can open both reports.
- Supervisor's auditor (8) can open both reports (read-only).
- Field agent (4) — verify both URLs are blocked / hidden.

## Where this leads next

- The page-by-page edit screen behind these aggregates: [Visit audit](./visit-audit.md).
- Where audit-categories, brands and the AKB rules are configured: [Audit settings](./audit-settings.md).
- The photo-evidence parallel to facing data: [Photo reports](./photo-reports.md).

## For developers

- `protected/modules/audit/controllers/FacingController.php` — `actionIndex` builds the per-outlet group and the three roll-up paths.
- `protected/modules/audit/controllers/SkuController.php` — `actionIndex` with the HAVING clause for the min/max filter and the АКБ accumulator.
- Tables: `aud_facing` (with `CAT_ID`, `PARENT_CAT_ID`, `PLACE_ID`, `BRAND_ID`, `COUNT`) and `aud_sku` (with `PRODUCT_ID`, `CAT_ID`, `PARENT_CAT_ID`, `PRICE`).
- Look-ups: `aud_brands`, `aud_category` (parent + children, with `BRAND` and `FACING_CHECK` flags), `aud_place_type`, `aud_product`.
