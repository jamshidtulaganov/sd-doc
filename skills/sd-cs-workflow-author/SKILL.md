---
name: sd-cs-workflow-author
description: Use when drafting or refreshing a feature workflow page in /sd-docs/docs/sd-cs/workflows/. Triggers include "document feature X", "write workflow page for the AKB pivot", "add a workflows page for the inventory report". Produces an onboarding-grade page that follows /docs/sd-cs/workflows/style.md.
---

# Skill — sd-cs feature workflow author

Use this skill when the request is to **document one feature** of
`sd-cs` (one report, one pivot, one directory page, one API endpoint)
as a Markdown page under `sd-docs/docs/sd-cs/workflows/`.

## When NOT to use this skill

- General `sd-docs/` page → use `sd-docs-author` instead.
- New diagram or refresh of an existing one → use `diagram-author`.
- Documenting an `sd-main` or `sd-billing` feature → wrong project;
  this skill only knows the sd-cs filial / two-DB model.
- Designing a *new* workflow that does not exist yet → that's a PRD,
  not a workflows page.

## Required reading before drafting

The skill assumes the agent has read or will read:

1. [`docs/sd-cs/workflows/style.md`](../../docs/sd-cs/workflows/style.md)
   — the eight required sections and the falsifiable-rule bar.
2. [`docs/sd-cs/architecture.md`](../../docs/sd-cs/architecture.md)
   — the two-DB model, filial registry, `setFilial()` mechanism.
3. The actual **controller file** (path supplied by the user).

Do not draft the page from memory or from a similar feature — read
the source first. The most common mistake is reusing language from
the AKB page on the OKB page when the queries differ.

## Output format

A single Markdown file at:

```
sd-docs/docs/sd-cs/workflows/<slug>.md
```

Where `<slug>` is `<module>-<feature>` lower-kebab-case. Examples:

| Slug | Feature |
|------|---------|
| `report-sale.md` | `report/SellController` |
| `pivot-akb.md` | `pivot/AkbController` |
| `report-inventory.md` | `report/InventoryController` |
| `api-isellmore-v4.md` | `api/Isellmore4Controller` |

Frontmatter is fixed:

```yaml
---
sidebar_position: <integer, unique within workflows/>
title: <module> · <feature>
---
```

## Eight required sections, in order

| # | Section | Heading |
|---|---------|---------|
| 1 | Purpose | `## Purpose` |
| 2 | Who uses it | `## Who uses it` |
| 3 | Where it lives | `## Where it lives` |
| 4 | Workflow | `## Workflow` |
| 5 | Rules | `## Rules` |
| 6 | Data sources | `## Data sources` |
| 7 | Gotchas | `## Gotchas` |
| 8 | See also | `## See also` |

Do not invent extra top-level sections. If something doesn't fit, it
belongs in another doc and should be linked.

## Research procedure

1. **Open the controller file** named in the request. Note:
   - `$allowedActions` — public actions that bypass access checks.
   - `const ReportConfigCode` — the saved-report bucket name.
   - Each `action<X>` method — its inputs, its DB it touches.
2. **Identify the connection used** — `Yii::app()->db` (cs3_*) or
   `Yii::app()->dealer` (b_*). Most reports/pivots use `dealer`.
3. **Identify which models call `setFilial()`** — these are the
   per-tenant tables.
4. **Identify input whitelists.** Many reports whitelist `groupBy`,
   `date` field, etc. — these go into Rules.
5. **Identify scoping.** `BaseModel::getOwnModels()` is the standard
   filial-scoping call. `UserProduct::findByUser()` is the
   product-scoping call. `country_id` filters via `cs_filial_detail`.
6. **List the tables touched.** Separate `cs_*`, `d0_*` (dealer
   global), and `d0_fN_*` (per-filial).
7. **Find the route.** Yii URL rules in `protected/config/main.php`
   collapse to `/<module>/<controller>/<action>`. `actionIndex` is
   typically the page; the rest are AJAX endpoints.
8. **Check the saved-report sub-feature.** Most reports/pivots
   support save / load via `actionReports`, `actionSaveReport`,
   `actionDeleteReport`, with config keyed by `ReportConfigCode`.

## Falsifiable rules — the bar

A good rule cites the source and is checkable.

> Good: *"`groupBy` is whitelisted to one of `t.PRODUCT`,
> `t.PRODUCT_CAT`, `p.BRAND`, `order.AGENT_ID`,
> `order.AGENT_ID, t.PRODUCT_CAT`, `order.AGENT_ID, order.CLIENT_CAT`,
> `order.CITY_ID`, `order.CLIENT_CAT`. Any other value falls back to
> `t.PRODUCT` (`AkbController::actionPivotData`)."*

> Bad: *"groupBy is validated."*

Every rule should be defensible by pointing at a line of code.

## Common phrases to reuse

- *"Reads from `Yii::app()->dealer` (the `b_*` warehouse)."*
- *"Per-filial tables are addressed via `Model::setFilial($prefix)`,
  which rewrites the table token from `{{client}}` to
  `{{fN_client}}`."*
- *"Filial scope = `BaseModel::getOwnModels()` — admins see all
  active filials; other users see the intersection of
  `cs_user_filial` and `d0_filial.active='Y'`, optionally filtered
  by `country_id` via `cs_filial_detail → cs_territory →
  cs_region`."*

These are facts about the platform, not the specific feature; use
them verbatim so feature pages stay consistent.

## Catalog wiring

After drafting the file:

1. Add an entry to
   [`docs/sd-cs/workflows/index.md`](../../docs/sd-cs/workflows/index.md)
   with a 1-line stub.
2. Add the slug to the *Feature workflows* category in
   [`sidebars.js`](../../sidebars.js) — alphabetical within its
   sub-bucket.
3. Set `sidebar_position` to the next free integer in the workflows
   directory.

## Page review checklist

Before merging:

- [ ] Eight required sections, in order, no extras.
- [ ] Frontmatter has `sidebar_position` and `title: <module> ·
      <feature>`.
- [ ] Every rule is falsifiable.
- [ ] Every workflow step is externally observable.
- [ ] Tables in **Data sources** mark each row with the schema
      (`cs3_demo` / `b_demo`) and prefix family.
- [ ] Mermaid blocks (if any) use the platform colour classes from
      [`docs/diagrams`](../../docs/diagrams/index.md).
- [ ] Catalog index updated.
- [ ] Sidebar updated.
- [ ] No copied-and-pasted paragraphs from other feature pages
      (other than the common phrases above).
