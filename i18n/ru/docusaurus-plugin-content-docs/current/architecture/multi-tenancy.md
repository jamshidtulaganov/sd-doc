---
sidebar_position: 3
title: Мультитенантность
---

# Мультитенантность

SalesDoctor использует мультитенантность **DB-per-customer** с **маршрутизацией по поддомену**.

## Резолвинг тенанта

```
https://{tenant}.salesdoc.io/orders/list
                ↑
                HTTP_HOST → TenantContext.resolveByHost()
                          → returns { db: "sd_acme", filialId: 7 }
```

Две гранулярности:

- **Тенант** — соответствует одной **MySQL-базе** (`sd_<tenant>`).
- **Filial** (филиал) — строка внутри базы тенанта. Несколько филиалов
  могут делить одну базу тенанта; данные тегируются `FILIAL_ID`.

`TenantContext` экспонирует:

```php
Yii::app()->tenantContext->db            // 'sd_acme'
Yii::app()->tenantContext->filialId      // 7
Yii::app()->tenantContext->scoped()      // ScopedCache for tenant
Yii::app()->tenantContext->scopedFilial()// ScopedCache for filial
```

## Стратегия кеширования

Redis db2 — кеш приложения. Ключи неймспейсятся, чтобы инвалидация
срабатывала на нужной гранулярности:

| Скоуп | Форма ключа | Инвалидирует |
|-------|-----------|-------------|
| Тенант | `t:{db}:filial-list` | Каждый филиал этого тенанта |
| Филиал | `t:{db}:f:{id}:authitem` | Только этот филиал |
| Пользователь | `t:{db}:f:{id}:u:{uid}:perms` | Только этого пользователя |

**Правило**: никогда не пишите напрямую в `Yii::app()->cache`. Всегда
ходите через `ScopedCache`, чтобы применился правильный префикс.

## Сессии

`CCacheHttpSession` поверх Redis db0. `keyPrefix` — это `HTTP_HOST`,
что даёт каждому поддомену полностью изолированный пул сессий.

## Добавление нового тенанта

1. Provision MySQL DB:
   ```sql
   CREATE DATABASE sd_newcustomer DEFAULT CHARSET utf8;
   ```
2. Накатите схему (загрузите свежий dump или прогоните миграции).
3. Вставьте строку тенанта в registry-таблицу.
4. Добавьте DNS поддомена + Nginx vhost (или используйте wildcard cert).
5. Smoke test: залогиньтесь, создайте один заказ, убедитесь что cache
   keys скоупированы.

## Антипаттерны

- ❌ Хардкодить `sd_main` где-либо. Всегда ходите через `tenantContext->db`.
- ❌ Делить Redis-ключи между тенантами без префикса.
- ❌ Cron-задачи, не итерирующиеся по тенантам — см.
  [Фоновые задачи и расписание](./jobs-and-scheduling.md) для правильного паттерна.
