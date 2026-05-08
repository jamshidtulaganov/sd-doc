---
sidebar_position: 1
title: Обзор модулей
---

# Обзор модулей

SalesDoctor организован как **40+ модулей Yii** в каталоге
`protected/modules/`. Каждый модуль — это самодостаточная функциональная область со своими
контроллерами, моделями, представлениями и (опционально) сервисами.

## Группировка по доменам

| Домен | Модули |
|--------|---------|
| **Ядро / Платформа** | `dashboard`, `settings`, `access`, `staff`, `team`, `sync` |
| **Продажи и CRM** | `orders`, `clients`, `agents`, `partners`, `onlineOrder`, `planning`, `rating`, `vs` |
| **Склад и запасы** | `warehouse`, `inventory`, `stock`, `store`, `markirovka` |
| **Финансы** | `finans`, `pay`, `payment` |
| **Полевые операции** | `gps`, `gps2`, `gps3`, `audit`, `doctor`, `adt` |
| **Коммуникации и отчётность** | `sms`, `report`, `integration`, `aidesign`, `neakb` |
| **API** | `api`, `api2`, `api3`, `api4` |

Диаграмма Module Map в FigJam визуализирует зависимости.

## Анатомия модуля

```
protected/modules/<name>/
├── <Name>Module.php          Module bootstrap, init(), defaultController
├── controllers/              Web/JSON controllers
├── models/                   Module-local models (most live in protected/models/)
├── views/                    Module views, mirroring controller folders
├── services/                 (optional) Domain services for the module
├── components/               (optional) Module-internal components
├── actions/                  (optional) Reusable action classes
└── docs/                     (optional) Inline notes
```

## Активация

Каждый модуль перечислен в `protected/config/main_static.php` под ключом
`modules`. Добавления папки **недостаточно** — обязательна запись в массиве.

## Межмодульное взаимодействие

- ✅ **Модели** разделяются глобально через автозагрузку `application.models.*`,
  поэтому любой модуль может использовать любую модель.
- ✅ **Сервисы** в `protected/components/` являются общими.
- ✅ **События**: некоторые горячие пути используют `Yii::app()->onAfter*` — применяется редко.
- ❌ **Контроллеры** одного модуля не должны напрямую вызывать контроллеры
  другого. Выносите общий код в `components/` или класс сервиса.

## Куда добавлять новый код

| Потребность | Куда |
|------|-------|
| Новый экран списка для существующей сущности | Каталог `controllers/` владеющего модуля |
| Новый сквозной сервис | `protected/components/<Service>.php` |
| Новая запланированная задача | `protected/components/jobs/<Job>.php` |
| Новый API-эндпоинт для мобильного приложения | `protected/modules/api3/controllers/` |
| Новый API-эндпоинт для B2B / онлайн | `protected/modules/api4/controllers/` |
| Новая доменная область | Новый модуль в `protected/modules/` + регистрация |
