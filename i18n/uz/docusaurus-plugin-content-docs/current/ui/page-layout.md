---
sidebar_position: 2
title: Sahifa joylashuvi
---

# Sahifa joylashuvi

Admin web ilova bo'ylab ishlatiladigan standart joylashuv:

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
  <div className="wireframe-caption">Bu stub-ni almashtirish uchun Figma eksportingizni static/wireframes/page-layout.png ga tashlang.</div>
</div>

## Qoidalar

- **Sidebar** **rolga asoslangan**. Har bir rol kuratorlik qilingan kichik to'plamni ko'radi.
- **Breadcrumbs** 2 chuqurlikdan keyin majburiy.
- **Asosiy harakat tugmasi** sahifa header-ining yuqori-o'ng tomonida.
- **Full-bleed jadvallar** sidebar-ni olib tashlaydi (`column1.php` layout-dan foydalaning).

## Mobile / tor

Web admin desktop-birinchi. Mobile foydalanuvchilari maxsus mobil ilovadan foydalanadi. Web layout 1024 px dan past o'lchamda qayta tiziladi, lekin telefonlar uchun optimallashtirilmagan.
