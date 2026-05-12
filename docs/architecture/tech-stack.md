---
sidebar_position: 2
title: Tech stack
---

# Tech stack

| Layer | Technology | Version | Notes |
|-------|------------|---------|-------|
| Language | PHP | **7.3** | Pinned in `Dockerfile` |
| Framework | **Yii 1.x** | bundled in `framework/` | Includes Gii dev tool |
| HTTP server | Nginx + php-fpm | latest | `nginx.conf` in repo root |
| Database | MySQL | **8.0** | InnoDB, `utf8` (legacy default) |
| Cache + queue | Redis | **7-alpine** | 3 logical DBs (sessions / queue / cache) |
| Frontend | jQuery 1.10 | – | Plus jQuery UI, Highcharts, fancybox |
| Frontend (modern) | Angular | per `ng-modules/` | Used in `gps`, `neakb` |
| Frontend (other) | Vue | – | A few isolated views under `views/vue` |
| Excel | PHPExcel | – | `protected/extensions/phpexcel` |
| Imaging | GD | – | Built into php image |
| QR / barcode | `protected/extensions/qrcode` | – | Order labels |
| Auth | Yii `CDbAuthManager` (subclassed) | – | RBAC roles 1–10 |
| Containerization | Docker / Docker Compose | – | `docker-compose.yml` |
| Locales | `ru` (default), `en`, `uz`, `tr`, `fa` | – | `protected/messages/` |
| External | Firebase FCM, Telegram Bot, SMS gateway, GPS providers | – | See [Integrations](../integrations/overview.md) |

## Why PHP 7.3 in 2026

Pinned because of legacy Yii 1.x and a number of vendored libraries that
break on PHP 8+ strict typing. There is an open ADR proposal to upgrade to
PHP 8.2 with a Yii 1.1 fork that ships PHP 8 fixes — see
[ADR 0001](../adr/yii1-stay.md).

## What we *don't* use (intentionally)

- ORM beyond Yii Active Record.
- Composer for application code (only used for `composer.json` / `vendor`
  third-party deps; the PSR-4 autoloader is mostly the Yii `import` path).
- A SPA framework end-to-end. Pages are server-rendered; "modern" widgets are
  isolated Angular or Vue islands.
- Front-end build pipeline. Assets are loaded from `js/` and `js_plugins/`
  via `<script>` tags managed by `clientScript`.
