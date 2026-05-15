---
sidebar_position: 4
title: Faktura.uz
---

# Faktura.uz

State-mandated e-invoice gateway in Uzbekistan. Sends VAT-bearing
invoices for compliance.

## Toggle

`'enableFakturaUZ' => true` in `params`.

## Flow

1. Order reaches `Loaded` (or per-tenant rule).
2. `FakturaJob` packages the invoice with VAT lines.
3. Sends to Faktura.uz; receives a registration response.
4. Tenant's accountant signs in Faktura.uz UI (EIMZO).
5. Counterparty accepts.
6. Each transition mirrored back via polling job.

## Common errors

| Error | Cause |
|-------|-------|
| Bad TIN | `Client.INN` is empty or wrong length |
| Unit mismatch | Product unit not in Faktura.uz catalog |
| Price > VAT-allowed | Tenant config issue |

## Controller endpoints in sd-main

There are two Faktura controllers in the codebase — the integration
module owns the daemon-driven sync; the orders module owns the
operator-driven "create from this order" flow.

### `integration/FakturaController` (daemon, queue-driven)

File: `protected/modules/integration/controllers/FakturaController.php`.
Live routes:

| Action | Route | RBAC |
|--------|-------|------|
| `login` | `POST /integration/faktura/login` | `noRbac` |
| `create-invoice` | `POST /integration/faktura/create-invoice` | `noRbac` |
| `check-invoice` | `POST /integration/faktura/check-invoice` | `noRbac` |
| `delete-invoice` | `POST /integration/faktura/delete-invoice` | `noRbac` |
| `sync-incoming-invoices` | `POST /integration/faktura/sync-incoming-invoices` | `noRbac` |

### `orders/FakturaUZController` (admin-driven)

File: `protected/modules/orders/controllers/FakturaUZController.php`.
Live routes:

| Action | Route | RBAC |
|--------|-------|------|
| `getMe` | `POST /orders/fakturaUZ/getMe` | `noRbac` |
| `login` | `POST /orders/fakturaUZ/login` | `noRbac` |
| `getCredentials` | `POST /orders/fakturaUZ/getCredentials` | `noRbac` |
| `prepareDocuments` | `POST /orders/fakturaUZ/prepareDocuments` | `noRbac` |
| `createDocuments` | `POST /orders/fakturaUZ/createDocuments` | `noRbac` |

The legacy `protected/components/Faktura.php.obsolete` is frozen; new
work goes through one of the controllers above.

## See also

- [`integration` module](../modules/integration.md)
- [Didox](./didox.md) — sister EDI integration with the same shape.
- [`orders` module](../modules/orders.md) — the workflow that triggers
  invoice creation.
