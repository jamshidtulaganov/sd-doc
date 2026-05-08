---
sidebar_position: 1
title: Architecture Decision Records
---

# Architecture Decision Records (ADR)

Лёгкие записи значимых технических решений. Новые ADR следуют этому
шаблону:

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

## Индекс

| # | Заголовок | Статус |
|---|-------|--------|
| [0001](./yii1-stay.md) | Остаться на Yii 1.x пока | Accepted |
| [0002](./multi-tenant-db-per-customer.md) | Мультитенантность: DB-per-customer | Accepted |
| [0003](./redis-three-databases.md) | Redis: три логические БД | Accepted |
| [0004](./api-versioning.md) | Версионированные API-модули (api / api2 / api3 / api4) | Accepted |
