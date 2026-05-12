---
sidebar_position: 16
title: dashboard
---

# Модуль `dashboard`

:::info Минимальное покрытие
Это страница-заглушка — контроллеры и форма плитки перечислены, но сам каталог KPI, стратегия кэша и tile-to-role маппинг ещё не описаны. Вклад приветствуется через скилл `sd-docs-author`.
:::

KPI-дашборды для super-admin / admin / manager / supervisor. Тяжёлый по
агрегатам — кэшируйте агрессивно (типичный TTL 60 с).

## Контроллеры

`DefaultController` (главная страница), `BillingController`, `CategoryController`,
`CsController` (customer service), `AlisherController` (legacy named
dashboard).

## Плитки

Типичная плитка читает сначала из `redis_app`, при отсутствии откатывается к SQL-агрегату.
Форма данных плитки:

```php
[
  'title' => 'Today\'s orders',
  'value' => 1247,
  'delta' => '+12%',
  'spark' => [/* 14 daily values */],
]
```
