---
sidebar_position: 12
title: gps / gps2 / gps3
audience: Backend engineers, QA, PM, Field ops, Supervisors
summary: GPS-трекинг — существуют три поколения; gps3 — активное. Живой мониторинг, проигрывание поездок, геофенсинг, приём с мобильных + внешних провайдеров.
topics: [gps, geofence, monitoring, tracking, route]
---

# Модули `gps`, `gps2`, `gps3`

GPS-трекинг. Существуют три поколения; новые разработки следует вести
в актуальном (`gps3`).

| Модуль | Статус | Замечания |
|--------|--------|-------|
| `gps` | Поддержка | Первое поколение; используется старыми клиентами |
| `gps2` | Заморожено | Легаси |
| `gps3` | **Текущий** | Сюда идут новые функции |

## Ключевые возможности

| Возможность | Что делает | Роль(и) владельца |
|---------|--------------|---------------|
| Живой мониторинг | Карта всех агентов филиала в реальном времени | 8 / 9 |
| Проигрывание поездки | Воспроизведение дня агента на карте | 8 / 9 |
| Геофенс на каждый визит | Валидация, что check-in агента внутри радиуса клиента | system |
| Приём GPS с мобильного | Мобильное приложение шлёт сэмплы каждые ~30 с | system |
| Приём от внешнего провайдера | Универсальные JSON / Wialon-style эндпоинты | system |
| Флаг out-of-zone | Визиты вне радиуса помечаются для проверки | 8 / 9 |
| KPI: GPS-покрытие | Процент плановых визитов с реальным GPS check-in | 8 / 9 |

## Возможности

- Живой трекинг агентов на карте (`MonitoringController`)
- Геофенс-верификация на каждый визит (`OrdersGpsController`)
- Проигрывание поездки (`TrackingController`)
- Фоновый приём от мобильных клиентов (`BackendController`,
  `GetController`)
- Дашборд для супервайзеров (`FrontendController`)

## Angular-модуль

Современный UI карты живёт в `ng-modules/gps/` — самостоятельный Angular-
модуль, загружаемый в Yii-представление. Собирайте его отдельно и копируйте `dist/`
в `ng-modules/gps/`.

## Ключевой поток функционала — визит и GPS

См. **Feature · Visit & GPS geofence** в
[FigJam · sd-main · Feature Flows](https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU).

## Воркфлоу

### Точки входа

| Триггер | Контроллер / Действие / Задача | Замечания |
|---|---|---|
| Mobile HTTP POST `POST /api3/gps/index` | `GpsController::actionIndex` | Пакет GPS-сэмплов из мобильного приложения; авторизация через заголовок `HTTP_DEVICETOKEN` |
| Mobile HTTP POST `POST /api3/gps/offline` | `GpsController::actionOffline` | Эндпоинт сброса offline-буфера (заглушка — пока без записи в БД) |
| Web загрузка страницы `GET /gps3/client/index` | `ClientController::actionIndex` | Рендерит оболочку SPA AngularJS "Clients on map" |
| Web AJAX `GET /gps3/client/fetchClients` | `ClientController::actionFetchClients` | JSON-список клиентов с LAT/LON для пинов Yandex Maps |
| Web AJAX `GET /gps3/client/fetchVisits` | `ClientController::actionFetchVisits` | Расписание агент × день недели для дерева сайдбара |
| Web AJAX `GET /gps3/client/fetchSummary` | `ClientController::actionFetchSummary` | Итоги визитов по категории для статистической панели |
| Web AJAX `GET /gps3/client/fetchAgents` | `ClientController::actionFetchAgents` | Выпадающий список мерчандайзеров (ROLE = 11) |
| Web AJAX `GET /gps3/client/fetchRegions` | `ClientController::actionFetchRegions` | Выпадающий список городов/регионов |
| Web AJAX `GET /gps3/client/fetchCategories` | `ClientController::actionFetchCategories` | Выпадающий список категорий клиентов |
| Web печать `GET /gps3/client/print` | `ClientController::actionPrint` | Печатный список клиентов с координатами |
| Web AJAX `GET /gps3/monitoring/fetchData` | `MonitoringController::actionFetchData` (gps2) | Последние известные позиции агентов для живой карты; контроллер живёт в модуле `gps2` |
| Web AJAX `GET /gps3/monitoring/fetchSupervayzers` | `MonitoringController::actionFetchSupervayzers` (gps2) | Список фильтра супервайзеров для представления мониторинга |
| Web AJAX `GET /gps3/route/fetchData` | `RouteController::actionFetchData` (gps2) | Список визитов по агенту с GPS-координатами для карты проигрывания поездки |
| Web AJAX `GET /gps3/route/fetchRoutes` | `RouteController::actionFetchRoutes` (gps2) | Упорядоченный GPS-трек для полилинии маршрута |
| Web AJAX `GET /gps3/route/fetchReport` | `RouteController::actionFetchReport` (gps2) | Таблица дневной сводки визитов |
| Web AJAX `GET /gps3/route/fetchUsers` | `RouteController::actionFetchUsers` (gps2) | Выбор пользователя для представления маршрута |
| Angular UI | AngularJS-приложение `ng-modules/gps/` (контроллеры: `Client`, `Monitoring`, `Route`) | Активный браузерный UI; загружается в Yii-оболочку через регистрацию ассетов в `Gps3Module::registerAssets` |

---

### Доменные сущности

```mermaid
erDiagram
    Gps {
        int ID PK
        string AGENT_ID
        string TYPE
        double LAT
        double LON
        int BATTERY
        int GPS_STATUS
        string DATE
        string DAY
        string USER_ID
    }
    VisitingAud {
        int VISIT_ID PK
        string CLIENT_ID
        string AUDITOR_ID
        string DAY
    }
    Visit {
        int ID PK
        string CLIENT_ID
        string USER_ID
        string VISITED
        double LAT
        double LON
        double C_LAT
        double C_LON
        string GPS_STATUS
        string PLANED
        string DAY
        string DATE
    }
    Client {
        string CLIENT_ID PK
        string NAME
        double LAT
        double LON
        string CITY
        string CLIENT_CAT
        string ACTIVE
    }
    StructureFilial {
        int ID PK
        string NAME
        int ROLE
    }
    VisitingAud }|--|| Client : "CLIENT_ID"
    VisitingAud }|--|| StructureFilial : "AUDITOR_ID"
    Visit }|--|| Client : "CLIENT_ID"
    Gps }|--|| StructureFilial : "AGENT_ID (via User)"
```

---

### Воркфлоу 1.1 — Приём мобильного GPS-сэмпла

Мобильное приложение постит JSON-пакет GPS-сэмплов в `api3/gps/index`. Каждый
сэмпл аутентифицируется по device token, ограничивается одной записью в 10 с
и сохраняется в `{{gps}}` только в рабочие часы (08:00–20:00).

```mermaid
sequenceDiagram
    Mobile->>api3: POST /api3/gps/index (HTTP_DEVICETOKEN, JSON batch)
    api3->>DB: SELECT user by deviceToken (d0_user)
    DB-->>api3: User record
    api3->>api3: GpsController::checkLatestQueryTime — read log/{userId}.json
    alt last write < 10 s ago (single-sample batch)
        api3-->>Mobile: HTTP 429 Too Many Requests
    else batch > 1 sample or checkCurrentLocation=true
        api3->>api3: skip rate-limit check
    end
    loop each sample in batch
        api3->>api3: filter hour (gdate < 8 or > 20 → skip, or domain=="dena" → skip)
        api3->>DB: INSERT {{gps}} (LAT, LON, BATTERY, GPS_STATUS, TYPE, DATE, DAY)
        DB-->>api3: save result
    end
    api3->>api3: write log/{userId}.json (server_timestamp)
    api3-->>Mobile: JSON [{timestamp: "success"}, …]
```

---

### Воркфлоу 1.2 — Загрузка карты клиентов и фильтрация

Когда супервайзер открывает `/gps3/client/index`, AngularJS-контроллер `Client`
бутстрапится, получая справочные данные, а затем полный список клиентов +
расписание визитов; последующие изменения фильтра запрашивают только затронутые эндпоинты.

```mermaid
sequenceDiagram
    Web->>ClientController: GET /gps3/client/index
    ClientController-->>Web: HTML shell (AngularJS app bootstrapped)
    Web->>ClientController: GET /gps3/client/fetchAgents
    ClientController->>DB: SELECT StructureFilial WHERE ROLE=11
    DB-->>ClientController: agent list
    ClientController-->>Web: JSON agents
    Web->>ClientController: GET /gps3/client/fetchRegions
    ClientController->>DB: SELECT City JOIN Region
    DB-->>ClientController: region list
    ClientController-->>Web: JSON regions
    Web->>ClientController: GET /gps3/client/fetchClients?active=Y
    ClientController->>DB: SELECT Client JOIN VisitingAud JOIN StructureFilial (Gps::FetchClients)
    DB-->>ClientController: client rows (LAT, LON, AGENTS, DAYS)
    ClientController-->>Web: JSON clients
    Web->>ClientController: GET /gps3/client/fetchVisits?active=Y
    ClientController->>DB: SELECT VisitingAud JOIN Client (Gps::FetchVisits)
    DB-->>ClientController: visit schedule rows
    ClientController-->>Web: JSON visits
    Web->>Web: AngularJS builds visitsTree (agent→day→client) and pins to Yandex Maps
    Web->>ClientController: GET /gps3/client/fetchSummary (background)
    ClientController->>DB: subquery VisitingAud + Client + ClientCategory (Gps::FetchSummary)
    DB-->>ClientController: category totals
    ClientController-->>Web: JSON summary
```

---

### Воркфлоу 1.3 — Живой мониторинг агентов

Супервайзер открывает вкладку мониторинга; AngularJS-контроллер `Monitoring`
опрашивает последние известные позиции агентов через `MonitoringController` модуля `gps2`, затем
автоматически продвигает временную метку с интервалом 10 минут, чтобы карта оставалась живой.

```mermaid
sequenceDiagram
    Web->>MonitoringController: GET /gps3/monitoring/fetchSupervayzers
    MonitoringController->>DB: SELECT Supervayzer JOIN User WHERE ACTIVE='Y'
    DB-->>MonitoringController: supervisor list
    MonitoringController-->>Web: JSON supervisors
    loop every 10 minutes (client $interval)
        Web->>MonitoringController: GET /gps3/monitoring/fetchData?date=YYYY-MM-DD H:mm:ss
        MonitoringController->>DB: SELECT Agent LEFT JOIN Gps (max DATE <= :date) — Monitoring::FetchData
        DB-->>MonitoringController: agents with LAT, LON, BATTERY, GPS_STATUS, DATE
        MonitoringController-->>Web: JSON agent positions
        Web->>Web: Monitoring.agentsToGeoObjects — paint colored pins by status threshold (10 min = online/offline)
    end
```

---

### Воркфлоу 1.4 — Проигрывание поездки (представление маршрута)

Супервайзер выбирает агента и дату; AngularJS-контроллер `Route`
загружает все чекпоинты визитов и полилинию GPS-трека, чтобы супервайзер мог
воспроизвести день агента, проверить расстояния геофенса и просмотреть исходы
заказа/отказа.

```mermaid
sequenceDiagram
    Web->>RouteController: GET /gps3/route/fetchUsers
    RouteController->>DB: SELECT User WHERE ACTIVE='Y' AND AGENT_ID != '' — Route::FetchUsers
    DB-->>RouteController: user list
    RouteController-->>Web: JSON users
    Web->>Web: supervisor picks user + date
    Web->>RouteController: GET /gps3/route/fetchData?user=X&date=YYYY-MM-DD H:mm:ss
    RouteController->>DB: SELECT Visit JOIN Client JOIN Order (G_LAT/LON, C_LAT/LON, VISITED, GPS_CHANGED, VISIT_DISTANCE) — Route::FetchData
    DB-->>RouteController: visit rows with GPS coords and outcomes
    RouteController-->>Web: JSON visits
    Web->>RouteController: GET /gps3/route/fetchRoutes?user=X&date=…
    RouteController->>DB: SELECT gps rows for agent on date — Route::FetchRoutes
    DB-->>RouteController: GPS track points
    RouteController-->>Web: JSON route points
    Web->>Web: Route.routesToGeoObjects — draw polyline on Yandex Maps
    Web->>Web: Route.onGetDistance computes ymaps distance and flags out-of-zone visits
```

---

### Межмодульные точки соприкосновения

- Чтения: `application.Gps` (`{{gps}}` table) — общая модель AR, используемая `api3/GpsController` для приёма и `gps2/Monitoring::FetchData` для запросов мониторинга
- Чтения: `application.VisitingAud` (`{{visiting_aud}}`) — расписание визитов, потребляемое `gps3/Gps::FetchClients`, `FetchVisits`, `FetchSummary`
- Чтения: `application.Visit` (`{{visit}}`) — строки чекпоинтов GPS на каждый визит, потребляемые `gps2/Route::FetchData` и `FetchRoutes`
- Чтения: `application.Client` (`{{client}}`) — координаты клиентов (LAT/LON) сверяются с GPS визита в `Route::FetchData`
- Чтения: `application.ServerSettings::visitDistance` — настраиваемый радиус геофенса (по умолчанию ~100 м), внедряемый как `VISIT_DISTANCE` в SQL данных маршрута
- Записи: `application.Gps` (`{{gps}}`) — пишется `api3/GpsController::actionIndex` на каждый входящий мобильный сэмпл
- API: `api3/gps/index` — единственный мобильный эндпоинт приёма; `api3/gps/offline` — заглушка offline-сброса

---

### Подводные камни

- **MonitoringController и RouteController не в gps3.** AngularJS `config.js` маршрутизирует `/gps3/monitoring/*` и `/gps3/route/*`, но эти PHP-контроллеры живут в модуле `gps2`. URL-маршрутизация Yii, должно быть, мапит эти пути на `gps2`; добавление новых действий мониторинга/маршрута должно делаться в `protected/modules/gps2/controllers/`, а не `gps3/`.
- **Rate-limiting файловый.** `GpsController::checkLatestQueryTime` пишет JSON-файлы на каждого пользователя в `webroot/log/gps/{userId}.json`. Этот каталог должен быть доступен на запись и не очищается автоматически; использование диска неограниченно растёт на больших инсталляциях.
- **Фильтр рабочих часов молча отбрасывает сэмплы.** Любой GPS-сэмпл с временной меткой устройства вне 08:00–20:00 подтверждается как `"success"`, но никогда не пишется в БД. Это намеренно, но невидимо мобильному клиенту — отладка пропавших треков требует проверки серверных логов, а не ответа API.
- **`actionOffline` — заглушка.** Она пишет сырой текстовый файл (`Gps_Offline-<time>.txt`) в рабочий каталог и не возвращает данных — это не функциональный offline-буфер.
- **Флаг `GPS_CHANGED` влияет на вердикт геофенса.** Если LAT/LON клиента редактировались в тот же день, что и визит (`ClientLog` фиксирует изменение LON/LAT), `Route::FetchData` устанавливает `GPS_CHANGED=1`, и `onGetDistance` сообщает о визите как "unknown" независимо от вычисленного расстояния. Супервайзеры должны учитывать, что коррекция координат инвалидирует вердикты того же дня.
- **Легаси-модули gps/gps2.** Не добавляйте новые функции в `gps` или `gps2`. Оба остаются живыми для существующих клиентов; ломающие изменения там — высокий риск.
