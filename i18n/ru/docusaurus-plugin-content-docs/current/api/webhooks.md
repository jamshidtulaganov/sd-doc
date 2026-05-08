---
sidebar_position: 8
title: Вебхуки
---

# Вебхуки

SalesDoctor предоставляет исходящие вебхуки для выбранных событий.
Настройте их в **Settings → Integrations → Webhooks**.

## Доставка

- HTTP `POST` с JSON-телом.
- Заголовок `X-Salesdoc-Signature: sha256=<hmac>` — HMAC-SHA256 от тела
  с настроенным секретом.
- Заголовок `X-Salesdoc-Event: <event_name>`.
- Повторы с экспоненциальной задержкой (1m, 5m, 30m, 2h, 6h, 12h). После
  6-й неудачи вебхук отключается.

## Каталог событий

| Событие | Когда |
|---------|-------|
| `order.created` | Сохранён новый заказ |
| `order.status_changed` | Переход `STATUS` |
| `order.delivered` | `STATUS = Delivered` |
| `order.cancelled` | `STATUS = Cancelled` |
| `payment.received` | Платёж проведён по заказу |
| `payment.approved` | Платёж прошёл утверждение |
| `client.created` | Новый клиент (post-approval) |
| `client.updated` | Клиент отредактирован |
| `inventory.completed` | Документ инвентаризации закрыт |
| `audit.completed` | Сохранена форма аудита |

## Верификация

```php
$expected = 'sha256=' . hash_hmac('sha256', $rawBody, $secret);
if (!hash_equals($expected, $signatureHeader)) abort(401);
```
