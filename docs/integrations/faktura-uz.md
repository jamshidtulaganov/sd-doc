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
