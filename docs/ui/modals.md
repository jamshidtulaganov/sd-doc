---
sidebar_position: 6
title: Modals
---

# Modals

## Confirmation modal

Use for destructive actions and any action with side effects on multiple
records.

```
┌──── Cancel order #O-2026-0123 ─────────────────┐
│                                                 │
│  This will release reserved stock and mark      │
│  the order as cancelled. This cannot be undone. │
│                                                 │
│                       [Cancel]  [Confirm]       │
└─────────────────────────────────────────────────┘
```

<div className="wireframe">
  <img src="/wireframes/modal-confirm.png" alt="Confirm modal" />
  <div className="wireframe-caption">static/wireframes/modal-confirm.png</div>
</div>

## Edit-in-modal

For quick edits on entities you don't want to navigate away to. Avoid for
forms with > 8 fields — open a full page instead.

<div className="wireframe">
  <img src="/wireframes/modal-edit.png" alt="Edit modal" />
  <div className="wireframe-caption">static/wireframes/modal-edit.png</div>
</div>

## Conventions

- **Title**: action verb + entity name ("Cancel order #…").
- **Body**: ≤ 80 words. Be specific about the consequence.
- **Primary action** on the right. **Cancel/secondary** on the left.
- **Destructive primary** is red.
- **Esc closes**, Enter triggers primary unless inside a textarea.
- **Don't stack modals**.
