---
sidebar_position: 6
title: Telegram
---

# Telegram

Ikki yuza:

1. **Telegram Bot** — B2B mijozlari uchun buyurtma berish + bildirishnomalar.
2. **Telegram WebApp** — Telegram ichida ko'rsatiladigan va api4 bilan
   gaplashadigan o'rnatilgan SPA.

## Webhook

`POST /onlineOrder/telegram/webhook` — botning webhook ishlovchisi.
Tahlildan oldin `X-Telegram-Bot-Api-Secret-Token` sarlavhasini sozlangan
maxfiy kalitga nisbatan tekshiring.

## Bot buyruqlari

| Buyruq | Ma'nosi |
|--------|---------|
| `/start` | Kirish / hisobni bog'lash |
| `/catalog` | Mahsulotlarni ko'rish |
| `/order` | Buyurtmani boshlash |
| `/orders` | Tarix |
| `/help` | Bog'lanish ma'lumotlari |

## WebApp

`/onlineOrder/webApp/index` dan yuklanadi. `Telegram.WebApp.initData`
(Telegram tomonidan imzolangan) bilan autentifikatsiya qiladi va uni
api4 tokeniga almashtiradi.
