---
sidebar_position: 5
title: Forms
---

# Forms

## Create / edit form

Sectioned, two-column for desktop, single-column on narrow:

```
┌─ General ──────────────────────────────────────────┐
│  Name        [______________________]              │
│  Code        [________]   Active   ☑               │
│  Category    [Dropdown ▾]                          │
└────────────────────────────────────────────────────┘

┌─ Pricing ──────────────────────────────────────────┐
│  Price type  [Dropdown ▾]                          │
│  Base price  [____.__]   Currency [UZS ▾]          │
│  Discount    [_____]                               │
└────────────────────────────────────────────────────┘

[Cancel]                            [Save]  [Save and add another]
```

<div className="wireframe">
  <img src="/wireframes/form-create.png" alt="Create form" />
  <div className="wireframe-caption">static/wireframes/form-create.png</div>
</div>

## Inline edit

For tables where rows are commonly edited (price types, categories), use
double-click to edit a cell in place.

<div className="wireframe">
  <img src="/wireframes/form-inline.png" alt="Inline edit" />
  <div className="wireframe-caption">static/wireframes/form-inline.png</div>
</div>

## Conventions

- **Required fields** marked with a red asterisk.
- **Validation**:
  - Inline (per field) for syntactic errors.
  - Banner at the top for cross-field errors.
- **Save** is the primary action (right). **Cancel** is secondary (left).
- **Sticky footer** for forms longer than the viewport.
