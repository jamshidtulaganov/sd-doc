---
sidebar_position: 4
title: Monitoring & logging
---

:::warning Stub
This page is a placeholder. The content is incomplete — verify against source before relying on it. See [the audit's stub-backfill list](#) for status.
:::

# Monitoring & logging

## App logs

Yii's `CLogRouter` writes:

- `protected/runtime/application.log` — errors + warnings.
- Optionally per-category logs (cache, auth) — toggled in
  `main_static.php`.

Point a log shipper (Filebeat, Vector) at `protected/runtime/*.log`.

## Access logs

Nginx access log per tenant subdomain. A typical line:

```
acme.salesdoc.io 10.0.0.7 - - [07/May/2026:08:00:01 +0500] "GET /orders/list HTTP/1.1" 200 18234 "-" "Mozilla/5.0"
```

Use `$host` to slice usage by tenant.

## Metrics

If you have Prometheus:

- `node_exporter` for VM metrics.
- `mysqld_exporter` for DB.
- `redis_exporter` for Redis.
- Custom exporter scraping `/metrics` from the app (planned — not in
  master yet).

## Alerts (recommended)

| Alert | Threshold |
|-------|-----------|
| 5xx rate | > 1 % over 5 min |
| Login failure spike | > 100 / 5 min for one IP |
| Queue depth | > 5000 jobs in db1 |
| Mysql replication lag | > 30 s |
| Disk space | < 10 % free |

## Tracing

Not currently integrated. Add OpenTelemetry exporter to `BaseController`
if you need it.
