---
sidebar_position: 5
title: Local setup
---

# sd-cs local setup

sd-cs is an old-school host-PHP Yii 1.1 app. There is no Dockerfile or
compose stack in the repo — you serve `index.php` from a local webroot
(nginx/Apache + PHP-FPM, or `php -S` for quick checking). The realistic
pain points are the **two MySQL connections** and the **Redis cache**.

## Prerequisites

- PHP 7.3+ with `pdo_mysql`, `mbstring`, `gd`, `bcmath`, `redis` extensions
- Composer
- A local MySQL 5.7/8.x
- A reachable Redis (the bundled config points at `10.0.0.11:6379` —
  see the gotcha at the bottom)
- Webroot served from the cloned repo directory
- `sd-main` already running locally (Option A seed below depends on it)

## Bring it up

```bash
git clone <repo> sd-cs
cd sd-cs

# 1. Pull the framework + phpspreadsheet into vendor/
composer install

# 2. Bootstrap runtime / assets / uploads folders (one-time)
php default_folders.php

# 3. Provide DB credentials (gitignored)
cp protected/config/db_sample.php protected/config/db.php
$EDITOR protected/config/db.php
```

Then point your webserver's document root at the repo directory. With
`php -S` for a quick smoke test:

```bash
php -S 127.0.0.1:8090 index.php
```

For nginx, the project relies on `$_SERVER['DOCUMENT_ROOT']` resolving to
the repo root (see `protected/config/main.php`) — confirm `root` in your
server block points there, not at a subdirectory.

## Configure the two database connections

`db_sample.php` ships with two stub connections. The placeholder hosts
(`localhost1`, `localhost2`) are intentional reminders that the two
connections can — and in production do — live on different MySQL hosts.

### `db` — own `cs_*` schema

sd-cs's own database. Create it locally:

```sql
CREATE DATABASE cs_dev CHARACTER SET utf8mb4;
```

You'll need a dump or migration source for the `cs_*` tables; ask in
`#sd-cs` if there's no current sanitised dump in the dumps SharePoint.

### `dealer` — swappable `d0_*` connection

This is the dealer's sd-main database. The `dealer` component's DSN gets
**replaced at runtime** when sd-cs reads from a different dealer (see
`docs/sd-cs/multi-db.md`); the value in `db.php` is just the default.

Working `db.php` for local dev:

```php
return [
    'db' => [
        'connectionString' => 'mysql:host=127.0.0.1;dbname=cs_dev',
        'emulatePrepare'   => true,
        'username'         => 'root',
        'password'         => 'secret',
        'charset'          => 'utf8',
        'tablePrefix'      => 'cs_',
    ],
    'dealer' => [
        'class'            => 'CDbConnection',
        'connectionString' => 'mysql:host=127.0.0.1;dbname=sd_main',
        'emulatePrepare'   => true,
        'username'         => 'root',
        'password'         => 'secret',
        'charset'          => 'utf8',
        'tablePrefix'      => 'd0_',
    ],
];
```

## Seed data

### Option A — point `dealer` at sd-main's local DB (recommended)

If you have sd-main running locally per `docs/project/local-setup.md`,
you already have a `sd_main` schema with `d0_` tables. Just point
`dealer` at it (DSN above). Zero extra dump work.

If sd-main is in Docker, expose 3306 to the host (the default compose
file does) and use `127.0.0.1:3306` from sd-cs.

### Option B — two MySQL instances

When testing the cross-host case (real production shape), run a second
MySQL on a different port (e.g. 3307) and point `dealer` at it. You'll
need a `d0_` dump from a real dealer — no synthetic seed exists.

### Option C — read-only staging replica

Point `dealer` at a staging replica DSN if you have access. Treat as
read-only; sd-cs is mostly a reporter and shouldn't write anyway.

## Test login

`cs_*` users live in `cs_users` (or equivalent — check the seed dump).
There are no fixed default credentials shipped with the repo; whoever
gives you the dump will give you a login.

## Smoke check the multi-DB swap

A minimal controller that proves both connections work:

```php
public function actionPing() {
    $cs = Yii::app()->db->createCommand('SELECT 1')->queryScalar();
    $dl = Yii::app()->dealer->createCommand(
        'SELECT COUNT(*) FROM d0_users'
    )->queryScalar();
    echo "cs={$cs}, dealer_users={$dl}";
}
```

Hit `/site/ping` (or wherever you wired it). If `cs=1` but `dealer_users`
errors, your `dealer` DSN/credentials are wrong.

## Common gotchas

- **Redis hostname is hardcoded.** `protected/config/main.php` sets
  `redis_cache.hostname = '10.0.0.11'`. Locally you almost certainly
  want `127.0.0.1`. Don't commit the change — keep it as a local-only
  edit, or override via a gitignored `params.php`-style include.
- **Sessions go through Redis.** With Redis unreachable, login silently
  fails (`CCacheHttpSession` can't persist). Check `protected/runtime`
  logs first when login looks broken.
- **`themes/classic/` overrides win.** If a view edit doesn't show up,
  check whether `themes/classic/views/<...>` shadows the file you edited.
- **`assets/` permissions.** `default_folders.php` creates it 0777, but
  if your webserver user differs from your CLI user, regenerate or
  `chown` after running the bootstrap.
- **Cross-DB JOINs are forbidden.** `db` and `dealer` may be on different
  hosts in production, so JOINs across them break in real environments
  even when they work locally. Aggregate in PHP.
- **`YII_DEBUG` is toggled by a sentinel file.** `touch DEBUG` in the
  repo root enables debug mode (see `index.php`).

## See also

- [Multi-DB connection](./multi-db.md) — how the `dealer` swap works at runtime
- [`docs/project/local-setup.md`](../project/local-setup.md) — sd-main's setup, which sd-cs reads from in Option A
