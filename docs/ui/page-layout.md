---
sidebar_position: 2
title: Page layout
---

# Page layout

Standard layout used across the admin web app:

```
┌────────────────────────────────────────────────────────────┐
│  TOP BAR  logo · search · locale · notifications · user    │
├────────┬───────────────────────────────────────────────────┤
│        │                                                   │
│  SIDE  │  CONTENT AREA                                     │
│  NAV   │  ┌─ Breadcrumbs ───────────────────────────────┐  │
│        │  │ Dashboard › Orders › List                   │  │
│        │  └─────────────────────────────────────────────┘  │
│        │  ┌─ Page title + primary actions ──────────────┐  │
│        │  │ Orders                       [+ New order]  │  │
│        │  └─────────────────────────────────────────────┘  │
│        │  ┌─ Filters ───────────────────────────────────┐  │
│        │  └─────────────────────────────────────────────┘  │
│        │  ┌─ Main content (table / form / detail) ──────┐  │
│        │  └─────────────────────────────────────────────┘  │
│        │                                                   │
└────────┴───────────────────────────────────────────────────┘
```

<div className="wireframe">
  <img src="/wireframes/page-layout.png" alt="Page layout wireframe" />
  <div className="wireframe-caption">Drop your Figma export at static/wireframes/page-layout.png to replace this stub.</div>
</div>

## Rules

- **Sidebar** is **role-driven**. Each role sees a curated subset.
- **Breadcrumbs** are mandatory beyond depth 2.
- **Primary action button** is top-right of the page header.
- **Full-bleed tables** drop the sidebar (use the `column1.php` layout).

## Mobile / narrow

The web admin is desktop-first. Mobile users use the dedicated mobile
app. The web layout reflows below 1024 px but isn't optimised for phones.
