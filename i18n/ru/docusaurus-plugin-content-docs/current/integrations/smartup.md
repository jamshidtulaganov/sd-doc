---
sidebar_position: 5
title: Smartup
---

# Smartup

Входящая интеграция со Smartup (конкурирующая/комплементарная ERP для
дистрибуции). Тенанты, использующие обе системы, ведут полевую работу
в SalesDoctor, а HQ-учёт в Smartup.

## Что мы импортируем

- Заказы, созданные в Smartup, которые должны попасть в SalesDoctor
  для доставки / выполнения кассой.
- См. `protected/modules/integration/actions/smartupx/ImportOrdersAction.php`.

## Сопоставление клиентов

Настраивается на тенанта через `client_search_attribute_salesdoc`:

| Значение | Сопоставление по |
|----------|------------------|
| `code` | `Client.CODE` |
| `id` | `Client.CLIENT_ID` |
| `inn` | `Client.INN` |

## Маппинг типа платежа

`salesdoc_payment_type_code` ↔ XML ID типа платежа Smartup. Сохраняется
на импортированном заказе, чтобы round-trip сохранял его.
