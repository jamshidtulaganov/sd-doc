---
sidebar_position: 4
title: API v2 (заморожен)
---

# API v2 — модуль `api2`

Заморожен. Большинство контроллеров — `*.obsolete`; остаётся только
`MigrateController` как утилита поддержки.

Если видите клиента, обращающегося к `/api2/...`, — это старая сборка.
Найдите его через `protected/modules/api/controllers/ApiLogController.php`
и спланируйте миграцию на v3 (мобильный) или v4 (онлайн).
