---
title: "Sales Doctor - MixReport"
audience: All sd-main developers, QA
summary: Live admin page at /adt/mixReport/index
topics: [adt, page, ui]
---

# Sales Doctor - MixReport

**URL**: `/adt/mixReport/index` · **Module**: `adt` · **Controller**: `MixReportController::index` · **RBAC**: `operation.adtMixReport.index` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - MixReport](/screens/admin/adt_mixReport_index.jpg)

## Purpose

This page lives at `/adt/mixReport/index` in the live admin. It belongs to the **ADT audit** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Аудит | `—` | text | — |
| Пользователи | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | ФИО |
| 2 | ОКБ |
| 3 | План Визит |
| 4 | План Посещено |
| 5 | дисциплина |
| 6 | аудит опрос (от план посещ) |
| 7 | Фото |
| 8 | Оценка по фотоотчетам |
| 9 | Ср. прод. Визит (Час:мин) |
| 10 | Дни до 9:30 |
| 11 | Дни после 16:00 |
| 12 | Наш прод |
| 13 | Конк прод |
| 14 | Общий |
| 15 | Полный |
| 16 | Не полный |
| 17 | % покрытия от план пос |
| 18 | Оцен от покрытие фото |
| 19 | Плохо |
| 20 | Неудов. |
| 21 | Удов. |
| 22 | Хорошо |
| 23 | Отлично |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Экспорт
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/adt/controllers/MixReportController.php` (line 16)
- **Action kind**: inline
- **View rendered**: `index`
- **Required permission**: `operation.adtMixReport.index`

## See also

- Module reference: [/modules/audit-adt](/docs/modules/audit-adt)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
