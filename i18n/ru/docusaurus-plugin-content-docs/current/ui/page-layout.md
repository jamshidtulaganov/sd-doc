---
sidebar_position: 2
title: Раскладка страницы
---

# Раскладка страницы

Стандартная раскладка, используемая по всему admin web-приложению:

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
  <div className="wireframe-caption">Положите экспорт из Figma в static/wireframes/page-layout.png, чтобы заменить эту заглушку.</div>
</div>

## Правила

- **Сайдбар** — **role-driven**. Каждая роль видит свой curated-набор.
- **Breadcrumbs** обязательны при глубине больше 2.
- **Primary action кнопка** — справа сверху в page header.
- **Full-bleed таблицы** убирают сайдбар (используйте layout `column1.php`).

## Mobile / узкий экран

Web-админка — desktop-first. Mobile-пользователи используют отдельное
mobile-приложение. Web-layout перестраивается ниже 1024 px, но не
оптимизирован для телефонов.
