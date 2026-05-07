---
sidebar_position: 5
title: Backup & restore
---

:::warning Stub
This page is a placeholder. The content is incomplete — verify against source before relying on it. See [the audit's stub-backfill list](#) for status.
:::

# Backup & restore

## What to back up

| Asset | Where | RPO target |
|-------|-------|-----------|
| MySQL (per-tenant DBs) | dbserver:/var/lib/mysql | 1 h |
| File uploads | app:/var/www/html/upload | 24 h |
| Redis | not backed up (ephemeral) — sessions / queue / cache will recreate | – |
| Configs | git | n/a |

## MySQL daily

```bash
# Full dump per tenant
for db in $(mysql -Nsre 'SHOW DATABASES LIKE "sd\\_%"'); do
  mysqldump --single-transaction --quick --triggers --routines $db \
    | gzip > /backups/$(date +%F)/$db.sql.gz
done

# Encrypt (age) and upload to off-site
for f in /backups/$(date +%F)/*.sql.gz; do
  age -r $RECIPIENT $f > $f.age
  aws s3 cp $f.age s3://sd-backups/$(date +%F)/
done
```

## Hourly binlog ship

Stream `mysql-bin.*` to an off-site target so you can replay to any
point.

## Files

```bash
rsync -a --delete /srv/sd-main/uploads/ backup-host:/srv/sd-uploads/
```

## Restore drills

Quarterly: restore a random tenant DB into a sandbox and run smoke tests.
Document the run in a postmortem template.
