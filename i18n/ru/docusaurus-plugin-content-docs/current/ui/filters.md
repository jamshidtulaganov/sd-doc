---
sidebar_position: 3
title: Фильтры
---

# Фильтры

Используются два паттерна; выбирайте по сценарию:

## A. Top filter bar (по умолчанию)

Над таблицей данных. До 6 видимых filter-чипов, остальные сворачиваются
за «Больше фильтров». Используйте, когда фильтры простые (диапазон дат,
статус, дропдаун агента).

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

Используется для отчётов с 10+ фильтрами. Рейл занимает ~280 px слева
от таблицы.

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

## Соглашения

- Дефолтный диапазон дат: **последние 30 дней**.
- Apply / Reset всегда вместе внизу рейла.
- Состояние фильтра **сохраняется в URL query params**, чтобы ссылками
  можно было делиться.
- «Сохранить фильтр как пресет» разрешено только для power-user
  отчётов.
