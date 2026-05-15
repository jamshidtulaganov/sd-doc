---
title: "Sales Doctor - Duplicate Client"
audience: All sd-main developers, QA
summary: Live admin page at /clients/client/duplicate
topics: [clients, page, ui]
---

# Sales Doctor - Duplicate Client

**URL**: `/clients/client/duplicate` · **Module**: `clients` · **Controller**: `ClientController::duplicate` · **RBAC**: `operation.clients.duplicate` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - Duplicate Client](/screens/admin/clients_client_duplicate.jpg)

## Purpose

This page lives at `/clients/client/duplicate` in the live admin. It belongs to the **Clients** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Агент
- Выбрать все
- Убрать все
- Мерчендайзер
- Территория
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/clients/controllers/ClientController.php` (line 1566)
- **Action kind**: inline
- **View rendered**: `index_dublicate`
- **Required permission**: `operation.clients.duplicate`

## See also

- Module reference: [/modules/clients](/docs/modules/clients)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
