---
sidebar_position: 4
title: Docker
---

# Docker

## Раскладка Compose

`docker-compose.yml` определяет четыре сервиса:

| Сервис | Образ | Назначение |
|---------|-------|---------|
| `web` | собирается из `Dockerfile` | Nginx + php-fpm 7.3 |
| `db` | `mysql:8.0` | MySQL с кастомным `mysql.cnf` |
| `redis` | `redis:7-alpine` | Сессии + очередь + кеш |
| `phpmyadmin` | `phpmyadmin/phpmyadmin` | Браузерный DB-админ |

`web` монтирует корень репозитория в `/var/www/html`, поэтому правки PHP
применяются мгновенно.

## Dockerfile

```dockerfile
FROM php:7.3-fpm
# Installs nginx, common system libs, and PHP extensions:
#   bcmath, bz2, calendar, exif, ftp, gd, gettext, mbstring,
#   mysqli, pcntl, pdo, pdo_mysql, pdo_sqlite, shmop, sysv*,
#   tidy, xsl, zip
# Then copies nginx.conf and runs php-fpm + nginx.
```

В продакшене обычно отделяют nginx в свой контейнер — здесь они
объединены для простоты.

## Работа внутри контейнера

```bash
# Open a shell
docker compose exec web bash

# Run a Yii CLI command
docker compose exec web php protected/yiic <command>

# Tail the app log
docker compose exec web tail -f protected/runtime/application.log
```

## Пересборка после правки Dockerfile

```bash
docker compose build web
docker compose up -d web
```

## Сброс базы данных

```bash
docker compose down -v          # ⚠️ removes the db volume
docker compose up -d
# then re-import the dump
```
