---
sidebar_position: 5
title: Бэкап и восстановление
---

# Бэкап и восстановление

## Что бэкапить

| Актив | Где | Целевой RPO |
|-------|-------|-----------|
| MySQL (per-tenant БД) | dbserver:/var/lib/mysql | 1 ч |
| Загруженные файлы | app:/var/www/html/upload | 24 ч |
| Redis | не бэкапится (эфемерный) — сессии / очередь / кеш пересоздадутся | – |
| Конфиги | git | n/a |

## MySQL — ежедневно

```bash
# Полный дамп на тенанта
for db in $(mysql -Nsre 'SHOW DATABASES LIKE "sd\\_%"'); do
  mysqldump --single-transaction --quick --triggers --routines $db \
    | gzip > /backups/$(date +%F)/$db.sql.gz
done

# Шифруем (age) и заливаем off-site
for f in /backups/$(date +%F)/*.sql.gz; do
  age -r $RECIPIENT $f > $f.age
  aws s3 cp $f.age s3://sd-backups/$(date +%F)/
done
```

## Почасовая отгрузка binlog

Стримьте `mysql-bin.*` в off-site target, чтобы можно было реплеить в
любую точку.

## Файлы

```bash
rsync -a --delete /srv/sd-main/uploads/ backup-host:/srv/sd-uploads/
```

## Тренировки восстановления

Ежеквартально: восстанавливайте случайную БД тенанта в sandbox и гоняйте
smoke-тесты. Документируйте прогон в шаблоне postmortem.
