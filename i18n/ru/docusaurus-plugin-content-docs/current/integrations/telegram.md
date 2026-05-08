---
sidebar_position: 6
title: Telegram
---

# Telegram

Две поверхности:

1. **Telegram Bot** — оформление заказов + уведомления для B2B-клиентов.
2. **Telegram WebApp** — встроенный SPA, рендерящийся внутри Telegram и
   обращающийся к api4.

## Вебхук

`POST /onlineOrder/telegram/webhook` — обработчик вебхука бота. Проверьте
заголовок `X-Telegram-Bot-Api-Secret-Token` против настроенного секрета
перед парсингом.

## Команды бота

| Команда | Значение |
|---------|----------|
| `/start` | Войти / привязать аккаунт |
| `/catalog` | Просмотр продуктов |
| `/order` | Начать заказ |
| `/orders` | История |
| `/help` | Контактная информация |

## WebApp

Загружается из `/onlineOrder/webApp/index`. Аутентифицируется через
`Telegram.WebApp.initData` (подписан Telegram) и обменивает их на
api4-токен.
