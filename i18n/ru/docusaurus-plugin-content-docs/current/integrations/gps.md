---
sidebar_position: 9
title: GPS-провайдеры
---

# GPS-провайдеры

Мобильное приложение постит GPS-сэмплы в api3 (`POST /api3/gps/index`).
Для отслеживания транспорта внешние провайдеры могут постить напрямую:

| Провайдер | Эндпоинт |
|-----------|----------|
| Generic JSON | `POST /gps3/backend/ingest` |
| Wialon-стиль | `POST /gps3/backend/wialon` |

Аутентификация — на провайдера (токен в URL или заголовке). Сэмплы
пишутся в `gps_track`, затем потребляются `MonitoringController` и
Angular-картой UI.
