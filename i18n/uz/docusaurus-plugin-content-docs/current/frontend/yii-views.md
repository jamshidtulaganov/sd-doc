---
sidebar_position: 2
title: Yii views
---

# Yii views

## Papka

```
protected/views/
├── layouts/      Yuqori darajadagi layoutlar (main.php, column1.php, ...)
├── modals/       Qayta foydalanish mumkin bo'lgan modal partial-lar
├── partial/      Umumiy partial-lar (header, sidebar, breadcrumbs)
├── invoiceTemplate/
├── site/         Login, error, dashboard
└── vue/          Izolyatsiya qilingan Vue orollari
```

Har bir modul kontrollerlariga mos keladigan o'z `views/<controller>/<action>.php` ga ega.

## Layoutlar

Aksariyat sahifalar `main.php` dan foydalanadi va u quyidagilarni render qiladi:

- Yuqori panel (logo, til tanlash, foydalanuvchi menyusi)
- Chap sidebar (rolga qarab)
- Kontent maydoni
- Footer

Keng jadvallar uchun sidebar olib tashlangan `column1.php` ga o'ting.

## Yordamchilar

- `H` (`protected/components/H.php`) — kichik HTML yordamchilari.
- `Formatter` (`protected/components/Formatter.php`) — valyuta, sanalar.
- `Compress` — chiqish gzip yordamchilari.
- `BootPager`, `MyHtml` — sahifalash va forma vidjetlari.

## View-larda i18n

```php
<?= Yii::t('orders', 'Create order') ?>
```

Kataloglar `protected/messages/<locale>/<category>.php` da joylashgan. Faol locale-lar: `ru` (default), `en`, `uz`, `tr`, `fa`.
