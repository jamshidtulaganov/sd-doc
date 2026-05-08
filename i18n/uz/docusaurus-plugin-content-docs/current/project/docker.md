---
sidebar_position: 4
title: Docker
---

# Docker

## Compose tartibi

`docker-compose.yml` to'rtta xizmatni belgilaydi:

| Xizmat | Image | Maqsadi |
|---------|-------|---------|
| `web` | `Dockerfile` dan qurilgan | Nginx + php-fpm 7.3 |
| `db` | `mysql:8.0` | Maxsus `mysql.cnf` bilan MySQL |
| `redis` | `redis:7-alpine` | Sessiyalar + navbat + kesh |
| `phpmyadmin` | `phpmyadmin/phpmyadmin` | Brauzerdagi DB admin |

`web` repo ildizini `/var/www/html` ga mount qiladi, shuning uchun PHP
tahrirlari bir zumda amalga oshadi.

## Dockerfile

```dockerfile
FROM php:7.3-fpm
# Installs nginx, common system libs, and PHP extensions:
#   bcmath, bz2, calendar, exif, ftp, gd, gettext, mbstring,
#   mysqli, pcntl, pdo, pdo_mysql, pdo_sqlite, shmop, sysv*,
#   tidy, xsl, zip
# Then copies nginx.conf and runs php-fpm + nginx.
```

Productionda siz odatda nginx ni o'z konteyneriga ajratasiz — soddalik uchun
shu yerda birga saqlangan.

## Konteyner ichida ishlash

```bash
# Open a shell
docker compose exec web bash

# Run a Yii CLI command
docker compose exec web php protected/yiic <command>

# Tail the app log
docker compose exec web tail -f protected/runtime/application.log
```

## Dockerfile tahriridan keyin qayta build qilish

```bash
docker compose build web
docker compose up -d web
```

## Ma'lumotlar bazasini reset qilish

```bash
docker compose down -v          # ⚠️ removes the db volume
docker compose up -d
# then re-import the dump
```
