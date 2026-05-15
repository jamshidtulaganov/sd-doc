---
title: "Sales Doctor - Client"
audience: All sd-main developers, QA
summary: Live admin page at /adt/client
topics: [adt, page, ui]
---

# Sales Doctor - Client

**URL**: `/adt/client` · **Module**: `adt` · **Controller**: `ClientController::index` · **RBAC**: `operation.clients.list` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - Client](/screens/admin/adt_client.jpg)

## Purpose

This page lives at `/adt/client` in the live admin. It belongs to the **ADT audit** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Экспорт в файл Google Earth
- Групповая обработка
- Добавить клиента
- На карте
- Мерчендайзер
- Выбрать все
- Убрать все
- Территория
- Категории клиентов
- Тип цены
- День
- Активный
- QR код
- Локация
- Тип ТТ
- Канал сбыта
- Экспорт
- Импорт
- ×
- Сбросить настройки
- Отменить
- Показать на карте
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/adt/controllers/ClientController.php` (line 129)
- **Action kind**: inline
- **View rendered**: `index`
- **Required permission**: `operation.clients.list`

## See also

- Module reference: [/modules/audit-adt](/docs/modules/audit-adt)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
