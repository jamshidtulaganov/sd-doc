---
sidebar_position: 3
title: Didox
---

# Didox EDI

Didox is the e-document operator used by many Uzbek B2B customers.
SalesDoctor sends e-invoices, contracts and acts to Didox; the
counterparty signs / rejects in Didox and we mirror the status.

## What we send

| Doc type | Trigger |
|----------|---------|
| e-Invoice | Order reaches `Loaded` |
| Act of completion | Order reaches `Delivered` |
| Contract | Manual from contract module |

## Auth

OAuth2 client credentials. Tokens cached in `redis_app` for 1 h.

## Tracking

Each sent document gets a Didox-side ID stored back on the order /
contract. `IntegrationLog` keeps the wire payloads.

## Failure modes

- Counterparty INN missing from `Client.INN` → `MAPPING_MISSING`.
- Didox HTTP 5xx → retried with backoff.
- Counterparty rejects in Didox → status mirrored back to SD; surfaced
  as a notification to the operator.

## Controller endpoints in sd-main

`DidoxController` lives at
`protected/modules/integration/controllers/DidoxController.php`. Live URL
shape (from `routes.json`):

| Action | Route | RBAC |
|--------|-------|------|
| `login` | `POST /integration/didox/login` | `noRbac` (uses Didox OAuth) |
| `create-invoice` | `POST /integration/didox/create-invoice` | `noRbac` |
| `check-invoice` | `POST /integration/didox/check-invoice` | `noRbac` |
| `delete-invoice` | `POST /integration/didox/delete-invoice` | `noRbac` |
| `sync-incoming-invoices` | `POST /integration/didox/sync-incoming-invoices` | `noRbac` |

The pattern is: the operator drives state from the SD admin (no public
write API); these routes are called by internal queue jobs / dispatched
actions, not by browser users. The `noRbac` tag is therefore intentional
— gating is at the queue-dispatch layer.

## See also

- [`integration` module](../modules/integration.md)
- [Faktura.uz](./faktura-uz.md) — sibling controller using the same shape.
