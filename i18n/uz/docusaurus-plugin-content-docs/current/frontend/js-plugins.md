---
sidebar_position: 3
title: JS plagins
---

# JS plagins

`js_plugins/` 3rd-party JS-ning vendored versiyasini saqlaydi. Yangi plaginlar bu yerga faqat juda zarur bo'lgan paytdagina qo'shiladi — har bir qo'shimcha doimiy bog'liqlikka aylanadi, chunki build pipeline yo'q.

## Hozirgi paytda foydalanilayotganlar

| Papka | Maqsadi |
|--------|---------|
| `bootstrap/` | Bootstrap 3 (legacy) |
| `chosen/` | Qidiruvli select-lar |
| `fancybox/`, `fancybox2/` | Modallar + lightbox |
| `FixedColumns/` | DataTables qotirilgan ustunlar |
| `ajaxform/` | Ajax forma yuborish |
| `ajaxcrud_behavior.js` | Yii ajaxcrud yordamchisi |
| `jquery-highcharts-10.3.3/` | Charts |
| `jquery.spin.js`, `spin.min.js` | Yuklash spineri |
| `json2/` | JSON polyfill (legacy) |
| `la-color-picker/` | Rang tanlovchi |
| `noty/` | Toast bildirishnomalari |
| `export/` | Excel / CSV eksport yordamchilari |

## Plagin qo'shish

1. Minify qilinmagan manbani `js_plugins/<name>/` ostiga joylashtiring.
2. View-dan `clientScript` orqali havola qiling:
   ```php
   Yii::app()->clientScript
     ->registerScriptFile('/js_plugins/<name>/<name>.js');
   ```
3. Uning maqsadini bu faylda hujjatlashtiring.

## Olib tashlash uchun nomzodlar

- `bootstrap/` — vaqt o'tishi bilan utility CSS bilan almashtiring.
- `json2/` — zamonaviy brauzerlarga kerak emas.
- `fancybox/` (v1) — faqat `fancybox2` ni saqlang.
