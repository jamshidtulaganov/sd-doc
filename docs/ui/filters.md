---
sidebar_position: 3
title: Filters
---

# Filters

Two patterns are used; pick by use case:

## A. Top filter bar (default)

Above the data table. Up to 6 visible filter chips, the rest collapse
behind "More filters". Use when filters are simple (date range, status,
agent dropdown).

```
┌─────────────────────────────────────────────────────────────┐
│  [ Date range ▾ ] [ Status ▾ ] [ Agent ▾ ] [ Client ▾ ]  ⤓  │
├─────────────────────────────────────────────────────────────┤
│  Table…                                                      │
└─────────────────────────────────────────────────────────────┘
```

<div className="wireframe">
  <img src="/wireframes/filters-top.png" alt="Top filters" />
  <div className="wireframe-caption">static/wireframes/filters-top.png</div>
</div>

## B. Side filter rail

Used for reports with 10+ filters. The rail occupies ~280 px on the left
of the table.

```
┌──────────────┬───────────────────────────────────────────────┐
│  ▣ Date      │  Table…                                        │
│    From [_]  │                                                │
│    To   [_]  │                                                │
│              │                                                │
│  ▣ Status    │                                                │
│    □ New     │                                                │
│    □ Loaded  │                                                │
│    ☑ Paid    │                                                │
│              │                                                │
│  ▣ Agent     │                                                │
│    [Search ] │                                                │
│              │                                                │
│  [Apply]     │                                                │
│  [Reset]     │                                                │
└──────────────┴───────────────────────────────────────────────┘
```

<div className="wireframe">
  <img src="/wireframes/filters-side.png" alt="Side filter rail" />
  <div className="wireframe-caption">static/wireframes/filters-side.png</div>
</div>

## Conventions

- Date range default: **last 30 days**.
- Apply / Reset always together at the bottom of the rail.
- Filter state is **persisted in URL query params** so links can be
  shared.
- "Save filter as preset" is allowed for power-user reports only.
