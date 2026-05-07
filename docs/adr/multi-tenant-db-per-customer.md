---
sidebar_position: 3
title: ADR-0002 — DB per customer
---

# ADR 0002 — Multi-tenant: DB-per-customer

- Status: **Accepted**
- Date: 2023-04-02
- Deciders: Platform team

## Context

Tenants vary widely in size (50 to 50,000 orders / day). Some require
data residency. Backups need to be tenant-isolated. We must support
"give me my data" requests in a finite number of clicks.

Options considered:

1. Schema-per-tenant in one MySQL DB.
2. **DB-per-customer.**
3. Single shared schema with `tenant_id` columns.
4. Per-tenant Mongo collection (rejected — no document store on the team).

## Decision

**DB-per-customer.** One MySQL database per tenant; subdomain selects the
DB at request time.

## Consequences

- ✅ Per-tenant backup/restore is trivial.
- ✅ Cross-tenant data leaks are structurally impossible at the DB layer.
- ✅ Per-tenant tuning (indexes, partitioning).
- ❌ Migrations must fan-out across all tenant DBs.
- ❌ Cross-tenant aggregate reporting needs a separate analytics pipe.
- ❌ Connection-pool churn at the app tier — addressed via persistent
  connections.
