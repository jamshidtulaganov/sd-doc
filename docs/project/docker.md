---
sidebar_position: 4
title: Docker
---

# Docker

## Compose layout

`docker-compose.yml` defines four services:

| Service | Image | Purpose |
|---------|-------|---------|
| `web` | built from `Dockerfile` | Nginx + php-fpm 7.3 |
| `db` | `mysql:8.0` | MySQL with custom `mysql.cnf` |
| `redis` | `redis:7-alpine` | Sessions + queue + cache |
| `phpmyadmin` | `phpmyadmin/phpmyadmin` | Browser DB admin |

`web` mounts the repo root at `/var/www/html` so PHP edits are immediate.

## The Dockerfile

```dockerfile
FROM php:7.3-fpm
# Installs nginx, common system libs, and PHP extensions:
#   bcmath, bz2, calendar, exif, ftp, gd, gettext, mbstring,
#   mysqli, pcntl, pdo, pdo_mysql, pdo_sqlite, shmop, sysv*,
#   tidy, xsl, zip
# Then copies nginx.conf and runs php-fpm + nginx.
```

In production you'd typically split nginx into its own container — kept
together here for simplicity.

## Working inside the container

```bash
# Open a shell
docker compose exec web bash

# Run a Yii CLI command
docker compose exec web php protected/yiic <command>

# Tail the app log
docker compose exec web tail -f protected/runtime/application.log
```

## Rebuilding after a Dockerfile edit

```bash
docker compose build web
docker compose up -d web
```

## Resetting the database

```bash
docker compose down -v          # ⚠️ removes the db volume
docker compose up -d
# then re-import the dump
```
