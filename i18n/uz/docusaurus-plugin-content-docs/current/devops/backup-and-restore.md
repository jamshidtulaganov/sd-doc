---
sidebar_position: 5
title: Backup va tiklash
---

# Backup va tiklash

## Nimani backup qilish kerak

| Aktiv | Qayerda | RPO maqsadi |
|-------|---------|-------------|
| MySQL (tenant bo'yicha DB lar) | dbserver:/var/lib/mysql | 1 soat |
| Fayl yuklamalari | app:/var/www/html/upload | 24 soat |
| Redis | backup qilinmaydi (efemer) — sessiyalar / navbat / kesh qayta yaratiladi | – |
| Konfiglar | git | n/a |

## MySQL kunlik

```bash
# Tenant bo'yicha to'liq dump
for db in $(mysql -Nsre 'SHOW DATABASES LIKE "sd\\_%"'); do
  mysqldump --single-transaction --quick --triggers --routines $db \
    | gzip > /backups/$(date +%F)/$db.sql.gz
done

# Shifrlash (age) va off-site ga yuklash
for f in /backups/$(date +%F)/*.sql.gz; do
  age -r $RECIPIENT $f > $f.age
  aws s3 cp $f.age s3://sd-backups/$(date +%F)/
done
```

## Soatlik binlog jo'natish

`mysql-bin.*` ni off-site target ga oqim qiling, shunda istalgan nuqtaga
qayta o'ynashingiz mumkin.

## Fayllar

```bash
rsync -a --delete /srv/sd-main/uploads/ backup-host:/srv/sd-uploads/
```

## Tiklash mashqlari

Choraklik: tasodifiy tenant DB ni sandbox ga tiklang va smoke testlarni
ishga tushiring. Postmortem shablonida o'tkazilganni hujjatlashtiring.
