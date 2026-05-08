---
sidebar_position: 2
title: Konventsiyalar
---

# Konventsiyalar

## Fayl nomlash

- **Modellar** — `PascalCase`, har bir fayl uchun bitta model, fayl nomi =
  klass nomi (`Order.php`, `Client.php`).
- **Kontrollerlar** — `PascalCaseController.php` (`OrderController.php`).
- **Modullar** — ichida `<Name>Module.php` bo'lgan `lowerCamel/` papka
  (`onlineOrder/OnlineOrderModule.php`).
- **View lar** — har bir kontroller uchun papka, har bir action uchun
  `lowercase.php` (`views/order/list.php`).
- **Ishlar (Jobs)** — `BaseJob` ni kengaytiradigan `<Name>Job.php`.

## Ma'lumotlar bazasi konventsiyalari

- **Jadvallar** — `d0_` bilan prefiksli (`main.php` da `tablePrefix` orqali
  tenant boshiga sozlanadigan). Xom SQL da har doim `{{prefix}}` o'rin
  egasini ishlating.
- **Asosiy kalitlar** — yangi jadvallar uchun `ID`, lekin eski kod katta
  harfli `<entity>_ID` ni aralashtiradi (masalan, `ORDER_ID`, `CLIENT_ID`).
  Mavjud konventsiyalar bilan kurashmang — siz tegayotgan jadvalga mos
  keling.
- **Audit ustunlari** — `CREATE_BY`, `CREATE_AT`, `UPDATE_BY`, `UPDATE_AT`,
  `TIMESTAMP_X`. `BaseFilial` save hooklari tomonidan to'ldiriladi.
- **Yumshoq o'chirish / nofaol** — eski jadvallarning ko'pchiligida
  `ACTIVE` (`Y` / `N`).
- **Filial scoping** — har bir tenant doirasidagi jadvalda `FILIAL_ID`
  bo'ladi. Modellar `BaseFilial` dan meros oladi va u qamrovni avtomatik
  qo'llaydi.

## PHP kod uslubi

- **PSR-12** uslubi, to'rt bo'shliqli otstup.
- **Strict typing** kod bazasi bo'ylab yoqilgan *emas* (PHP 7.3 davri
  kodi). Mavjud fayllarga `declare(strict_types=1)` qo'shmang.
- Public metodlarda **Docblocks** (CActiveRecord magic xususiyatlari ustida
  IDE intellisense ga yordam beradi).
- Interpolatsiya qilmasangiz, satrlar uchun **bitta tirnoq**.

## Git konventsiyalari

- Branch nomlari: `feat/<short-desc>`, `fix/<short-desc>`, `chore/...`.
- Commit subject: imperativ hozirgi zamon, ≤ 72 belgi.
- Bitta PR = bitta mantiqiy o'zgarish. Refaktoring + xususiyatni
  aralashtirishdan saqlaning.
- Migratsiyalar o'z commit larida boradi.
