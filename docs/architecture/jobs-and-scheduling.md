---
sidebar_position: 5
title: Background jobs & scheduling
---

# Background jobs & scheduling

## Queue components

Verified against `main_static.php:93-107` and
`protected/components/jobs/README.md`:

```
queueRedis  →  RedisConnection { hostname:10.0.0.11, port:6379, database:1, timeout:5 }
queue       →  Queue           { connectionId:'queueRedis', defaultQueue:'default' }
BaseJob     →  abstract base class for all jobs (protected/components/BaseJob.php)
```

Redis data structures (db1):

```
queue:{name}                    — LIST  — immediate jobs (LPUSH/BRPOP)
queue:{name}:delayed            — ZSET  — delayed jobs (score = execute_at)
queue:{name}:reserved           — ZSET  — in-flight jobs (score = timeout_at)
queue:{name}:reserved:{jobId}   — STRING — reserved payload (SETEX, auto-expire)
queue:{name}:failed             — LIST  — failed jobs
```

Job classes live under `protected/components/jobs/`. Confirmed present:

| Class | Purpose |
|-------|---------|
| `ExampleJob` | Reference/template |
| `SendNotificationJob` | Push / SMS dispatch |
| `CheckOrderCisesJob` | Markirovka GTIN check on order |
| `ValidateInvoiceCisesJob` | Markirovka GTIN validation on invoice |

`protected/components/jobs/` autoloads via the
`application.components.jobs.*` import in `main_static.php:13`.

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

The actual command (per `QueueCommand::actionWork()` and
`protected/components/jobs/README.md`):

```bash
# Default queue, one worker
php console.php queue work --queue=default --memory=128 --timeout=1 --sleep=3

# Dedicated queue for emails
php console.php queue work --queue=emails --memory=256
```

Worker parameters (`QueueCommand` public properties):

| Param | Default | Notes |
|-------|---------|-------|
| `--queue` | `default` | Queue name |
| `--memory` | `128` MB | Hard memory cap; worker exits with status 12 (auto-restart) once exceeded |
| `--timeout` | `1` s | `BRPOP` blocking timeout |
| `--sleep` | `3` s | Delayed / timed-out job polling interval |
| `--limit` | `20` | Rows shown by `queue failed` |
| `--force` | `false` | Skip the confirmation prompt on `queue flush` |

Signal handling (`QueueCommand::handleSignal`):

- `SIGTERM` / `SIGINT` → graceful shutdown (finish current job, then exit)
- `SIGUSR2` → toggle pause/resume

Recommended Supervisor stanza (from `jobs/README.md`):

```ini
[program:queue-worker]
command=php /path/to/console.php queue work --queue=default --memory=128
numprocs=2
autostart=true
autorestart=true
stopwaitsecs=30
stopsignal=SIGTERM
```

Run workers under a process supervisor (`supervisor`, `systemd`, or k8s
Deployment). One worker pool per queue.

## Maintenance commands

`QueueCommand` exposes:

| Action | Effect |
|--------|--------|
| `queue size --queue=<q>` | Pending count |
| `queue failed --queue=<q> --limit=N` | Tabulates failed jobs (time, class, exception head, id) |
| `queue retry --queue=<q> --id=<jobId>` | Re-enqueues from `failed` list |
| `queue forget --queue=<q> --id=<jobId>` | Drops a single failed entry |
| `queue clearFailed --queue=<q>` | Empties the failed list |
| `queue flush --queue=<q> [--force]` | Removes all pending/delayed/reserved/failed; prompts unless `--force` |

## Cron / scheduled jobs

The console entrypoint is `console.php` at the repo root, **not** the
`yiic` shim. Console commands live in `protected/commands/` —
confirmed at audit time:

| Command file | Class | Purpose |
|--------------|-------|---------|
| `QueueCommand.php` | `QueueCommand` | Queue worker daemon (see above) + maintenance CLI |
| `InternalCommand.php` | `InternalCommand` | Child-process executor for remote-tenant jobs; receives `--payload=<base64>` from `QueueCommand::processJob()` |
| `OrderCommand.php` | `OrderCommand` | One-shot data fix: rebuild `d0_orderdetail` rows from `d0_orderdetailhistory`. Subcommands: `actionRestore`, `actionRestore2`. Operator runs by hand after a corruption event |
| `LotCommand.php` | `LotCommand` | Full FIFO recomputation of `d0_lot` and `d0_lotdistribution` from purchases / orders / exchanges / adjustments. Subcommands: `actionRun`, `actionRun2` |

**There is no committed `cron/` namespace and no recurring scheduled-job
config in the repo.** Past references to `yiic cron/syncOrders` or
`yiic cron/dailyKpi` were aspirational — those commands don't exist. The
scheduling that does happen is via:

1. The queue itself — `BaseJob::dispatchLater($seconds, $data)` and
   `BaseJob::dispatchAt($timestamp, $data)`. Backed by the
   `queue:{name}:delayed` ZSET (`Queue.php`).
2. Host-level `crontab` on the ops side that shells out to
   `php console.php queue work` (worker daemons) and per-tenant data
   maintenance scripts (`OrderCommand`, `LotCommand`). Those cron lines
   are **not in the repo** — they live in deploy configuration.

When a per-tenant data fix runs from CLI, set the filial first
(seen in `OrderCommand::actionRestore`, `LotCommand::setFilial`):

```php
if ($args[0] === 'filial' && !empty($args[1])) {
    BaseFilial::setFilial($args[1]);
}
```

Cross-tenant fan-out is not supplied by a `TenantRegistry::all()` helper
in this repo; the operator iterates `SHOW DATABASES LIKE 'sd\\_%'`
externally (see [deployment](../devops/deployment.md#multi-tenant-fan-out)).

## Idempotency

Make every job idempotent. Network blips will cause duplicate dispatches.
Patterns:

- Check status before mutation: `if ($order->STATUS !== self::STATUS_NEW) return;`
- Use a Redis SETNX lock keyed by the unit-of-work.
- Use a database unique constraint on `(entity_id, action_type)`.
