---
sidebar_position: 16
title: dashboard
---

# `dashboard` module

KPI dashboards for super-admin / admin / manager / supervisor. Heavy on
aggregates — cache aggressively (60s TTL is typical).

## Controllers

`DefaultController` (landing), `BillingController`, `CategoryController`,
`CsController` (customer service), `AlisherController` (legacy named
dashboard).

## Tiles

A typical tile reads from `redis_app` first, falls back to a SQL aggregate.
Tile data shape:

```php
[
  'title' => 'Today\'s orders',
  'value' => 1247,
  'delta' => '+12%',
  'spark' => [/* 14 daily values */],
]
```
