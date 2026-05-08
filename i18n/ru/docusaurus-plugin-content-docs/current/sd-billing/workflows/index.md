---
sidebar_position: 1
title: Feature workflows · индекс
slug: /sd-billing/workflows
---

# Feature workflows — каталог

Это индекс каждой фичи (одна интеграция шлюза, один админ-экран,
одна форма операции, один отчёт, одна cron-команда) в
**sd-billing**. Каждая строка — один контроллер; строки, выделенные **жирным**, имеют
полную страницу workflow, следующую [style guide](./style.md).
Невыделенные строки — заглушки: их фича существует в коде, но
страница workflow ещё не написана.

Если вы новый сотрудник, начните здесь:

1. Прочитайте [обзор sd-billing](../overview.md) и
   [авторизация и доступ](../auth-and-access.md), чтобы понять
   модель single-DB, per-tenant-licence.
2. Прочитайте [style guide](./style.md), чтобы понимать, что значат страницы
   workflow.
3. Выберите страницу workflow ниже — или, если у вашей фичи только
   заглушка, набросайте её используя skill `sd-billing-workflow-author`
   (живёт в `sd-docs/skills/sd-billing-workflow-author/SKILL.md`).

> **Источник**: каждая запись маппится на один файл контроллера в
> `sd-billing/protected/modules/<module>/controllers/`.

## Style и skill

| Страница | Когда читать |
|------|--------------|
| [Style guide](./style.md) | Перед написанием или ревью любой страницы фичи |
| `sd-docs/skills/sd-billing-workflow-author/SKILL.md` | Когда превращаете заглушку в полную страницу (путь к файлу, не на сайте документации) |

---

## api · gateway webhooks

Принимает входящие HTTP-вызовы от платёжных шлюзов, внешних
систем и админских инструментов. Авторизация различается по контроллеру — см.
[модули](../modules.md) для деталей.

| Фича | Контроллер | Заглушка |
|---------|-----------|-----------|
| [Click gateway](./api-click.md) | `ClickController` | Обрабатывает callbacks Click prepare/confirm; проверяет sign через `ClickTransaction::checkSign()` |
| Payme gateway | `PaymeController` | JSON-RPC endpoint Payme; проверяет HMAC перед зачислением платежей |
| Paynet gateway | `PaynetController` | SOAP-интеграция Paynet через `extensions/paynetuz`; обрабатывает подтверждения платежей |
| 1C integration | `Api1CController` | Принимает записи безналичных платежей и синхронизацию баланса от 1C-бухгалтерии |
| App API | `AppController` | Endpoint mobile/app аутентификации — выдаёт сессионные токены клиенту billing-приложения |
| Host status | `HostController` | Принимает пинги активных хостов и token-auth вызовы от инстансов `sd-main` |
| License endpoints | `LicenseController` | TOKEN-защищённые endpoint для запроса и обновления лицензий дилеров (читаются `sd-main` при логине) |
| SMS webhook | `SmsController` | Входящие callbacks доставки SMS (DLR) от Eskiz / Mobizon |
| Info / health | `InfoController` | Публичный health-check и billing-info endpoint; авторизация не требуется |
| Quest | `QuestController` | Кастомный quest-метрик endpoint; возвращает вычисленные KPI (price, churn, NPS, …) через basic auth |

---

## operation · subscriptions and payments

Где происходит большинство write-трафика. Владеет жизненным циклом подписки,
записью платежей, управлением пакетами, тарифами и чёрным списком.

| Фича | Контроллер | Заглушка |
|---------|-----------|-----------|
| [Жизненный цикл подписки](./operation-subscription.md) | `SubscriptionController` | CRUD для подписок дилеров; actions: list, create, update, delete, exchange, calculate-bonus |
| [Запись платежа](./operation-payment.md) | `PaymentController` | Записывает входящие платежи против дилера; поддерживает источники cashbox, distributor и gateway |
| Package management | `PackageController` | CRUD для billing-пакетов (бандлы фич с ценой и продолжительностью) |
| Package SMPro | `PackageSMProController` | Вариант управления пакетами, scoped на линейку продуктов SMPro |
| Subscription SMPro | `SubscriptionSMProController` | Управление подписками, scoped на дилеров SMPro |
| Dealer–package relation | `RelationController` | Маппит дилеров на пакеты; контролирует, какие наборы фич может активировать дилер |
| Tariff management | `TariffController` | CRUD тарифных планов, привязанных к пакетам |
| Blacklist | `BlacklistController` | Добавляет или убирает дилеров из чёрного списка платежей/доступа |
| Notifications | `NotificationController` | Управляет правилами исходящих уведомлений (предупреждения о сроке, чеки оплаты) |
| View hub | `ViewController` | Общая view-точка входа для страниц модуля operation |

---

## dashboard · admin UI

Главный экран operations-команды. Списки дилеров, дистрибьюторов,
платежей, подписок, графики и фиксы для зависших записей.

| Фича | Контроллер | Заглушка |
|---------|-----------|-----------|
| Dashboard home | `DashboardController` | Главная админская landing-страница — KPI-плитки, счётчики дилеров, недавние платежи |
| Dealer admin | `DealerController` | Vue-powered список дилеров с поиском, фильтром статуса, управлением тарифами и blacklist |
| Diler (legacy) | `DilerController` | Legacy AJAX-CRUD экран дилера; предшественник `DealerController` |
| Distributor | `DistrController` | AJAX-CRUD управление записями дистрибьюторов |
| Distributor computation | `DistrComputationController` | Per-distributor view расчёта сеттлемента (admin-only) |
| Computation (settlement) | `ComputationController` | Триггерит и просматривает прогоны баланса дилер↔дистрибьютор |
| Distributor payments | `DistrPaymentController` | AJAX-CRUD лог платежей между дистрибьютором и sd-billing |
| Dashboard payment | `PaymentController` | Read-only view всех входящих платежей со стороны дашборда |
| Charts | `ChartController` | Подаёт агрегированные time-series данные для графиков дашборда |
| Country sale | `CountrysaleController` | AJAX-CRUD per-country целей выручки |
| Server monitor | `ServerController` | Списки зарегистрированных `sd-main` серверов и их last-seen статус |
| Service (dashboard) | `ServiceController` | Загрузка и управление файлами сервисных уведомлений в админ-UI |
| Settings | `SettingController` | Настройки приложения админ-UI (feature flags, пороги, опции отображения) |
| Subscription view | `SubscripController` | Read-only view активных подписок per dealer |
| Fix toolbox | `FixController` | Ad-hoc data-fix команды (выдать скидку, сбросить состояние, массовые корректировки) |
| Reset | `ResetController` | Сбрасывает данные конкретного дилера или состояние подписки (admin-only destructive) |
| Notification | `NotificationController` | Dashboard view для управления in-app уведомлениями |

---

## partner · self-service portal

Партнёры (`ROLE_PARTNER`) логинятся сюда, чтобы видеть своих дилеров и
доходы. Доступ ограничен через `PartnerAccessService::checkAccess`
(в данный момент закомментирован — см. мины безопасности).

| Фича | Контроллер | Заглушка |
|---------|-----------|-----------|
| Partner view hub | `ViewController` | Точка входа; маршрутизирует партнёр-пользователей на разрешённые экраны |
| Partner dealers | `DealerController` | Partner-scoped список дилеров — показывает только аккаунты дилеров самого партнёра |
| Partner subscriptions | `SubscriptionController` | Read-only статус подписок дилеров партнёра |
| Partner payments | `PaymentController` | История платежей партнёра — входящие и исходящие |
| Partner report | `ReportController` | Отчёт по доходам и комиссиям партнёра |

---

## cashbox · cash desks and flow

Отслеживает оффлайн-кассы, типы потоков, переводы между кассами
и записи расхода.

| Фича | Контроллер | Заглушка |
|---------|-----------|-----------|
| Cashbox list | `CashboxController` | AJAX-CRUD записей касс (имя, владелец-пользователь, баланс) |
| Cash desk | `CashDeskController` | Детальный вид и операции для отдельной кассы |
| Flow type | `FlowTypeController` | Справочный список категорий cash-flow (income, expense, transfer, …) |
| Coming type | `ComingTypeController` | Справочный список типов источников входящего платежа |
| Transfer | `TransferController` | Записи переводов наличных между кассами |
| Consumption | `ConsumptionController` | Записи оттока наличных (записи consumption/expense) |

---

## report · aggregated reports

Более медленные агрегатные экраны, часто с экспортом через PHPExcel.

| Фича | Контроллер | Заглушка |
|---------|-----------|-----------|
| Active customers | `ActiveCustomersController` | Счётчик активных дилеров per country / currency за период |
| Catchers | `CatchersController` | Отчёт по acquisition новых дилеров по продавцу |
| Churn | `ChurnController` | Month-over-month рейт оттока по продавцу или стране |
| Client report | `ClientReportController` | Per-client (дилер) сводка использования и платежей |
| Diler report | `DilerReportController` | Агрегатный отчёт по всем дилерам |
| Feedback | `FeedbackController` | AJAX-CRUD лог записей NPS / feedback |
| Key account | `KeyAccountController` | Производительность дилеров key-account по продавцу |
| Key account period | `KeyAccountReriodController` | Отчёт key-account, нарезанный по кастомному периоду |
| P&L | `PLController` | Отчёт о прибылях и убытках за период |
| Pivot | `PivotController` | Многомерный pivot биллинговых метрик |
| Plan sales | `PlanSalesController` | Sales plan vs actual для billing sales-команды |
| Poll report | `PollReportController` | Результаты in-app опросов дилеров |
| Quest report | `QuestController` | View отчёта quest-метрик (зеркалит данные api/Quest) |
| Region | `RegionController` | Разбивка дилеров и выручки по регионам |
| General report | `ReportController` | Top-level отчёт landing / hub-страница |
| Revenue | `RevenueController` | Country-level таблица выручки с разбивкой по валютам |
| Statistic | `StatisticController` | Action-based статистика — сейчас выставляет endpoint `potential-churn` |
| Telegram bot stats | `TgBotController` | Месячная статистика использования Telegram-бота биллинга |
| View hub | `ViewController` | Общая view-точка входа для страниц модуля report |

---

## bonus · bonus and KPI system

Квартальные роллапы, отслеживание KPI, бонусы менторов и plan-vs-actual
для billing sales-команды.

| Фича | Контроллер | Заглушка |
|---------|-----------|-----------|
| Bonus tier 5 | `Bonus5Controller` | Vue-based дашборд расчёта бонуса для tier-5 продавцов |
| Bonus tier 6 | `Bonus6Controller` | Вариант расчёта бонуса для tier-6 продавцов |
| KPI | `KpiController` | Vue KPI-скоринг view per продавца за заданный период |
| KPI leaderboard | `KpiLeaderController` | Ранжированный лидерборд KPI-скоров продавцов |
| Mentor | `MentorController` | Месячный расчёт и обзор бонуса ментора |
| Mentor KPI | `MentorKpiController` | Комбинированный отчёт mentor + KPI для старших продавцов |
| Plan sales | `PlanSalesController` | Per-salesperson sales plan CRUD и трекинг прогресса |
| Quarters | `QuartersController` | AJAX-CRUD определений квартальных периодов, используемых в bonus calc |
| Bonus report | `ReportController` | Агрегатная сводка выплат бонусов по всему персоналу |
| Team | `TeamController` | Состав команды и assignment для расчёта бонуса |

---

## setting · app settings and reference data

Конфигурация приложения и справочные таблицы системы.

| Фича | Контроллер | Заглушка |
|---------|-----------|-----------|
| View hub | `ViewController` | Точка входа для модуля settings |
| User management | `UserController` | CRUD админ-пользователей — создание, активация, назначение ролей |
| System log | `SystemLogController` | Filtered viewer audit-trail `d0_system_log` |
| Classification | `ClassificationController` | CRUD для уровней классификации дилеров |
| City | `CityController` | Reference CRUD для записей городов |
| Country | `CountryController` | Reference CRUD для записей стран |
| Currency | `CurrencyController` | Reference CRUD для поддерживаемых валют |

---

## notification · in-app notifications

Иконка-колокольчик in-app уведомлений. Предоставляет API и UI для создания,
просмотра и отправки уведомлений пользователям дашборда.

| Фича | Контроллер | Заглушка |
|---------|-----------|-----------|
| Notification API | `ApiController` | JSON-actions: get, create, edit, send, delete уведомления |
| Notification view | `ViewController` | Рендерит inbox уведомлений и tally-экраны |

---

## sms · SMS packages

SMS-кредитные пакеты, которые дилеры могут покупать; отслеживает купленные
пакеты и доступные определения SMS-пакетов.

| Фича | Контроллер | Заглушка |
|---------|-----------|-----------|
| Bought SMS packages | `BoughtController` | Админский список SMS-пакетов, купленных дилерами |
| SMS package catalog | `PackageController` | CRUD определений SMS-пакетов (количество кредитов, цена) |

---

## access · per-user permission grid

Управляет сеткой прав на бит-флагах (`CREATE=1, UPDATE=2, SHOW=4,
DELETE=8`) для billing-пользователей.

| Фича | Контроллер | Заглушка |
|---------|-----------|-----------|
| User access | `UserController` | Просмотр и редактирование per-user разрешений на операции |

---

## directory · reference data API

Внутренний JSON API, используемый другими модулями для подтягивания справочных
таблиц (дилеры, дистрибьюторы, валюты, страны, города, …).

| Фича | Контроллер | Заглушка |
|---------|-----------|-----------|
| Directory API | `ApiController` | Выставляет endpoints `get-dealers`, `get-distributors`, `get-currencies`, `get-countries`, `get-cities` |

---

## dbservice · DB maintenance utilities

Ad-hoc диагностические запросы, массовые data-фиксы и helpers миграций
для operations-команды.

| Фича | Контроллер | Заглушка |
|---------|-----------|-----------|
| DB service | `ServiceController` | Index + action-list view для запуска зарегистрированных операций DB service |

---

## Как поддерживается этот индекс

Когда вы пишете или обновляете страницу workflow:

1. Замените заглушку в этом каталоге на ссылку `[**Feature**](./<slug>.md)`
   и однострочную сводку в той же строке.
2. Обновите `sidebars.js` (категория *Feature workflows*), чтобы новая
   страница появилась в сайдбаре.
3. Перезапустите `python3 scripts/render-diagram-gallery.py`, если вы добавили
   диаграмму на страницу.
