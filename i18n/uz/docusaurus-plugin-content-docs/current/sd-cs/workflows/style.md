---
sidebar_position: 0
title: How to write a feature page
---

# How to write a feature workflow page

This guide tells you **how to document one feature** of sd-cs (one
report, one pivot, one directory page, one API endpoint) so that a
new employee can read it once and use the feature confidently.

It is the writing companion to the platform-wide
[Workflow design standards](/docs/team/workflow-design) — that page
covers *designing* a workflow; this page covers *writing the page*
about an existing one.

## Audience and goal

Reader profile:

- New employee in their **first month**.
- Has read the [sd-cs overview](../overview.md) and
  [architecture page](../architecture.md), so they know there are two
  databases (`cs_*` control plane, `d0_*` warehouse) and that filials
  scope dealer data.
- Is **not** a Yii expert.
- Wants to answer one of two questions:
  1. *"What does this feature do, and how do I use it?"*
  2. *"If a customer says it's broken, where do I look?"*

If a page does both, you've written a good page.

## What we're not writing

- **Tutorials** ("click here, then here") that go stale every release.
- **Code dumps** of controller bodies — link to the file instead.
- **Spec / design docs** for unbuilt features — that's PRD territory.
- **Reference duplication** — the field list lives in
  [data schemes](../data-schemes.md). Link, don't restate.

## Required sections

Every feature page has these eight sections in this order. **Do not
add new top-level sections** — if something doesn't fit, it probably
belongs in another doc and should be linked.

| # | Section | What goes there |
|---|---------|-----------------|
| 1 | **Purpose** | One paragraph. The business question this feature answers. No code, no UI. |
| 2 | **Who uses it** | Roles + the access keys (`module.controller.action`) that gate it |
| 3 | **Where it lives** | URL, controller path, key view files, related model classes |
| 4 | **Workflow** | Numbered list. The user's path from "open page" to "got the answer". Mermaid sequence diagram if there are 3+ actors |
| 5 | **Rules** | Bullet list. Validation, scoping, edge cases. Each rule starts with a verb (*"Filters by …"*, *"Excludes products in …"*) |
| 6 | **Data sources** | Two-column table: *Table* / *DB & connection*. Distinguish `cs_*` (control) and `d0_*` / `d0_fN_*` (warehouse) |
| 7 | **Gotchas** | The two or three things that surprise new employees (slow queries, NULL semantics, prefix mismatch, …) |
| 8 | **See also** | 2–4 links — the related architecture page, neighbouring features, the source file |

## Voice and style

- **Subject is the feature, not the user.** Write *"The report aggregates
  sales by filial"*, not *"You can aggregate sales by filial"*.
- **Verbs in present indicative.** *"Loads", "filters", "writes"* —
  not *"will load", "should filter"*.
- **One sentence per bullet.** If you need a comma-then-but, split it.
- **Numbers and proper names are exact.** *"7 active filials in the
  demo DB"*, not *"around 7 filials"*. Run the query if you don't
  know.
- **Cross-reference, don't repeat.** Link the architecture page once
  for the multi-DB / multi-filial mechanics; don't re-explain them.
- **One screenshot is fine, three is too many.** Pages should remain
  searchable and translatable; lean on the workflow numbered list.

## Visual taxonomy

If the page has a diagram, use the platform-standard colours from the
[Diagram gallery](/docs/diagrams):

| Colour | Class | Meaning |
|--------|-------|---------|
| Blue | `action` | Standard step |
| Amber | `approval` | Requires review / approval |
| Green | `success` | Final OK / closed state |
| Red | `reject` | Failed / cancelled state |
| Grey | `external` | External system (1C, Telegram, FCM, …) |
| Purple | `cron` | Scheduled / time-driven |

## Rules section — quality bar

The **Rules** section is where most onboarding value lives. A good
rule is **falsifiable**: a reader can check it against the code or the
data and tell whether it is true today. Bad rules are vague.

| Bad | Good |
|-----|------|
| *"Filters work as expected."* | *"`date` filter applies to `order.DATE`; `dateLoad` filter applies to `order.DATE_LOAD`. Default is `date`. Other values are silently coerced to `date` (whitelist in `AkbController::actionPivotData`)."* |
| *"Only admins see all dealers."* | *"`getOwnFilials()` returns all active filials when `Yii::app()->user->isAdmin()` is true; otherwise it returns the intersection of `cs_user_filial` and `d0_filial.active='Y'`."* |

If you can't write a rule that's falsifiable, **read more code** —
the rule is already in the source, you just haven't found it yet.

## Workflow section — quality bar

A workflow step is **observable from outside the function**: it
either changes UI, sends an HTTP request, writes to a DB, or shows a
result. Implementation steps ("loops the filials array") belong in
**Rules** or **Gotchas**, not in the workflow.

```
Bad workflow step:  "Constructs CDbCriteria with date range."
Good workflow step: "User picks a date range and clicks Apply."
                    "Page POSTs filters to /pivot/akb/pivotData."
                    "Server returns NDJSON, one line per filial."
                    "Page renders pivot grid client-side."
```

## Data sources section — what to include

For each table referenced by the feature, list:

- **Schema** — `cs3_demo` (control) or `b_demo` (warehouse).
- **Prefix family** — `cs_`, `d0_`, or `d0_fN_` (per-filial).
- **Why it's read** — one line.

Do **not** redocument columns; link to
[data schemes](../data-schemes.md) instead.

## Frontmatter

Every page uses:

```yaml
---
sidebar_position: <integer, unique within workflows/>
title: <module> · <feature> # e.g. "report · Sale"
---
```

The `<module> · <feature>` title is what shows up in the sidebar and
search. Keep it short and machine-sortable.

## Reviewing your own page

Before opening a PR, run these four checks:

1. **Find a real new employee** (or simulate). Hand them the page.
   They should be able to operate the feature in the staging
   environment within 10 minutes.
2. **Every rule is falsifiable.** Reread the **Rules** section and
   ask *"Could I prove this wrong from the code or DB?"* — if not,
   rewrite or delete.
3. **No section is missing.** All eight required sections are present
   in order.
4. **Cross-links work.** Run `npm run build` locally; broken-link
   warnings are CI failures.

## See also

- [Workflow design standards](/docs/team/workflow-design) — how we
  *design* workflows (vs. how we document them).
- `sd-docs/skills/sd-docs-author/SKILL.md` — the general writing
  skill for any page in `sd-docs/`.
- `sd-docs/skills/sd-cs-workflow-author/SKILL.md` — the skill that
  follows *this* style guide to draft a feature page from a
  controller path.
