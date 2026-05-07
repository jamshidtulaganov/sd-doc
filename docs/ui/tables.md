---
sidebar_position: 4
title: Tables
---

# Tables

Tables are the workhorse UI. Built on DataTables with a few of our own
conventions.

## Default table

```
┌─────┬───────────────┬──────────┬─────────┬─────────┬────────┬────┐
│  #  │  Order ID  ↕  │ Date  ↕  │ Client  │ Agent   │ Sum  ↕ │ ⋮  │
├─────┼───────────────┼──────────┼─────────┼─────────┼────────┼────┤
│  1  │ O-2026-0123   │ 07-05    │ Acme    │ Ivanov  │  3.2 M │ ⋮  │
│  2  │ O-2026-0122   │ 07-05    │ Beta    │ Petrov  │  1.1 M │ ⋮  │
│ ... │ ...           │ ...      │ ...     │ ...     │  ...   │ ⋮  │
├─────┴───────────────┴──────────┴─────────┴─────────┴────────┴────┤
│  ‹  1 2 3 4 5  ›        Rows per page  [25 ▾]    1–25 of 1247    │
└──────────────────────────────────────────────────────────────────┘
```

<div className="wireframe">
  <img src="/wireframes/table-default.png" alt="Default table" />
  <div className="wireframe-caption">static/wireframes/table-default.png</div>
</div>

## Conventions

- **First column** is a row number (or a checkbox if multi-select).
- **Sortable headers** are marked with `↕`.
- **Money columns** right-align.
- **Status columns** use coloured pills (green = paid, amber = pending,
  red = problem).
- **Row actions** live behind a `⋮` menu in the last column. Avoid inline
  buttons unless the action is the primary intent.
- **Footer totals** for sum / count when relevant.

## Grouped / expandable rows

Used for hierarchical data (agent → orders, category → products).

<div className="wireframe">
  <img src="/wireframes/table-grouped.png" alt="Grouped rows" />
  <div className="wireframe-caption">static/wireframes/table-grouped.png</div>
</div>

## Performance

- Server-side pagination is the default.
- Page size choices: 25 / 50 / 100. Don't allow "All" on tables that
  could exceed 1k rows.
- Excel export goes through the **Export** action, not the browser table
  — never load 50k rows in the DOM.
