---
sidebar_position: 5
title: Smartup
---

# Smartup

Inbound integration with Smartup (a competing/complementary distribution
ERP). Tenants who run both systems use SalesDoctor for field force and
Smartup for HQ accounting.

## What we import

- Orders created in Smartup that need to flow to SalesDoctor for
  delivery / cashier execution.
- See `protected/modules/integration/actions/smartupx/ImportOrdersAction.php`.

## Client matching

Configurable per tenant via `client_search_attribute_salesdoc`:

| Value | Match by |
|-------|----------|
| `code` | `Client.CODE` |
| `id` | `Client.CLIENT_ID` |
| `inn` | `Client.INN` |

## Payment type mapping

`salesdoc_payment_type_code` ↔ Smartup payment type XML ID. Stored on the
imported order so round-tripping preserves it.
