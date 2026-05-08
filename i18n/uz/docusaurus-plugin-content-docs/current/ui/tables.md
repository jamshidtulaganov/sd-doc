---
sidebar_position: 4
title: Jadvallar
---

# Jadvallar

Jadvallar — UI ning ish oti. DataTables asosida o'zimizning bir nechta konvensiyalarimiz bilan qurilgan.

## Default jadval

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

## Konvensiyalar

- **Birinchi ustun** — qator raqami (yoki multi-select bo'lsa checkbox).
- **Saralanadigan sarlavhalar** `↕` bilan belgilanadi.
- **Pul ustunlari** o'ng tomonga tekislanadi.
- **Status ustunlari** rangli pill-lardan foydalanadi (yashil = to'langan, kahrabo = kutilmoqda, qizil = muammo).
- **Qator harakatlari** oxirgi ustundagi `⋮` menyusi ortida yashaydi. Inline tugmalardan saqlaning, agar harakat asosiy niyat bo'lmasa.
- **Footer jami** — sum / count uchun, mos kelgan paytda.

## Guruhlangan / kengaytiriladigan qatorlar

Iyerarxik ma'lumotlar uchun ishlatiladi (agent → orders, kategoriya → mahsulotlar).

<div className="wireframe">
  <img src="/wireframes/table-grouped.png" alt="Grouped rows" />
  <div className="wireframe-caption">static/wireframes/table-grouped.png</div>
</div>

## Unumdorlik

- Server tomonidagi sahifalash — default.
- Sahifa hajmi tanlovlari: 25 / 50 / 100. 1k qatordan oshishi mumkin bo'lgan jadvallarda "All" ga ruxsat bermang.
- Excel eksporti **Export** harakat orqali o'tadi, brauzer jadvali orqali emas — DOM ga 50k qator yuklamang.
