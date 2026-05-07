---
sidebar_position: 5
title: Background jobs & scheduling
---

# Background jobs & scheduling

## Queue components

```
queueRedis  →  RedisConnection (Redis db1)
queue       →  Queue { defaultQueue: "default" }
BaseJob     →  abstract base class for all jobs (protected/components/BaseJob.php)
```

## Writing a job

```php
class StockReserveJob extends BaseJob
{
    public $orderId;

    public function run()
    {
        $order = Order::model()->findByPk($this->orderId);
        if (!$order) return;

        Stock::reserveForOrder($order);
        $order->STATUS = Order::STATUS_RESERVED;
        $order->save(false);
    }
}
```

## Dispatching a job

```php
Yii::app()->queue->push(new StockReserveJob([
    'orderId' => $order->ORDER_ID,
]));
```

## Running workers

```bash
# In the app container:
php protected/yiic queue/work --queue=default --concurrency=4
```

Run workers under a process supervisor (`supervisor`, `systemd`, or k8s
Deployment). One worker pool per queue.

## Cron / scheduled jobs

Cron entries live in your orchestrator (k8s `CronJob`, host `crontab`, etc.)
and shell out to `yiic`:

```bash
*/5 * * * * php /var/www/html/protected/yiic cron/syncOrders
0   1 * * * php /var/www/html/protected/yiic cron/dailyKpi
```

When a cron job spans tenants, **iterate the tenant list yourself**:

```php
foreach (TenantRegistry::all() as $tenant) {
    Yii::app()->tenantContext->switchTo($tenant);
    // ... do work
}
```

## Idempotency

Make every job idempotent. Network blips will cause duplicate dispatches.
Patterns:

- Check status before mutation: `if ($order->STATUS !== self::STATUS_NEW) return;`
- Use a Redis SETNX lock keyed by the unit-of-work.
- Use a database unique constraint on `(entity_id, action_type)`.
