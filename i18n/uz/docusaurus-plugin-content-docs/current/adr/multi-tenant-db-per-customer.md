---
sidebar_position: 3
title: ADR-0002 — Mijoz boshiga DB
---

# ADR 0002 — Multi-tenant: Mijoz boshiga DB

- Status: **Accepted**
- Date: 2023-04-02
- Deciders: Platform team

## Kontekst

Tenantlar hajm jihatidan keng farq qiladi (kuniga 50 dan 50,000 gacha
buyurtma). Ba'zilari ma'lumot rezidentligini talab qiladi. Backuplar
tenant-izolyatsiyalangan bo'lishi kerak. Biz "menga mening
ma'lumotlarimni bering" so'rovlarini cheklangan miqdordagi bosishlarda
qo'llab-quvvatlashimiz kerak.

Ko'rib chiqilgan variantlar:

1. Bitta MySQL DB da tenant boshiga schema.
2. **Mijoz boshiga DB.**
3. `tenant_id` ustunlari bilan bitta umumiy schema.
4. Tenant boshiga Mongo collection (rad etilgan — jamoada document
   store yo'q).

## Qaror

**Mijoz boshiga DB.** Tenant boshiga bitta MySQL ma'lumotlar bazasi;
subdomen so'rov vaqtida DB ni tanlaydi.

## Oqibatlar

- Tenant boshiga backup/restore arzimas.
- DB qatlamida tenantlararo ma'lumot oqishi strukturaviy jihatdan
  imkonsiz.
- Tenant boshiga sozlash (indekslar, partitsiyalash).
- Migratsiyalar barcha tenant DB lariga fan-out qilinishi kerak.
- Tenantlararo aggregat hisobot uchun alohida analitika quvuri kerak.
- App qatlamida ulanish-pool aylanishi — persistent ulanishlar orqali
  hal qilinadi.
