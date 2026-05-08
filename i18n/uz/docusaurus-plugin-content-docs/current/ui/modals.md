---
sidebar_position: 6
title: Modallar
---

# Modallar

## Tasdiqlash modali

Buzilishli harakatlar uchun va bir nechta yozuvlarda yon ta'sirlari bo'lgan har qanday harakat uchun foydalaning.

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

## Modal-ichida tahrirlash

Sizdan navigatsiya qilishni xohlamaydigan obyektlarda tezkor tahrirlash uchun. > 8 maydonli formalar uchun saqlaning — uning o'rniga to'liq sahifani oching.

<div className="wireframe">
  <img src="/wireframes/modal-edit.png" alt="Edit modal" />
  <div className="wireframe-caption">static/wireframes/modal-edit.png</div>
</div>

## Konvensiyalar

- **Sarlavha**: harakat fe'li + obyekt nomi ("Cancel order #…").
- **Tana**: ≤ 80 so'z. Oqibat haqida aniq bo'ling.
- **Asosiy harakat** o'ng tomonda. **Cancel/secondary** chap tomonda.
- **Buzilishli asosiy** qizil rangda.
- **Esc yopadi**, Enter asosiyni ishga tushiradi, agar textarea ichida bo'lmasa.
- **Modallarni stack qilmang**.
