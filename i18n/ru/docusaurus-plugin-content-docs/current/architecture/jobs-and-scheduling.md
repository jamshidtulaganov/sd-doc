---
sidebar_position: 5
title: Фоновые задачи и расписание
---

# Фоновые задачи и расписание

## Компоненты очереди

```
queueRedis  →  RedisConnection (Redis db1)
queue       →  Queue { defaultQueue: "default" }
BaseJob     →  abstract base class for all jobs (protected/components/BaseJob.php)
```

## Написание задачи

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

## Диспетчеризация задачи

```php
Yii::app()->queue->push(new StockReserveJob([
    'orderId' => $order->ORDER_ID,
]));
```

## Запуск воркеров

```bash
# In the app container:
php protected/yiic queue/work --queue=default --concurrency=4
```

Запускайте воркеры под process supervisor (`supervisor`, `systemd` или
k8s Deployment). Один пул воркеров на очередь.

## Cron / задачи по расписанию

Cron-записи живут в вашем оркестраторе (k8s `CronJob`, host `crontab` и т.д.)
и шеллатся в `yiic`:

```bash
*/5 * * * * php /var/www/html/protected/yiic cron/syncOrders
0   1 * * * php /var/www/html/protected/yiic cron/dailyKpi
```

Когда cron-задача охватывает тенантов, **итерируйте список тенантов сами**:

```php
foreach (TenantRegistry::all() as $tenant) {
    Yii::app()->tenantContext->switchTo($tenant);
    // ... do work
}
```

## Идемпотентность

Делайте каждую задачу идемпотентной. Сетевые сбои вызовут дубликаты
диспатчей. Паттерны:

- Проверка статуса перед мутацией: `if ($order->STATUS !== self::STATUS_NEW) return;`
- Redis SETNX-лок, ключом которого служит unit-of-work.
- Уникальное ограничение БД на `(entity_id, action_type)`.
