---
sidebar_position: 1
title: Integrations overview
---

# Integrations overview

| Integration | Direction | Module | Page |
|-------------|-----------|--------|------|
| 1C / Esale | bidirectional | `integration` + `sync` + `api` | [1C / Esale](./1c-esale.md) |
| Didox | outbound (EDI) | `integration` | [Didox](./didox.md) |
| Faktura.uz | bidirectional | `integration` | [Faktura.uz](./faktura-uz.md) |
| Smartup | inbound | `integration` | [Smartup](./smartup.md) |
| Telegram | bidirectional | `onlineOrder`, bot | [Telegram](./telegram.md) |
| Firebase FCM | outbound | `api` push | [FCM](./fcm.md) |
| SMS | outbound | `sms` | [SMS](./sms.md) |
| GPS providers | inbound | `gps3` | [GPS](./gps.md) |

## General principles

- Every integration writes to **`IntegrationLog`** (request, response,
  status, error). Use it as the first stop when debugging.
- All outbound calls go through a queue job — never inline in a request
  handler.
- Idempotency keys live on each external entity (`XML_ID`, `EXT_ID`).
- Time-outs default to **15 s**; retry with exponential backoff up to 1 h.
