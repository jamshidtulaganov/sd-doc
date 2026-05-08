---
sidebar_position: 5
title: Формы
---

# Формы

## Форма создания / редактирования

Секционная, две колонки на десктопе, одна на узком экране:

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

## Inline-редактирование

Для таблиц, где строки часто редактируются (типы цен, категории),
используйте double-click для редактирования ячейки на месте.

<div className="wireframe">
  <img src="/wireframes/form-inline.png" alt="Inline edit" />
  <div className="wireframe-caption">static/wireframes/form-inline.png</div>
</div>

## Соглашения

- **Обязательные поля** помечены красной звёздочкой.
- **Валидация**:
  - Inline (по полю) для синтаксических ошибок.
  - Баннер сверху для cross-field-ошибок.
- **Save** — primary-действие (справа). **Cancel** — secondary (слева).
- **Sticky-футер** для форм, длиннее viewport'а.
