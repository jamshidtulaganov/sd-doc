---
sidebar_position: 8
title: Webhooklar
---

# Webhooklar

SalesDoctor tanlangan hodisalar uchun chiquvchi webhooklarni taqdim etadi.
Ularni **Sozlamalar → Integratsiyalar → Webhooklar** ostida sozlang.

## Yetkazib berish

- JSON tanali HTTP `POST`.
- `X-Salesdoc-Signature: sha256=<hmac>` sarlavhasi — sozlangan
  maxfiy kalit bilan tananing HMAC-SHA256 si.
- `X-Salesdoc-Event: <event_name>` sarlavhasi.
- Eksponensial backoff bilan qayta urinishlar (1m, 5m, 30m, 2h, 6h, 12h).
  6-marta muvaffaqiyatsizlikdan so'ng webhook o'chiriladi.

## Hodisalar katalogi

| Hodisa | Qachon |
|--------|--------|
| `order.created` | Yangi buyurtma saqlandi |
| `order.status_changed` | `STATUS` o'tishi |
| `order.delivered` | `STATUS = Delivered` |
| `order.cancelled` | `STATUS = Cancelled` |
| `payment.received` | Buyurtma uchun to'lov qabul qilindi |
| `payment.approved` | To'lov tasdiqdan o'tdi |
| `client.created` | Yangi mijoz (tasdiqdan keyin) |
| `client.updated` | Mijoz tahrirlandi |
| `inventory.completed` | Inventarizatsiya hujjati yopildi |
| `audit.completed` | Audit yuborilishi saqlandi |

## Tasdiqlash

```php
$expected = 'sha256=' . hash_hmac('sha256', $rawBody, $secret);
if (!hash_equals($expected, $signatureHeader)) abort(401);
```
