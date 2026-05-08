---
sidebar_position: 3
title: Локальная установка
---

# Локальная установка

## Предусловия

- Docker Desktop (или Docker Engine + Compose)
- ~4 ГБ свободной RAM
- Git
- Локальная hosts-запись для dev-поддомена, на котором будете тестировать

## Поднимаем

```bash
git clone git@github.com:salesdoctor/sd-main.git
cd sd-main

# 1. Copy the sample local config (gitignored)
cp protected/config/main_sample.php protected/config/main_local.php

# 2. Build & start
docker compose up -d --build

# 3. Tail the logs
docker compose logs -f web
```

Стек откроет:

| Сервис | URL |
|---------|-----|
| Web app | http://localhost:8080 |
| phpMyAdmin | http://localhost:8081 (root / root) |
| MySQL | `127.0.0.1:3306` (`jamshid` / `secret`) |
| Redis | `127.0.0.1:6379` |

## Сидинг базы данных

Полностью автоматизированного seed-скрипта сегодня нет. Воркфлоу:

```bash
# Pull a sanitised dump from the team file share, then:
docker compose exec db mysql -uroot -proot sd_main < dump.sql
```

Если у вас нет dump-а, спросите у коллеги или используйте read-only зеркало
staging-окружения.

## Тестовый логин

Дефолтные учётки в свежем seed:

| Роль | Логин | Пароль |
|------|-------|----------|
| Super Admin | `admin` | `admin` |
| Agent | `agent1` | `123456` |

Меняйте их немедленно для любого не-throwaway окружения.

## Hot reload?

Yii не компилируется, поэтому правка PHP-файлов обновляется на следующем
запросе. Изменения JS/CSS подхватываются обновлением браузера. **Нет**
hot module replacement — это server-rendered приложение.

## Частые подводные камни

- **Права на `runtime/` и `assets/`** — убедитесь, что `www-data` может
  писать. Dockerfile делает chown, но host bind mount может это перекрыть.
- **PHP-warning-и заполняют логи** — много файлов написаны в эпоху PHP 7.3
  и эмитят deprecation-ы под PHP 8. Оставайтесь на 7.3, если не уверены,
  что делаете.
- **`assets/` забивает диск** — периодически `rm -rf assets/<hash>`,
  чтобы очистить устаревшие опубликованные бандлы.
