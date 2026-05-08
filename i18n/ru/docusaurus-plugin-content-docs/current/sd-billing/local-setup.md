---
sidebar_position: 8
title: Локальная установка
---

# Локальная установка sd-billing

```bash
git clone <repo> sd-billing
cd sd-billing

docker compose up -d                  # mysql on :3308, web on :3000

# Initial schema
docker compose exec web php protected/yiic.php migrate

# Optional: load demo data (small / medium / large)
# See doc/MOCK_SEED.md if it exists
# docker compose exec web php docker/seed_mock_data.php

# Tail logs
docker compose logs -f web

# Run a cron job ad-hoc
docker compose exec web php cron.php notify
```

## Заметка о монтировании

Репозиторий bind-монтируется в контейнер `web` по пути `/var/www`. Правки
с хоста сразу видны в PHP.

## Подключение к БД

Читается из `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_DATABASE`, `MYSQL_USER`,
`MYSQL_PASSWORD` (`protected/config/db.php`). Дефолты
docker-friendly (`mysql:3306`).

И `protected/config/db.php`, и `_db.php` в gitignore. Если
нужен локальный override, скопируйте `_db.php` → `db.php`.

## Composer

`composer.lock` существует **без** `composer.json` — состояние зависимостей
не воспроизводимо. Phase 0 в `doc/TESTING_PLAN.md` восстанавливает
`composer.json`, чтобы можно было ставить тестовую инфраструктуру.

До этого vendor закреплён через закоммиченную папку `vendors/`.

## Миграции

```bash
cd protected && ./yiic migrate create <name>
./yiic migrate                                  # apply
./yiic migrate down                             # roll back the last
```

Таблица учёта: `tbl_migration`. Имена файлов:
`mYYMMDD_HHMMSS_<snake>.php`. Всегда реализуйте `safeUp` / `safeDown` —
они выполняются в транзакции, поэтому можно безопасно перезапускать.

## Тестовый логин

Дефолтные seed-учётки (немедленно ротируйте для нетестовых окружений):

| Роль | Логин | Пароль |
|------|-------|----------|
| Super-admin | `admin` | `admin` |
| Manager | `manager` | `123456` |

(Если ваш дамп отличается, спросите у команды правильные учётки.)
