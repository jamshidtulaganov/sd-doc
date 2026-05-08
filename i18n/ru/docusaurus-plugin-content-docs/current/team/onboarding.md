---
sidebar_position: 3
title: Онбординг нового разработчика
audience: New backend / frontend / mobile / DevOps engineers
summary: План первого дня, первой недели и первого месяца, чтобы стать продуктивным на платформе SalesDoctor (sd-cs · sd-main · sd-billing). Порядок чтения, настройка окружения, стартовые тикеты, к кому обращаться.
topics: [onboarding, first-day, first-week, ramp-up]
---

# Онбординг нового разработчика

Добро пожаловать. Эта страница — путь от "первого дня" до "отгрузки
первого PR" на платформе SalesDoctor. План предполагает, что вы
backend / frontend / mobile / DevOps инженер с общим веб-опытом и без
прежнего знакомства с Yii 1.x.

У платформы **три родственных проекта** — см. [страницу Ecosystem](../ecosystem.md)
для большой картины, прежде чем нырять.

## День 1

Цель: иметь документацию + код на ноутбуке и одно локальное окружение
запущенным.

- [ ] Получить **доступ GitHub** к `sd-main`, `sd-cs`, `sd-billing`,
      `sd-docs`, `sd-components`.
- [ ] Получить **VPN / сетевой доступ** к dev MySQL-репликам.
- [ ] Склонировать четыре репозитория под `~/projects/salesdoctor/`.
- [ ] Установить **Docker Desktop** (≥ 4 ГБ RAM выделено) и **Node 18+**.
- [ ] Запустить сайт документации локально:
      ```bash
      cd sd-docs && npm install && npm run start
      ```
- [ ] Прочитать эти страницы по порядку:
      1. [Введение](/docs/intro)
      2. [Ecosystem](../ecosystem.md)
      3. [Обзор архитектуры](../architecture/overview.md)
      4. [Tech stack](../architecture/tech-stack.md)
- [ ] **Только Frontend track** — также прочитать:
      [Обзор фронтенда](../frontend/overview.md) →
      [Getting started (frontend)](../frontend/getting-started.md).

## Неделя 1

Цель: уметь поднять систему, читать её данные и трассировать один полный
запрос.

**Обязательно к чтению** (всем, по порядку):

- [ ] [Введение](/docs/intro)
- [ ] [Ecosystem](../ecosystem.md)
- [ ] [Обзор архитектуры](../architecture/overview.md)
- [ ] [Локальная установка](../project/local-setup.md) — поднять sd-main
      локально и smoke-тест логина.
- [ ] [Структура проекта](../project/structure.md)
- [ ] [Конвенции](../project/conventions.md)
- [ ] [Обзор модулей](../modules/overview.md)

**Читать по необходимости для первого тикета** (не читайте заранее;
подтягивайте, когда тикет это затронет):

- Архитектура deep-dive:
  [Мультитенантность](../architecture/multi-tenancy.md),
  [Кеширование](../architecture/caching.md),
  [Background jobs](../architecture/jobs-and-scheduling.md).
- sd-billing local setup:
  [sd-billing local setup](../sd-billing/local-setup.md).
- Frontend track:
  [Frontend conventions](../frontend/conventions.md),
  [Adding a screen](../frontend/adding-a-screen.md),
  [Yii views](../frontend/yii-views.md),
  [JS plugins](../frontend/js-plugins.md),
  [ng-modules](../frontend/ng-modules.md),
  [Asset pipeline](../frontend/assets-pipeline.md).
- UI-паттерны:
  [Page layout](../ui/page-layout.md),
  [tables](../ui/tables.md),
  [filters](../ui/filters.md),
  [forms](../ui/forms.md),
  [modals](../ui/modals.md).

**Затем:**

- [ ] Выберите один user-visible flow и трассируйте end-to-end:
      Предлагаемый flow: *агент сабмитит мобильный заказ*.
      - Mobile-запрос: [API v3 — `POST /api3/order/create`](../api/api-v3-mobile.md)
      - Хендлер контроллера в `protected/modules/api3/controllers/OrderController.php`
      - Валидация + insert в `OrderService` / модели `Order`
      - Job резервирования стока в очереди
      - Status transition в `Reserved`
      - Прочитайте sequence [Order lifecycle](../architecture/diagrams.md)
- [ ] Откройте один **стартовый тикет** (ваш менеджер назначит).
      Рекомендованные стартеры:

      *Backend-flavoured:*
      - Добавить строку перевода в `protected/messages/uz/...`.
      - Конвертировать вызов `Distr::getFilter()` в `QueryBuilder`.
      - Написать unit-тест для существующего метода сервиса.

      *Frontend-flavoured:*
      - Добавить новую колонку в существующий list-view (например, колонка
        `Agent` в таблице заказов) — затрагивает Yii-view, конфиг
        DataTables и i18n-ключи в
        `protected/messages/<locale>/orders.php`. Используйте
        [Adding a screen](../frontend/adding-a-screen.md) как чеклист.
      - Конвертировать один inline `style="..."` в view в именованный CSS-класс.
      - Добавить отсутствующий `aria-label` к одному меню row-actions `⋮`
        и задокументировать в [UI · Tables](../ui/tables.md).
      - Добавить один отсутствующий вызов `Yii::t()` там, где литеральная
        RU-строка проскочила в view; добавить соответствующие ключи `en` и
        `uz`.
- [ ] Сабмитьте свой первый PR. Следуйте
      [Стандартам кода](../quality/coding-standards.md) и
      [Контрибуции](../quality/contribution.md).

## Месяц 1

Цель: отгрузить customer-visible изменение и понять второй проект.

- [ ] Отгрузите небольшую фичу (≤ 1 неделя) end-to-end, включая
      тесты, апдейт документации, запись в release-notes.
- [ ] Прочитайте **одно из**:
      - [sd-cs overview](../sd-cs/overview.md) +
        [sd-cs ↔ sd-main integration](../sd-cs/sd-main-integration.md)
        если будете работать на HQ-репортинге.
      - [sd-billing overview](../sd-billing/overview.md) +
        [Subscription flow](../sd-billing/subscription-flow.md), если
        будете работать на подписках / платежах.
- [ ] Пройдите по 5 реальным production-тикетам в трекере и предскажите
      диагноз перед чтением резолюции.
- [ ] Спарьтесь с кем-то из QA на цикле регрессионного тестирования (см.
      [Team · QA](./qa.md)) — даст вам каталог failure-mode.

## Как мы работаем

| Тема | Где читать |
|-------|---------------|
| Бранчи, PR | [Стандарты кода](../quality/coding-standards.md), [Контрибуция](../quality/contribution.md) |
| Процесс релизов | [Процесс релизов](../quality/release-process.md) |
| Тесты | [Тестирование](../quality/testing.md) |
| ADR | [ADR index](../adr/index.md) |
| Диаграммы | [Diagrams (FigJam)](../architecture/diagrams.md) |

## К кому обращаться

| Тема | Канал |
|-------|---------|
| Доступ к репо / VPN | `#it-helpdesk` |
| Вопросы домена sd-main | `#sd-main-eng` |
| sd-cs / HQ-репортинг | `#sd-cs-eng` |
| Биллинг и платежи | `#sd-billing-eng` |
| QA-процесс | `#qa` |
| Что-то ещё | ваш tech lead |

## Ловушки в первый месяц

- ❌ Трогать `framework/` (вендорный Yii 1.x). Не надо.
- ❌ Добавлять `declare(strict_types=1)` в legacy-файлы.
- ❌ Хардкодить имя БД тенанта.
- ❌ Вызывать `Yii::app()->cache` напрямую — используйте `ScopedCache`.
- ❌ Добавлять новые эндпоинты в `api` или `api2`. Используйте `api3` (мобильный) или
  `api4` (онлайн).
- ❌ Переименовывать колонки в legacy-таблицах. Существующие call-site
  зависят от `UPPER_SNAKE_CASE`.

## Справка: полезные one-liner-ы

```bash
# Найти все obsolete-файлы в sd-main:
find protected -name "*.obsolete"

# Посчитать модули:
ls protected/modules | wc -l

# Скелет перевода для новой RU-страницы:
mkdir -p i18n/ru/docusaurus-plugin-content-docs/current/<path>
cp docs/<path>/<page>.md i18n/ru/docusaurus-plugin-content-docs/current/<path>/<page>.md

# Хвост runtime-лога sd-main:
docker compose exec web tail -f protected/runtime/application.log
```

## Добро пожаловать на борт

Ваш первый PR не должен быть впечатляющим — он должен показать,
что вы можете провести изменение end-to-end. Сосредоточьтесь на петле,
а не на размере. Спрашивайте рано, спрашивайте часто.
