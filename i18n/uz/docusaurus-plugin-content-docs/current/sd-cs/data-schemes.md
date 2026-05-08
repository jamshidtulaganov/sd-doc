---
sidebar_position: 5
title: Ma'lumotlar sxemalari (sd-cs)
audience: Backend / data muhandislari
summary: sd-cs ish vaqtida ikkita ma'lumotlar bazasi ulanishiga ega — o'zining cs_* sxemasi (HQ-egalik) va d0_* jadvallarini faqat-o'qish o'qiydigan almashinuvchi diler ulanishi. Bu sahifa ikkalasini ham xaritalaydi.
topics: [sd-cs, schema, multi-db, cs-prefix, dealer-connection]
---

# sd-cs · Ma'lumotlar sxemalari

sd-cs **parallel ravishda ikkita MySQL ulanishini** saqlaydi (topologiya uchun
[Multi-DB ulanish](./multi-db.md) ga qarang). Ikki sxema, ikki egalik modellari.

## Ulanish 1 — `db` · HQ sxemasi (`cs_*`)

HQ-egalik sxemasi. sd-cs bu yerga erkin yozadi; bu brend egasi to'g'ridan-to'g'ri
boshqaradigan barcha narsa uchun yozuv tizimi.

| Domen | Jadvallar (prefiks `cs_`) |
|-------|---------------------------|
| HQ katalogi | `cs_brand`, `cs_segment`, `cs_country_category` |
| Rejalar / maqsadlar | `cs_plan`, `cs_plan_product` |
| HQ foydalanuvchilari | `cs_user`, `cs_authassignment`, `cs_authitem`, `cs_authitemchild` |
| Pivotlangan oraliq | `cs_pivot_<name>` (katta oldindan-hisoblangan pivotlar) |
| Audit logi | `cs_dblog` (har bir DBlar bo'ylab so'rov bu yerda logga olinadi) |

Ustun-darajasidagi tafsilotlar uchun [`docs/sd-cs/architecture.md`](./architecture.md)
da har-sxema ma'lumotnomasiga qarang.

## Ulanish 2 — `dealer` · har-diler faqat-o'qish almashish (`d0_*`)

Almashinuvchi ulanish — o'zaro-diler hisobotlarida har dileri uchun qayta
o'rnatiladi. Har doim **MySQL grant darajasida faqat-o'qish**. sd-cs bu
ulanishdan o'qiydi, lekin hech qachon yozmaydi.

| Domen | O'qiladigan jadvallar (prefiks `d0_`) |
|-------|----------------------------------------|
| Sotuvlar | `d0_order`, `d0_order_product`, `d0_defect` |
| Mijozlar | `d0_client`, `d0_client_category` |
| Agentlar | `d0_agent`, `d0_visit`, `d0_kpi_*` |
| Katalog | `d0_product`, `d0_category`, `d0_price`, `d0_price_type` |
| Stok | `d0_stock`, `d0_warehouse`, `d0_inventory` |
| Auditlar | `d0_audit`, `d0_audit_result` |
| GPS | `d0_gps_track` |

Bular sd-main jadvallari — ustun-darajasidagi tafsilotlar va ERD uchun
[sd-main · Ma'lumotlar Sxemalari](../data/erd.md) sahifasiga qarang.
sd-cs ularni o'qish interfeysi sifatida ko'radi, o'zining ma'lumotlar modeli emas.

## Konventsiyalar

- Diler DB ga maqsad qilingan **modellar** `getDbConnection()` ni `Yii::app()->dealer`
  qaytarish uchun bekor qiladi. Pattern uchun [sd-cs ↔ sd-main integratsiyasi](./sd-main-integration.md#models)
  ga qarang.
- **DBlar bo'ylab JOINlar taqiqlangan** — ishlab chiqarishda turli MySQL hostlari.
  Har-diler proyeksiyalarini olganidan keyin PHPda yig'ing.
- **Sxema siljishi** dilerlar o'rtasida haqiqiy. [sxema-siljishini boshqarish bo'limi](./sd-main-integration.md#schema-drift-handling)
  ga qarang.
- **Qator-darajasidagi izolyatsiya** yashirin: dilerning `d0_*` jadvallarida
  faqat o'sha dilerning ma'lumotlari bor, shuning uchun ulanish almashishi
  effekt sifatida so'rovni ko'lamlaydi.

## Yana qarang

- [Multi-DB ulanish](./multi-db.md) — ikki ulanish `protected/config/db.php` da qanday simlangan
- [sd-cs ↔ sd-main integratsiyasi](./sd-main-integration.md) — chuqur tahlil
- [sd-main · Asosiy ERD](../data/erd.md) — diler tomonidagi ma'lumotlar modeli
- [sd-main · Sxema ma'lumotnomasi](../data/schema-reference.md) — ustun-darajasidagi ma'lumotnoma
