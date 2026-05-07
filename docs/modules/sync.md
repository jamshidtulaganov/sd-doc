---
sidebar_position: 19
title: sync
---

# `sync` module

Bi-directional data synchronisation, primarily between SalesDoctor and the
tenant's accounting system (typically 1C). Mostly job-driven.

## Direction

| Type | Where to read |
|------|---------------|
| Outbound (SalesDoctor → 1C) | Order export jobs in `integration` |
| Inbound (1C → SalesDoctor) | Catalog/price/client sync jobs in `sync` |

## Logging

Every sync run logs to `IntegrationLog` with status, payload, and any
error. The `integration` UI reads from this table.
