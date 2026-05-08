---
sidebar_position: 5
title: Smartup
---

# Smartup

Smartup bilan kiruvchi integratsiya (raqobatdosh/to'ldiruvchi distributiv
ERP). Ikkala tizimni ishlatuvchi ijaralar maydon kuchi uchun SalesDoctor
ni va shtab-buxgalteriya uchun Smartup ni ishlatadi.

## Biz nimani import qilamiz

- SalesDoctor ga yetkazib berish / kassir bajarish uchun oqishi kerak
  bo'lgan Smartup da yaratilgan buyurtmalar.
- `protected/modules/integration/actions/smartupx/ImportOrdersAction.php` ga qarang.

## Mijozni moslashtirish

`client_search_attribute_salesdoc` orqali ijara bo'yicha sozlanadi:

| Qiymat | Mosligi |
|--------|---------|
| `code` | `Client.CODE` |
| `id` | `Client.CLIENT_ID` |
| `inn` | `Client.INN` |

## To'lov turini xaritalash

`salesdoc_payment_type_code` ↔ Smartup to'lov turi XML ID. Import qilingan
buyurtmada saqlanadi, shuning uchun ikki tomonlama yo'l bilan o'tkazish uni saqlaydi.
