---
sidebar_position: 7
title: Error codes
---

# Error codes

Standard error envelope:

```json
{
  "success": false,
  "code": "INSUFFICIENT_STOCK",
  "error": "Stock for product P77 is insufficient (requested 12, available 4)",
  "details": { "product_id": "P77", "available": 4, "requested": 12 }
}
```

`code` is the machine-readable enum. `error` is the human message in the
request locale.

## Auth

| Code | Meaning |
|------|---------|
| `INVALID_CREDENTIALS` | Login or password wrong |
| `INVALID_TOKEN` | Token unknown / expired |
| `LICENSE_EXPIRED` | Tenant licence has expired |
| `DEVICE_LIMIT` | Too many devices for this user |
| `TENANT_INACTIVE` | Subdomain is disabled |

## Catalog

| Code | Meaning |
|------|---------|
| `PRICE_MISMATCH` | Posted price differs from catalog |
| `PRODUCT_INACTIVE` | Product is deactivated |
| `CATEGORY_NOT_FOUND` | Bad category id |

## Stock

| Code | Meaning |
|------|---------|
| `INSUFFICIENT_STOCK` | Available count below requested |
| `WAREHOUSE_INACTIVE` | Warehouse disabled |
| `RESERVATION_FAILED` | Could not reserve stock atomically |

## Order

| Code | Meaning |
|------|---------|
| `INVALID_CLIENT` | Client unknown / not on agent's route |
| `OVER_CREDIT_LIMIT` | Credit limit would be exceeded |
| `OVER_DISCOUNT_LIMIT` | Discount above agent's allowed cap |
| `INVALID_TRANSITION` | Status transition not allowed |
| `DUPLICATE_ORDER` | Idempotency key collision |

## Integration

| Code | Meaning |
|------|---------|
| `EXTERNAL_TIMEOUT` | Outbound call to 1C / Didox / Faktura.uz timed out |
| `EXTERNAL_4XX` | External system rejected the request |
| `EXTERNAL_5XX` | External system errored |
| `MAPPING_MISSING` | No `XML_ID` mapping for this entity |

## Generic

| Code | Meaning |
|------|---------|
| `VALIDATION_FAILED` | Request payload failed validation |
| `NOT_FOUND` | Entity does not exist |
| `FORBIDDEN` | Role lacks permission |
| `RATE_LIMITED` | Too many requests |
| `INTERNAL_ERROR` | Unhandled server-side error |

## HTTP status mapping

- `200` — success
- `400` — `VALIDATION_FAILED`, `INVALID_TRANSITION`
- `401` — `INVALID_CREDENTIALS`, `INVALID_TOKEN`
- `402` — `LICENSE_EXPIRED`
- `403` — `FORBIDDEN`, `OVER_CREDIT_LIMIT`, `OVER_DISCOUNT_LIMIT`
- `404` — `NOT_FOUND`, `INVALID_CLIENT`, `CATEGORY_NOT_FOUND`
- `409` — `INSUFFICIENT_STOCK`, `RESERVATION_FAILED`, `DUPLICATE_ORDER`
- `429` — `RATE_LIMITED`
- `500` — `INTERNAL_ERROR`, `EXTERNAL_5XX`
- `504` — `EXTERNAL_TIMEOUT`
