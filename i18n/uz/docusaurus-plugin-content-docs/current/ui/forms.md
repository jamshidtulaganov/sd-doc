---
sidebar_position: 5
title: Formalar
---

# Formalar

## Yaratish / tahrirlash formasi

Bo'limlangan, desktop uchun ikki ustunli, tor uchun bir ustunli:

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

## Inline tahrirlash

Qatorlar tez-tez tahrirlanadigan jadvallar uchun (narx turlari, kategoriyalar), katakni joyida tahrirlash uchun ikki marta bosishni ishlating.

<div className="wireframe">
  <img src="/wireframes/form-inline.png" alt="Inline edit" />
  <div className="wireframe-caption">static/wireframes/form-inline.png</div>
</div>

## Konvensiyalar

- **Majburiy maydonlar** qizil yulduzcha bilan belgilanadi.
- **Validatsiya**:
  - Sintaksis xatolari uchun inline (har maydonga).
  - Cross-field xatolari uchun yuqorida banner.
- **Save** asosiy harakat (o'ng). **Cancel** — ikkilamchi (chap).
- **Sticky footer** viewport-dan uzunroq formalar uchun.
