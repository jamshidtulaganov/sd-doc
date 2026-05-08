---
sidebar_position: 2
title: Kodlash standartlari
---

# Kodlash standartlari

## Style

- PSR-12, to'rt bo'shliqli indent.
- Interpolatsiya qilmagan holatda bitta tirnoq bilan stringlar.
- Public metodlarni har doim docblock qiling.
- Legacy fayllarda `declare(strict_types=1)` ishlatmang.
- Ichma-ich if lardan ko'ra erta return ni afzal ko'ring.

## Pull request qoidalari

- PR boshiga bitta mantiqiy o'zgarish.
- Migratsiyalar o'z commiti da.
- Tavsifda quyidagilar bo'lishi kerak:
  - **Kontekst** (nima uchun)
  - **Nima o'zgardi**
  - **Qanday tekshirish**
  - **Rollback rejasi**

## Qilmang

- `*.obsolete` yangi fayllar qo'shmang. Ishonchingiz komil bo'lsa o'lik
  kodni o'chiring; ishonchsiz bo'lsangiz git tarixi orqali saqlang.
- v1 / v2 API larni kengaytirmang. v3 yoki v4 ga qo'shing.
- To'g'ridan-to'g'ri kesh chaqiriqlarini qo'shmang (`Yii::app()->cache`).
  `ScopedCache` dan foydalaning.
- Qattiq kodlangan DB nomiga yo'naltiruvchi SQL yozmang.
