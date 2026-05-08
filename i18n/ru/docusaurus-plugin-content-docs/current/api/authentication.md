---
sidebar_position: 2
title: Аутентификация
---

# Аутентификация

## На основе токенов (api3, api4)

### Вход

```http
POST /api3/login/index
Content-Type: application/x-www-form-urlencoded

login=agent1&password=plainPassword&deviceToken=fcm_or_apns_token
```

Успешный ответ:

```json
{
  "success": true,
  "agent_id": 42,
  "user_id": 17,
  "diler_id": "ACME",
  "fio": "Иванов И.И.",
  "role": 4,
  "phone_number": "+998901234567",
  "token": "..."
}
```

Ошибка:

```json
{ "success": false, "error": "Неправильный логин или пароль" }
```

### Авторизация последующих вызовов

Передавайте `token` (и `deviceToken` для некоторых эндпоинтов) в каждом
запросе — как поле формы или заголовок `Authorization: Bearer ...`:

```http
POST /api3/order/create
Authorization: Bearer <token>
Content-Type: application/json

{ "client_id": "...", "lines": [...] }
```

Токены **per-device**: вход со второго устройства инвалидирует первое,
если многоустройственный режим явно не включён.

## Лицензионные ограничения

`User::hasSystemActive(int $systemId)` проверяется при входе. Примеры ID:

| ID | Система |
|----|---------|
| 1 | Веб-админка |
| 2 | Аудит |
| 4 | Мобильный агент |
| 5 | Онлайн-магазин |

Если срок действия лицензии истёк, вход возвращает:

```json
{ "success": false, "error": "Срок лицензии программы истёк" }
```

## Выход

```http
POST /api3/logout/index
Authorization: Bearer <token>
```

Возвращает `{ "success": true }`. Очищает device token на стороне сервера.
