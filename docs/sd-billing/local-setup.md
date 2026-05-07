---
sidebar_position: 8
title: Local setup
---

# sd-billing local setup

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

## Mount note

The repo is bind-mounted into the `web` container at `/var/www`. Host
edits are immediately live in PHP.

## DB connection

Read from `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_DATABASE`, `MYSQL_USER`,
`MYSQL_PASSWORD` (`protected/config/db.php`). Defaults are
docker-friendly (`mysql:3306`).

Both `protected/config/db.php` and `_db.php` are gitignored. If you
need a local override, copy `_db.php` → `db.php`.

## Composer

`composer.lock` exists **without** `composer.json` — dependency state
isn't reproducible. Phase 0 of `doc/TESTING_PLAN.md` reconstructs the
`composer.json` so test infrastructure is installable.

Until then, vendor is pinned via the committed `vendors/` folder.

## Migrations

```bash
cd protected && ./yiic migrate create <name>
./yiic migrate                                  # apply
./yiic migrate down                             # roll back the last
```

Tracking table: `tbl_migration`. File naming:
`mYYMMDD_HHMMSS_<snake>.php`. Always implement `safeUp` / `safeDown` —
they run inside a transaction so you can re-run safely.

## Test login

Default seed credentials (rotate immediately for non-throwaway envs):

| Role | Login | Password |
|------|-------|----------|
| Super-admin | `admin` | `admin` |
| Manager | `manager` | `123456` |

(If your dump differs, ask the team for the correct creds.)
