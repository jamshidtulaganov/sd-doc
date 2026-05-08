---
sidebar_position: 3
title: Filtrlar
---

# Filtrlar

Ikki pattern ishlatiladi; foydalanish holatiga qarab tanlang:

## A. Yuqori filter paneli (default)

Ma'lumot jadvali tepasida. 6 ta ko'rinadigan filter chip-gacha, qolganlari "More filters" ortida yashirinadi. Filtrlar oddiy bo'lganda foydalaning (sana oralig'i, status, agent dropdown).

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

## B. Yon filter rail-i

10+ filtri bor hisobotlar uchun ishlatiladi. Rail jadvalning chap tomonida ~280 px ni egallaydi.

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

## Konvensiyalar

- Sana oralig'i default-i: **oxirgi 30 kun**.
- Apply / Reset har doim rail pastida birga.
- Filter holati havolalar bilan baham ko'rilishi mumkin bo'lishi uchun **URL query params da saqlanadi**.
- "Filterni preset sifatida saqlash" faqat power-user hisobotlari uchun ruxsat etiladi.
