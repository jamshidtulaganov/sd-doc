---
sidebar_position: 8
title: SMS-шлюз
---

# SMS-шлюз

Исходящие SMS через настроенного провайдера (Eskiz, Playmobile и т. д.).

## Конфигурация

На тенанта, в **Settings → SMS → Providers**:

| Поле | Примечания |
|------|------------|
| Провайдер | `eskiz`, `playmobile`, `custom` |
| API-ключ / логин | Учётные данные провайдера |
| Sender ID | Утверждённый альфа-отправитель |
| Дневной лимит | Мягкий лимит |

## Отправка

Шаблоны → `SmsTemplate`. Триггер-событие → ставится `SendSmsJob` →
HTTP-вызов провайдера → колбэк в `CallbackController` обновляет статус
доставки.

## DLR (квитанция о доставке)

`POST /sms/callback/index` — провайдер постит сюда. Обновите
`SmsMessage.STATUS` на одно из `pending / sent / delivered / failed`.

## Отчёт по стоимости

`SmsPackage` агрегирует использование; отображается в списке модуля SMS.
