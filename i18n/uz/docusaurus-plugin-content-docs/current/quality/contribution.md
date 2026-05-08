---
sidebar_position: 3
title: Hissa qo'shish
---

# Hissa qo'shish

## Workflow

1. **Ticket tanlang** loyiha bordida (Jira / Linear / GitHub).
2. **Branch**: `main` dan `feat/<short>` yoki `fix/<short>`.
3. **Amalga oshiring** — commit larni kichik va o'zini tushuntiruvchi
   qiling.
4. **Lokal testlar + lint** ni ishga tushiring.
5. **PR oching** `main` ga qarshi. PR shablonini to'ldiring.
6. **Ko'rib chiqish** kamida bitta maintainer tomonidan.
7. **Merge** yashil CI + 1 tasdiqdan keyin.
8. **Deploy** reliz poyezdi orqali.

AI/QA/PM sub-oqimlari uchun `claude-ai-assist`, `qa-process`,
`pm-workflow` skill lariga qarang.

## Mahalliy muhit

[Lokal sozlash](../project/local-setup.md) ga qarang.

## Yordam kerak bo'lgan sohalar

- MD5 parollardan migratsiya.
- `bootstrap/` ni utility CSS bilan almashtirish.
- `OrderService` o'tishlari uchun testlar yozish.
- `*.obsolete` fayllarni tozalash.
