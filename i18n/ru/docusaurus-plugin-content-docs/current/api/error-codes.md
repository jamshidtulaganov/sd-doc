---
sidebar_position: 7
title: Коды ошибок
---

# Коды ошибок

Стандартная обёртка ошибки:

```json
{
  "success": false,
  "code": "INSUFFICIENT_STOCK",
  "error": "Stock for product P77 is insufficient (requested 12, available 4)",
  "details": { "product_id": "P77", "available": 4, "requested": 12 }
}
```

`code` — машинно-читаемое перечисление. `error` — человекочитаемое сообщение
в локали запроса.

## Аутентификация

| Код | Значение |
|-----|----------|
| `INVALID_CREDENTIALS` | Неверный логин или пароль |
| `INVALID_TOKEN` | Токен неизвестен / истёк |
| `LICENSE_EXPIRED` | Лицензия тенанта истекла |
| `DEVICE_LIMIT` | Слишком много устройств для этого пользователя |
| `TENANT_INACTIVE` | Поддомен отключён |

## Каталог

| Код | Значение |
|-----|----------|
| `PRICE_MISMATCH` | Отправленная цена отличается от каталожной |
| `PRODUCT_INACTIVE` | Продукт деактивирован |
| `CATEGORY_NOT_FOUND` | Неверный id категории |

## Сток

| Код | Значение |
|-----|----------|
| `INSUFFICIENT_STOCK` | Доступное количество ниже запрошенного |
| `WAREHOUSE_INACTIVE` | Склад отключён |
| `RESERVATION_FAILED` | Не удалось зарезервировать сток атомарно |

## Заказ

| Код | Значение |
|-----|----------|
| `INVALID_CLIENT` | Клиент неизвестен / не на маршруте агента |
| `OVER_CREDIT_LIMIT` | Кредитный лимит будет превышен |
| `OVER_DISCOUNT_LIMIT` | Скидка выше разрешённого лимита агента |
| `INVALID_TRANSITION` | Переход статуса не разрешён |
| `DUPLICATE_ORDER` | Коллизия ключа идемпотентности |

## Интеграция

| Код | Значение |
|-----|----------|
| `EXTERNAL_TIMEOUT` | Исходящий вызов в 1C / Didox / Faktura.uz по таймауту |
| `EXTERNAL_4XX` | Внешняя система отклонила запрос |
| `EXTERNAL_5XX` | Ошибка во внешней системе |
| `MAPPING_MISSING` | Нет маппинга `XML_ID` для этой сущности |

## Общие

| Код | Значение |
|-----|----------|
| `VALIDATION_FAILED` | Тело запроса не прошло валидацию |
| `NOT_FOUND` | Сущность не существует |
| `FORBIDDEN` | У роли нет прав |
| `RATE_LIMITED` | Слишком много запросов |
| `INTERNAL_ERROR` | Необработанная ошибка на стороне сервера |

## Маппинг HTTP-статусов

- `200` — успех
- `400` — `VALIDATION_FAILED`, `INVALID_TRANSITION`
- `401` — `INVALID_CREDENTIALS`, `INVALID_TOKEN`
- `402` — `LICENSE_EXPIRED`
- `403` — `FORBIDDEN`, `OVER_CREDIT_LIMIT`, `OVER_DISCOUNT_LIMIT`
- `404` — `NOT_FOUND`, `INVALID_CLIENT`, `CATEGORY_NOT_FOUND`
- `409` — `INSUFFICIENT_STOCK`, `RESERVATION_FAILED`, `DUPLICATE_ORDER`
- `429` — `RATE_LIMITED`
- `500` — `INTERNAL_ERROR`, `EXTERNAL_5XX`
- `504` — `EXTERNAL_TIMEOUT`
