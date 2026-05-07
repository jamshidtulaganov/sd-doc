---
sidebar_position: 1
title: Architecture Decision Records
---

# Architecture Decision Records (ADRs)

Lightweight records of significant technical decisions. New ADRs follow
this template:

```md
# ADR <NNNN> — <title>

- Status: Accepted | Proposed | Deprecated | Superseded by ADR-XXXX
- Date: YYYY-MM-DD
- Deciders: @alice, @bob

## Context
What's the situation that requires a decision?

## Decision
What did we decide?

## Consequences
What follows from this decision (good and bad)?
```

## Index

| # | Title | Status |
|---|-------|--------|
| [0001](./yii1-stay.md) | Stay on Yii 1.x for now | Accepted |
| [0002](./multi-tenant-db-per-customer.md) | Multi-tenant: DB-per-customer | Accepted |
| [0003](./redis-three-databases.md) | Redis: three logical DBs | Accepted |
| [0004](./api-versioning.md) | Versioned API modules (api / api2 / api3 / api4) | Accepted |
