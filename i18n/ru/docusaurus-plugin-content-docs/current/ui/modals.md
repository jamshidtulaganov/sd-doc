---
sidebar_position: 6
title: Модалки
---

# Модалки

## Модалка подтверждения

Используйте для деструктивных действий и любых действий с побочными
эффектами на нескольких записях.

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

## Edit-в-модалке

Для быстрых правок сущностей, к которым не хочется уходить отдельной
страницей. Избегайте для форм с > 8 полями — открывайте полную страницу.

<div className="wireframe">
  <img src="/wireframes/modal-edit.png" alt="Edit modal" />
  <div className="wireframe-caption">static/wireframes/modal-edit.png</div>
</div>

## Соглашения

- **Заголовок**: глагол-действие + имя сущности («Cancel order #…»).
- **Тело**: ≤ 80 слов. Будьте конкретны о последствии.
- **Primary-действие** справа. **Cancel/secondary** слева.
- **Деструктивный primary** — красный.
- **Esc закрывает**, Enter триггерит primary, кроме случая внутри
  textarea.
- **Не складывайте модалки**.
