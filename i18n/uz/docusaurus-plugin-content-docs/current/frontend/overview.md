---
sidebar_position: 1
title: Frontend umumiy ko'rinishi
---

# Frontend umumiy ko'rinishi

SalesDoctor — bu **server tomonida render qilinadigan** PHP. Frontend quyidagilarning aralashmasi:

| Qatlam | Texnologiya | Qayerda |
|-------|------|-------|
| Sahifa qobig'i | Yii views (PHP) | `protected/views/`, modul views |
| Sahifa logikasi (kichik) | jQuery + 3rd-party plagin | `js/`, `js_plugins/` |
| Zamonaviy "orollar" | Angular | `ng-modules/` |
| Bir nechta tajribalar | Vue | `protected/views/vue/` |
| Charts | Highcharts (10.3.3) | `js_plugins/jquery-highcharts-10.3.3` |
| Tables | DataTables | inline + `dataTables.material.min.css` |
| Modals | fancybox | `js_plugins/fancybox*` |
| Tanlovchilar | chosen, jquery-ui | `js_plugins/chosen`, `js/jquery-ui.js` |

## Sahifa hayotiy davri

1. Brauzer → Nginx → `index.php`.
2. Yii kontroller harakatiga marshrutlash.
3. Kontroller `protected/views/<controller>/<action>.php` dan view-ni render qiladi.
4. View JS / CSS ni yuklash uchun `Yii::app()->clientScript->registerPackage('jquery')` va shu kabilarni ishlatadi.
5. HTML javob to'liq sahifa sifatida yuboriladi — SPA qobig'i yo'q.

## Asset publishing

Yii ning `CAssetManager` view-lar tomonidan havola qilingan har qanday "asset bundle"ni `assets/<hash>/` ga nusxalaydi. Fayllar o'zgarganda hash o'zgaradi. Papka vaqt o'tishi bilan o'sib boradi — uni vaqti-vaqti bilan tozalang.

## Qachon Angular oroli qo'shish kerak

Mazmunli interaktiv UI uchun (xaritalar, drag-drop kanbanlar, murakkab formalar) `ng-modules/` ostida o'z build pipeline ga ega Angular modulini qo'shing. PHP view `<sd-feature></sd-feature>` ni embed qiladi va bundle qilingan JS ni `<script src="/ng-modules/feature/main.js">` orqali kiritadi.

Yangi SPA qatlamlarini bekorga qo'shmang — har bir orol texnik xizmat ko'rsatish xarajatlarini oshiradi.

## Shuningdek qarang

- [Yii views](./yii-views.md)
- [JS plagins](./js-plugins.md)
- [ng-modules](./ng-modules.md)
- [Asset pipeline](./assets-pipeline.md)
