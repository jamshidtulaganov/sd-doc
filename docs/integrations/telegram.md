---
sidebar_position: 6
title: Telegram
---

# Telegram

Two surfaces:

1. **Telegram Bot** — order placement + notifications for B2B clients.
2. **Telegram WebApp** — embedded SPA that renders inside Telegram and
   talks to api4.

## Webhook

`POST /onlineOrder/telegram/webhook` — the bot's webhook handler. Verify
the `X-Telegram-Bot-Api-Secret-Token` header against the configured
secret before parsing.

## Bot commands

| Command | Meaning |
|---------|---------|
| `/start` | Sign in / link account |
| `/catalog` | Browse products |
| `/order` | Start an order |
| `/orders` | History |
| `/help` | Contact info |

## WebApp

Loaded from `/onlineOrder/webApp/index`. Authenticates with
`Telegram.WebApp.initData` (signed by Telegram) and exchanges it for an
api4 token.
