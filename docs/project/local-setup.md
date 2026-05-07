---
sidebar_position: 3
title: Local setup
---

# Local setup

## Prerequisites

- Docker Desktop (or Docker Engine + Compose)
- ~4 GB free RAM
- Git
- A local hosts entry for the dev subdomain you'll test against

## Bring it up

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

The stack will expose:

| Service | URL |
|---------|-----|
| Web app | http://localhost:8080 |
| phpMyAdmin | http://localhost:8081 (root / root) |
| MySQL | `127.0.0.1:3306` (`jamshid` / `secret`) |
| Redis | `127.0.0.1:6379` |

## Seed the database

There is no fully automated seed script today. Workflow:

```bash
# Pull a sanitised dump from the team file share, then:
docker compose exec db mysql -uroot -proot sd_main < dump.sql
```

If you don't have a dump, ask a teammate or use the staging environment
read-only mirror.

## Test login

Default credentials in a fresh seed:

| Role | Login | Password |
|------|-------|----------|
| Super Admin | `admin` | `admin` |
| Agent | `agent1` | `123456` |

Change them immediately for any non-throwaway environment.

## Hot reload?

Yii doesn't compile, so editing PHP files refreshes on the next request.
JS/CSS changes are picked up by browser refresh. There is **no** hot module
replacement — this is a server-rendered app.

## Common gotchas

- **Permissions on `runtime/` and `assets/`** — make sure `www-data` can
  write. The Dockerfile chowns them, but a host bind mount can clobber that.
- **PHP warnings flooding logs** — many files are PHP 7.3-era and emit
  deprecations under PHP 8. Stay on 7.3 unless you know what you're doing.
- **`assets/` filling up disk** — periodically `rm -rf assets/<hash>` to
  clear stale published bundles.
