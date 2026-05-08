---
sidebar_position: 5
title: Assets pipeline
---

# Assets pipeline (yoki uning yo'qligi)

**Build pipeline yo'q**. CSS va JS oddiy fayllar sifatida xizmat qiladi.

## Tushunish modeli

- Yangi JS / CSS → `js/` yoki `css/` ostiga qo'ying.
- View-dan `clientScript` orqali havola qiling.
- Yii o'zi "asset bundle" deb hisoblagan har narsani runtime-da `assets/<hash>/` ga nusxalaydi; bu kiritiladigan URL.
- Cache busting hash qilingan asset papka nomi orqali amalga oshiriladi.

## Minifikatsiya

Ixtiyoriy. Aksariyat fayllar minify qilinmagan holda xizmat qiladi. Agar minify qilmoqchi bo'lsangiz, o'zingizning ixtiyoriy vositangizni mahalliy ravishda ishga tushiring va `<file>.js` va `<file>.min.js` ikkalasini ham commit qiling, keyin production build-larida minifylangan variantga havola qiling.

## Versiyalash

Repo frontend versiya manifesti ishlatmaydi. Hard refresh qilishni majburlash uchun view-da `?v=<release-tag>` qo'shing:

```php
Yii::app()->clientScript->registerScriptFile('/js/orders.js?v=' . VERSION);
```
