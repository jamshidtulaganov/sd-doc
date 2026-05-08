---
sidebar_position: 5
title: Ma'lumotlar izolyatsiyasi
---

# Tenantlar o'rtasida ma'lumotlar izolyatsiyasi

Tenantlarni alohida tutish uchun uchta qatlam birlashadi:

1. **Tarmoq** — har bir subdomen o'zining vhost i; subdomenlararo
   chaqiriqlar uchun CORS yopiq.
2. **Ma'lumotlar bazasi** — tenant bo'yicha DB. `TenantContext` har bir
   so'rovda DB ni tanlaydi; orqaga qaytish yo'q.
3. **Kesh** — `redis_app` dagi har bir kalit `t:{db}:` bilan prefikslanadi
   (filial-scoped ma'lumotlar uchun esa `f:{filial}:`), shuning uchun
   tenantlararo kalit to'qnashuvlari strukturaviy jihatdan imkonsiz.

## Tahdid modeli

Biz himoyalanadigan real hujumlar:

- **Buzilgan tenant ma'lumotlari** → faqat o'z DB sini ko'ra oladi.
- **Buzilgan ilova jarayoni** → agar PHP RCE bo'lsa, hujumchi barcha
  tenantlarni o'qishi mumkin. Himoya: WAF + konteyner sandbox + minimal
  o'rnatilgan maxfiy ma'lumotlar.
- **O'chirishdan keyin eskirgan kesh** → ko'pi bilan 600 s eskirgan
  RBAC; buyurtmalar / to'lovlar hech qachon keshlanmaydi.

## Anti-patternlar

- ❌ `Yii::app()->cache->get(...)` ni to'g'ridan-to'g'ri — tenant
  prefiksini chetlab o'tadi.
- ❌ Sukut bo'yicha DB ga murojaat qiladigan qattiq kodlangan
  `connectionString`.
- ❌ Barcha tenantlar bo'ylab loop qiladigan, lekin bitta umumiy kesh
  kalitiga yozadigan cron ishi.
