---
sidebar_position: 4
title: Мониторинг и логирование
---

# Мониторинг и логирование

## Логи приложения

`CLogRouter` Yii пишет:

- `protected/runtime/application.log` — ошибки + предупреждения.
- Опционально per-category логи (cache, auth) — переключаются в
  `main_static.php`.

Нацельте log shipper (Filebeat, Vector) на `protected/runtime/*.log`.

## Access-логи

Access-лог nginx по поддомену тенанта. Типичная строка:

```
acme.salesdoc.io 10.0.0.7 - - [07/May/2026:08:00:01 +0500] "GET /orders/list HTTP/1.1" 200 18234 "-" "Mozilla/5.0"
```

Используйте `$host`, чтобы нарезать использование по тенанту.

## Метрики

Если у вас есть Prometheus:

- `node_exporter` для метрик VM.
- `mysqld_exporter` для БД.
- `redis_exporter` для Redis.
- Кастомный экспортер, скрейпящий `/metrics` из приложения (запланирован —
  ещё нет в master).

## Алерты (рекомендуемые)

| Алерт | Порог |
|-------|-----------|
| 5xx rate | > 1 % за 5 мин |
| Спайк фейлов логина | > 100 / 5 мин с одного IP |
| Глубина очереди | > 5000 задач в db1 |
| Лаг репликации MySQL | > 30 с |
| Свободное место на диске | < 10 % |

## Трейсинг

Сейчас не интегрирован. Добавьте OpenTelemetry exporter в `BaseController`,
если нужно.
