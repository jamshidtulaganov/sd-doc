---
sidebar_position: 7
title: Component catalog (wireframe-level)
audience: New frontend / mobile developers
summary: Wireframe-level catalog of the reusable UI parts in the SalesDoctor admin — what each part is, where it appears, and what to copy from when you need a new one.
topics: [components, ui-patterns, table, kpi-tile, breadcrumb, pagination, modal, form-section]
---

# Component catalog (wireframe-level)

This is a **wireframe-level** component catalog. It lists every
reusable UI part you'll see in the admin, what it's used for, and
where the existing implementation lives. It is **not** a Storybook —
visual design lives in `SD-Web-old.fig`.

When you build something new, find the closest match here and reuse
its markup pattern.

## Layout chrome

### Top bar

```
┌──────────────────────────────────────────────────────────────┐
│  ☰  LOGO  | Sales · Касса · GPS · Онлайн-помощь | 🔍 search   │
│                       date-range · 💰 balance · 🔔 · 👤      │
└──────────────────────────────────────────────────────────────┘
```

**Where**: every page. **Markup**:
`protected/views/layouts/main.php` → `views/partial/topbar.php`.

### Left rail (sidebar)

```
🗒  Планы
📑  Заявки
📦  Склад
👥  Клиенты
🛵  Агенты
📊  Отчёты
⚙  Настройки
🔍  Аудит
👨‍👩‍👧  Команда
🩺  Диагностика
```

**Where**: every page (except modal-only views). **Role-driven** —
RBAC hides items the user can't access.

### Breadcrumbs

`Dashboard › Orders › List` — mandatory beyond depth 2.

### Page header

```
Page Title                                       [+ New thing]
```

Primary action top-right. Secondary actions in a `⋮` overflow.

## Tabular components

### Default data table

| col | col ↕ | col | … | ⋮ |

- First column = row number or checkbox (multi-select)
- Header row sticky
- `↕` indicates sortable
- Money columns right-aligned
- Status column = coloured pill (see Status pill below)
- Last column = `⋮` with row actions (Edit / Duplicate / Delete)
- Footer: pagination + page-size selector + total count

**Where**: every list screen (orders, clients, agents, payments, …).
**Library**: DataTables + `js_plugins/FixedColumns`.

### Grouped / expandable table

```
▶ Group A    sum=…    count=…
  ┌─ row …
  └─ row …
▶ Group B
```

**Where**: hierarchical reports (per-agent → per-order, per-category
→ per-product).

### Inline-edit table cell

Double-click a cell → it becomes an input → blur or Enter saves via
AJAX.

**Where**: price types, categories, agent settings.

## Tile / card components

### KPI tile

```
┌─ Title ───────────────────────────┐
│  1,247                            │
│  Plan: 161        Fact: 3 + 0     │
└───────────────────────────────────┘
```

- Big number
- Subtle plan / fact line
- Background colour = threshold (red / amber / green)
- 4 per row at desktop, 2 at ≤ 1024 px

**Where**: dashboard. **Wireframe**: [page-0](/wireframes/extracted-from-figma/page-0-1512w.png).

### Detail panel card

```
┌─ Card title ──────────────────────┐
│  Field 1:    value                │
│  Field 2:    value                │
│  …                                │
└───────────────────────────────────┘
```

**Where**: client detail, agent detail, order summary.

## Status pills

| Background | Meaning |
|------------|---------|
| Green | OK / Paid / Delivered / Active |
| Amber | Pending / Awaiting approval |
| Red | Cancelled / Defect / Expired |
| Gray | Draft / Closed / Archived |
| Blue | In progress / Loaded |

Always include the text label inside the pill — colour is
augmentative, never the only signal (accessibility).

## Filters

### Top filter bar

```
[ Date range ▾ ] [ Status ▾ ] [ Agent ▾ ] [ + More filters ]   [ Apply ]
```

- ≤ 6 visible chips, rest collapse behind "More filters".
- Default date = last 30 days.
- Filter state persisted in URL query params (so links can be
  shared).

### Filter rail (left, for heavy reports)

```
▣  Date
   From [_]
   To   [_]
▣  Status
   ☑ New / ☐ Loaded / ☑ Paid
▣  Agent
   [Search ]
[Apply] [Reset]
```

**Use when**: ≥ 10 filters or grouping needed.

## Forms

### Section form

```
┌─ Section title ──────────────────────┐
│  Field   [_______________________]   │
│  Field   [______]   Toggle  ☑        │
└──────────────────────────────────────┘
```

- Two-column on desktop, single column at narrow.
- Required fields marked with red asterisk.
- Inline validation per field; banner at top for cross-field errors.
- Sticky footer for forms taller than the viewport.
- Primary `Save` (right), secondary `Cancel` (left); plus optional
  `Save and add another`.

### Inline edit

Double-click → input → blur / Enter saves. Used for price types,
categories, agent settings.

## Modals

### Confirm modal

```
┌── Cancel order #O-2026-0123 ────────┐
│                                      │
│  This will release reserved stock    │
│  and mark the order as cancelled.    │
│  This cannot be undone.              │
│                                      │
│           [Cancel]  [Confirm]        │
└──────────────────────────────────────┘
```

- Title = action verb + entity (`Cancel order #…`).
- Body ≤ 80 words. Be specific about consequences.
- Primary action right; **destructive primary is red**.
- Esc closes; Enter triggers primary unless inside a textarea.
- **Don't stack modals.**

### Edit-in-modal

For quick edits (≤ 8 fields). For ≥ 8 fields open a full page
instead.

**Library**: `js_plugins/fancybox2`.

## Map components

### Full-bleed map + right panel

```
┌──────────────────────────────────┬────────────┐
│                                  │  Tabs      │
│           map                    │  filters   │
│                                  │  list      │
└──────────────────────────────────┴────────────┘
```

**Where**: GPS monitoring, route view, geofence verification.
**Wireframes**: [page-2](/wireframes/extracted-from-figma/page-2-2922w.png),
[page-13](/wireframes/extracted-from-figma/page-13-2922w.png),
[page-25](/wireframes/extracted-from-figma/page-25-2942w.png).
**Library**: Angular module under `ng-modules/gps/`.

### Trip-playback controls

```
[ ◀ ] [ ⏯ ] [ ▶ ]   1× / 2× / 4×
[━━━●━━━━━━━━━]   00:00 / 24:00
```

**Where**: GPS history. **Wireframe**: [page-26](/wireframes/extracted-from-figma/page-26-2918w.png).

## Notifications

### Toast

Top-right, auto-dismiss after 5 s. Library: `js_plugins/noty`.

### In-app bell

Top-bar bell icon → dropdown of recent notifications. Items link to
the relevant entity.

### Banner (page-level)

Top of the content area. Use for:

- "Licence expires in 3 days" (warning)
- "Your last sync failed" (error)
- "New release notes available" (info)

## Charts

`js_plugins/jquery-highcharts-10.3.3`. Use:

- **Line** for trends over time.
- **Column** for compare-by-period.
- **Pie** sparingly — only for ≤ 5 slices summing to 100 %.
- **Combo** (line + bar) for plan vs fact.

## Print templates

`protected/views/invoiceTemplate/`. Per-tenant, configured under
**Settings → Templates**.

## Mobile (web admin) responsive

The admin is **desktop-first** (1280 × 800 minimum). Below that:

- Sidebar collapses to icon-only.
- Tables overflow horizontally with sticky first column.
- Modals become full-screen.

There is no narrow-phone layout for the web admin — phone users use
the dedicated mobile app.

## When to add a new component

Don't, unless:

- You can't compose the need from existing parts.
- The same need appears in **3 +** screens.
- You have approval from the design lead.

If yes, add the wireframe PNG to `static/wireframes/` and a row to
this catalog in the same PR.
