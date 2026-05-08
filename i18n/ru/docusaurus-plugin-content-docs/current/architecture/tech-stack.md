---
sidebar_position: 2
title: Технологический стек
---

# Технологический стек

| Слой | Технология | Версия | Заметки |
|-------|------------|---------|-------|
| Язык | PHP | **7.3** | Зафиксирована в `Dockerfile` |
| Фреймворк | **Yii 1.x** | bundled в `framework/` | Включает dev-инструмент Gii |
| HTTP-сервер | Nginx + php-fpm | latest | `nginx.conf` в корне репозитория |
| База данных | MySQL | **8.0** | InnoDB, `utf8` (legacy default) |
| Кеш + очередь | Redis | **7-alpine** | 3 логические БД (sessions / queue / cache) |
| Frontend | jQuery 1.10 | – | Плюс jQuery UI, Highcharts, fancybox |
| Frontend (модерн) | Angular | по `ng-modules/` | Используется в `gps`, `neakb` |
| Frontend (другое) | Vue | – | Несколько изолированных view под `views/vue` |
| Excel | PHPExcel | – | `protected/extensions/phpexcel` |
| Imaging | GD | – | Встроен в php-образ |
| QR / barcode | `protected/extensions/qrcode` | – | Этикетки заказов |
| Auth | Yii `CDbAuthManager` (subclassed) | – | RBAC-роли 1–10 |
| Containerization | Docker / Docker Compose | – | `docker-compose.yml` |
| Локали | `ru` (default), `en`, `uz`, `tr`, `fa` | – | `protected/messages/` |
| Внешние | Firebase FCM, Telegram Bot, SMS-шлюз, GPS-провайдеры | – | См. [Интеграции](../integrations/overview.md) |

## Почему PHP 7.3 в 2026

Зафиксирован из-за legacy Yii 1.x и ряда vendored-библиотек, которые
ломаются на PHP 8+ со строгой типизацией. Есть открытое ADR-предложение
обновиться до PHP 8.2 с форком Yii 1.1, в который засунуты PHP 8-фиксы — см.
[ADR 0001](../adr/0001-yii1-stay.md).

## Что мы *не* используем (намеренно)

- ORM кроме Yii Active Record.
- Composer для прикладного кода (используется только для `composer.json` /
  `vendor` третьих зависимостей; PSR-4 autoloader — это в основном путь
  Yii `import`).
- SPA-фреймворк end-to-end. Страницы server-rendered; «модерные» виджеты —
  изолированные островки Angular или Vue.
- Front-end build pipeline. Ассеты подгружаются из `js/` и `js_plugins/`
  через `<script>`-теги, управляемые `clientScript`.
