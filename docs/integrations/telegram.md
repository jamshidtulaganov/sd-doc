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

## Controller endpoints in sd-main

There are three Telegram-related controllers; each surfaces a different
bot/audience.

### `onlineOrder/TelegramController` — B2B / WebApp bot

File: `protected/modules/onlineOrder/controllers/TelegramController.php`.
Live routes:

| Action | Route | Purpose |
|--------|-------|---------|
| `index` | `POST /onlineOrder/telegram/index` | Webhook entry — the main B2B bot |
| `webApp` | `POST /onlineOrder/telegram/webApp` | WebApp init handshake |
| `sendMessage` | `POST /onlineOrder/telegram/sendMessage` | Outbound message helper |
| `handleWebappBotUpdates` | `POST /onlineOrder/telegram/handleWebappBotUpdates` | Updates for the WebApp bot |
| `handleInoutReportBotUpdates` | `POST /onlineOrder/telegram/handleInoutReportBotUpdates` | Updates for the inbound/outbound report bot |
| `handleSupplierInoutReport` | `POST /onlineOrder/telegram/handleSupplierInoutReport` | Updates for the supplier report bot |

All tagged `noRbac` — gating is by the `X-Telegram-Bot-Api-Secret-Token`
header (must verify before parsing).

### `report/TelegramController` — report bot

File: `protected/modules/report/controllers/TelegramController.php`.

| Action | Route | RBAC |
|--------|-------|------|
| `bot` | `POST /report/telegram/bot` | `noRbac` (webhook) |
| `index` | `GET /report/telegram/index` | `operation.reports.telegram` (admin UI) |

### `api/TelegramBotController` — legacy/test surface

File: `protected/modules/api/controllers/TelegramBotController.php`.

| Action | Route | RBAC |
|--------|-------|------|
| `index` | `POST /api/telegramBot/index` | `noRbac` |
| `test` | `GET /api/telegramBot/test` | `noRbac` |

Use **only** for legacy bot endpoints; new bots go to
`onlineOrder/TelegramController`.

### Admin-side Telegram report config

`settings/TelegramReportController` — `index`, `delete`,
`toggleGroupStatus` under `/settings/telegramReport/...`. Used to manage
Telegram report subscriptions per tenant.

## See also

- [`onlineOrder` module](../modules/onlineOrder.md) — owns the B2B
  WebApp bot.
- [`report` module](../modules/report.md) — owns the report bot.
