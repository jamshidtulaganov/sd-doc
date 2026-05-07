---
sidebar_position: 1
title: Wireframes (current UI)
---

# Wireframes — current SalesDoctor UI

This section is for **new frontend developers** joining the team. It
captures **what the app looks like today** so you can match the existing
patterns when you build new screens.

It is intentionally a **wireframe / layout** reference, not a deep
design system — visual style (colors, fonts, micro-interactions) lives
in the Figma file `SD-Web-old.fig`.

## Source

The page screenshots referenced below were extracted from the user's
Figma file `SD-Web-old.fig`. There are **60 page-level wireframes**
under `static/wireframes/extracted-from-figma/page-NN-WIDTHw.png`.

If you want fresh exports, open the Figma file directly:

> `~/projects/salesdoctor/sd-docs/static/wireframes/SD-Web-old.fig`

(or upload it to figma.com to get a shareable URL).

## The canonical layout

Every page in the SalesDoctor admin shares this skeleton.

```
┌──────────────────────────────────────────────────────────────────────┐
│  TOP BAR                                                             │
│  Logo · role tabs (Sales / Касса / GPS / Онлайн-помощь)              │
│      · search · date range · balance · notifications · user         │
├──────┬───────────────────────────────────────────────────────────────┤
│ LEFT │   PAGE                                                        │
│ NAV  │   ┌─ breadcrumbs ────────────────────────────────────────┐    │
│      │   └──────────────────────────────────────────────────────┘    │
│ icon │   ┌─ page title + primary actions ──────────────────────┐    │
│ rail │   └──────────────────────────────────────────────────────┘    │
│      │   ┌─ filters ───────────────────────────────────────────┐    │
│  …   │   └──────────────────────────────────────────────────────┘    │
│      │   ┌─ content (table / form / map / cards) ──────────────┐    │
│      │   └──────────────────────────────────────────────────────┘    │
└──────┴───────────────────────────────────────────────────────────────┘
```

### Top bar

- Left: logo / brand
- Mid-left: role-driven tabs (Sales, Касса, GPS, Онлайн-помощь, …)
- Center: global search "Найти страницы (Ctrl+K)"
- Right: date-range picker, balance pill, notifications, user menu

### Left navigation rail

Vertical icon-rail with labels:

`Планы · Заявки · Склад · Клиенты · Агенты · Отчеты · Настройки ·
Аудит 2 · Команда · Диагностика`

The rail is **role-filtered** — different roles see different items.

### Page area

The content area always has, in order:

1. **Breadcrumbs**
2. **Page title** + the **primary action button** in the top-right
3. **Filter bar** (top) or **filter rail** (left, for heavy reports)
4. **Content** — table, form, map+sidebar, KPI grid, or detail panel

## Page patterns (with examples)

### 1. KPI dashboard tiles

Large colored blocks with a single metric, plan vs fact below. Used on
the home dashboard and KPI screens.

![KPI tiles](/wireframes/extracted-from-figma/page-0-1512w.png)

Apply with: 4 tiles per row at desktop, 2 per row at narrow. Color is
threshold-driven (red = below plan, green = on / above plan).

### 2. List + filters (default)

Top filter chips → table → pagination footer. The most common pattern.

```
┌─────────────────────────────────────────────────────────────┐
│ [date▾] [agent▾] [status▾] [type▾] [+ more filters]   [Add]│
├─────────────────────────────────────────────────────────────┤
│  table                                                       │
└─────────────────────────────────────────────────────────────┘
```

### 3. Form + summary (detail edit)

Left = form sections; right = "Итоги" (Summary) + a related table.

![Stock transfer page](/wireframes/extracted-from-figma/page-1-3132w.png)

Above is the **stock transfer (Перемещение товара)** page:
- Left column: form (Со склада, На склад, ТСД Сканер, Комментарий).
- Right column: live summary of items + totals.
- Below: tabs (Все / Напитки / Шоколад / …) + product table.

### 4. Map + side panel

Full-bleed map with a docked right panel. Used for GPS, monitoring,
route planning.

![GPS monitoring](/wireframes/extracted-from-figma/page-13-2922w.png)

The right panel toggles between **Мониторинг** and **Маршрут** modes.

### 5. Master list + detail panel

For entities you want to scan and drill into without changing pages.
Two-column: table on the left, selected-record details on the right.

### 6. Tabs over a single content area

Used inside detail pages to break long forms into "sections without
scrolling" (e.g. Profile, Plans, Logs).

## Component cheat-sheet

| Pattern | Where in the legacy Yii views | Replacement, if any |
|---------|--------------------------------|---------------------|
| Top bar + sidebar | `protected/views/layouts/main.php` (sd-main) | – |
| Sidebar links | `protected/views/partial/sidebar.php` | – |
| Filter bar | per-controller view, jQuery | – |
| DataTable | `protected/views/orders/list.php` etc. + `js_plugins/FixedColumns` | – |
| Modal | `protected/views/modals/*` + `js_plugins/fancybox2` | – |
| KPI tile | `protected/modules/dashboard/views/...` | – |
| Map | `protected/modules/gps3/views/...` + `ng-modules/gps/` | Angular component |
| Charts | `js_plugins/jquery-highcharts-10.3.3` | – |

## Extracted page reference

All 60 pages live under `/wireframes/extracted-from-figma/`. They're
named `page-N-WIDTHw.png`. Open the folder in your editor to scan them
all; we suggest:

```bash
open sd-docs/static/wireframes/extracted-from-figma/
```

Pick the closest existing page when designing a new screen — match its
layout, density, and component choices unless there's a specific reason
to depart.

## Drop your own exports

Add new wireframes by exporting the relevant Figma frame as PNG (2×)
and dropping into `static/wireframes/`. Reference it from a markdown
page:

```markdown
![Outlet detail](/wireframes/outlet-detail.png)
```

Naming convention: `<area>-<page>.png`, e.g. `orders-list.png`,
`client-detail.png`, `report-bonus.png`.

## See also

- [Page layout](./page-layout.md)
- [Filters](./filters.md)
- [Tables](./tables.md)
- [Forms](./forms.md)
- [Modals](./modals.md)
