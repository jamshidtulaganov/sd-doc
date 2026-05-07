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
