---
sidebar_position: 4
title: Monitoring va logging
---

# Monitoring va logging

## App loglar

Yii ning `CLogRouter` yozadi:

- `protected/runtime/application.log` — xatolar + ogohlantirishlar.
- Ixtiyoriy ravishda kategoriya bo'yicha loglar (cache, auth) —
  `main_static.php` da yoqiladi.

Log shipperni (Filebeat, Vector) `protected/runtime/*.log` ga
yo'naltiring.

## Access loglar

Tenant subdomeni bo'yicha Nginx access log. Tipik qator:

```
acme.salesdoc.io 10.0.0.7 - - [07/May/2026:08:00:01 +0500] "GET /orders/list HTTP/1.1" 200 18234 "-" "Mozilla/5.0"
```

Tenant bo'yicha foydalanishni ajratish uchun `$host` dan foydalaning.

## Metrikalar

Agar Prometheus bo'lsa:

- VM metrikalari uchun `node_exporter`.
- DB uchun `mysqld_exporter`.
- Redis uchun `redis_exporter`.
- Ilovadan `/metrics` ni scrape qiluvchi maxsus exporter (rejalashtirilgan —
  hozircha master da yo'q).

## Alertlar (tavsiya etilgan)

| Alert | Chegara |
|-------|---------|
| 5xx darajasi | 5 daqiqada > 1 % |
| Login muvaffaqiyatsizligi to'lqini | bir IP uchun 5 daqiqada > 100 |
| Navbat chuqurligi | db1 da > 5000 ish |
| Mysql replikatsiya kechikishi | > 30 s |
| Disk maydoni | < 10 % bo'sh |

## Tracing

Hozirda integratsiya qilinmagan. Kerak bo'lsa OpenTelemetry exporter
ni `BaseController` ga qo'shing.
