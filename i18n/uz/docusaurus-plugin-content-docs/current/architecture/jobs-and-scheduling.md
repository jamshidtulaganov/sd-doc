---
sidebar_position: 5
title: Background ishlari va rejalashtirish
---

# Background ishlari va rejalashtirish

## Navbat komponentlari

```
queueRedis  →  RedisConnection (Redis db1)
queue       →  Queue { defaultQueue: "default" }
BaseJob     →  abstract base class for all jobs (protected/components/BaseJob.php)
```

## Ish yozish

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

## Ishni dispatch qilish

```php
Yii::app()->queue->push(new StockReserveJob([
    'orderId' => $order->ORDER_ID,
]));
```

## Ishchilarni ishga tushirish

```bash
# In the app container:
php protected/yiic queue/work --queue=default --concurrency=4
```

Ishchilarni jarayon supervisor (`supervisor`, `systemd` yoki k8s
Deployment) ostida ishga tushiring. Har bir navbat uchun bitta ishchi puli.

## Cron / rejalashtirilgan ishlar

Cron yozuvlari sizning orkestratoringizda (k8s `CronJob`, host `crontab` va
h.k.) yashaydi va `yiic` ga shell out qiladi:

```bash
*/5 * * * * php /var/www/html/protected/yiic cron/syncOrders
0   1 * * * php /var/www/html/protected/yiic cron/dailyKpi
```

Cron ishi tenantlar bo'ylab tarqalganda **tenant ro'yxatini o'zingiz
iteratsiya qiling**:

```php
foreach (TenantRegistry::all() as $tenant) {
    Yii::app()->tenantContext->switchTo($tenant);
    // ... do work
}
```

## Idempotentlik

Har bir ishni idempotent qiling. Tarmoqdagi uzilishlar takroriy
dispatch larga sabab bo'ladi. Patternlar:

- O'zgartirishdan oldin statusni tekshirish:
  `if ($order->STATUS !== self::STATUS_NEW) return;`
- Ish birligi bo'yicha kalitlangan Redis SETNX lock dan foydalaning.
- `(entity_id, action_type)` da ma'lumotlar bazasi unique constraint dan
  foydalaning.
