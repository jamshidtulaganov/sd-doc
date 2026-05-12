---
sidebar_position: 4
title: Hisobotlar va pivotlar
---

# Hisobotlar va pivotlar

sd-cs da ikki hisobot qatlami mavjud:

| Modul | Uslub |
|--------|-------|
| `report` | Bir ekranli hisobotlar — filtrlar + grid + Excel eksport |
| `pivot` | Pivot jadvallar — o'lchovlar va o'lchamlarni sudrash |

## Diler ma'lumotlarini qanday o'qiydi

Aksariyat hisobotlar **DealerReportService** namunasi orqali o'tadi:

1. Doiraga kiruvchi dilerlarni tanlash (mamlakat, hudud, hammasi).
2. Har bir diler uchun `dealer` ulanishini almashtirish.
3. Diler tarafidagi so'rovni ishga tushirish → satrlarni vaqtinchalik
   yig'uvchiga jo'natish.
4. Sikldan keyin PHP'da agregatsiya qilish.

Juda katta pivotlar uchun xizmat har bir diler uchun oraliq satrlarni
`cs_*` staging jadvallariga yozadi va so'ng MySQL'da agregatsiya
qiladi.

## Keshlash

`redis_cache` (bitta mantiqiy Redis ulanishi) o'zida saqlaydi:

- Sessiyalarni.
- Ixtiyoriy hisobot natijalari kesh, kalit:
  `report:<name>:<filters_hash>:<dealers_hash>`.

HQ hisobotlari uchun 5–15 daqiqalik TTL'lar tipik.

## Excel eksport

sd-main bilan bir xil — PHPExcel.

## Performans bo'yicha maslahatlar

- Diler siklini har doim sozlanadigan parallellik bilan cheklang.
- JOIN'larni diler tarafiga itaring; tor satrlarni torting.
- HQ tarafida agressiv keshlang; HQ foydalanuvchilari yuqori darajadagi
  metrikalar uchun 1 daqiqalik eskirishdan xursand.
