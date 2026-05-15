---
title: "Sales Doctor - PhotoReport"
audience: All sd-main developers, QA
summary: Live admin page at /audit/photoReport
topics: [audit, page, ui]
---

# Sales Doctor - PhotoReport

**URL**: `/audit/photoReport` · **Module**: `audit` · **Controller**: `PhotoReportController::index` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - PhotoReport](/screens/admin/audit_photoReport.jpg)

## Purpose

This page lives at `/audit/photoReport` in the live admin. It belongs to the **Audit (visit)** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Название задачи * | `NAME` | text | — |
| Дата выполнения * | `—` | div | — |
| Комментарий | `COMMENT` | textarea | — |

## Grid columns

| # | Column |
|---|---|
| 1 | Дата |
| 2 | ИД ТТ |
| 3 | ТТ |
| 4 | Тел |
| 5 | Пользователь |
| 6 | Территория |
| 7 | Количество фото |
| 8 | Рейтинг |
| 9 | Оценка |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Сбросить
- Вернуться назад
- Текущее фото
- Все фото
- Выбрать
- angela (Мерчендайзер)
- Полка
- Загрузить еще
- Показать всех пользователей
- Пользователи
- Выбрать все
- Убрать все
- Территория
- Категория
- май 1 - май 15
- По 20
- Показ./Скр. столбцы
- Excel
- Блокировать
- Разрешить
- OK
- Отменить

## Backend route

- **Controller file**: `protected/modules/audit/controllers/PhotoReportController.php` (line 52)
- **Action kind**: inline
- **View rendered**: `index2`

## See also

- Module reference: [/modules/audit-adt](/docs/modules/audit-adt)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
