---
sidebar_position: 2
title: 1C / Esale
---

# 1C / Esale

Большинство тенантов используют **1C: Предприятие** в качестве учётной
системы. Интеграция синхронизирует:

| Направление | Сущности |
|-------------|----------|
| 1C → SD | Каталог (продукты, категории, цены, единицы), клиенты (мастер), склады, платежи |
| SD → 1C | Заказы (заголовок + строки), дефекты, возвраты, платежи, собранные агентами |

## Эндпоинты

- `POST /api/json1c/<action>` — JSON, недавнее.
- Legacy XML: `/api/xml1c/...` — заморожено.

Операции:

```
POST /api/json1c/import?type=products
POST /api/json1c/import?type=clients
POST /api/json1c/export?type=orders
POST /api/json1c/ack?type=order&id=O-2026-0123
```

Аутентификация: общий секрет (`Authorization: SDocSecret <token>`).

## Маппинг

`XML_ID` на `Product`, `Client`, `Order` и т. д. содержит ссылку на 1C.
`integration_log` хранит каждый запрос/ответ.

## Обработка ошибок

Если 1C возвращает ошибку в середине батча:

1. Весь батч откатывается **на стороне SD**.
2. Строка `integration_log` получает `status=ERROR`.
3. Задание перезапускается с задержкой (максимум 6 повторов).
4. После 6 неудач отправляется алерт на `adminEmail`.

## См. также

- [Модуль `integration`](../modules/integration.md)
- [Модуль `sync`](../modules/sync.md)
