---
sidebar_position: 8
title: Webhooks
---

# Webhooks

SalesDoctor exposes outbound webhooks for selected events. Configure them
under **Settings → Integrations → Webhooks**.

## Delivery

- HTTP `POST` with JSON body.
- Header `X-Salesdoc-Signature: sha256=<hmac>` — HMAC-SHA256 of the body
  using the configured secret.
- Header `X-Salesdoc-Event: <event_name>`.
- Retries with exponential backoff (1m, 5m, 30m, 2h, 6h, 12h). After the
  6th failure the webhook is disabled.

## Event catalog

| Event | When |
|-------|------|
| `order.created` | New order saved |
| `order.status_changed` | `STATUS` transition |
| `order.delivered` | `STATUS = Delivered` |
| `order.cancelled` | `STATUS = Cancelled` |
| `payment.received` | Payment posted against an order |
| `payment.approved` | Payment passes approval |
| `client.created` | New client (post-approval) |
| `client.updated` | Client edited |
| `inventory.completed` | Inventory document closed |
| `audit.completed` | Audit submission saved |

## Verification

```php
$expected = 'sha256=' . hash_hmac('sha256', $rawBody, $secret);
if (!hash_equals($expected, $signatureHeader)) abort(401);
```
