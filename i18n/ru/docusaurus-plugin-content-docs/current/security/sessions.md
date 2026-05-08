---
sidebar_position: 4
title: Сессии
---

# Сессии

## Хранилище

`CCacheHttpSession` поверх Redis db0. Настроено с
`keyPrefix = HTTP_HOST`. Два эффекта:

1. У каждого поддомена свой пул сессий.
2. `FLUSHDB 0` на Redis уничтожает все сессии (используйте только осторожно).

## TTL

По умолчанию 7200 с (2 ч). Поднимите в `main_local.php` при необходимости:

```php
'session' => [ 'class' => 'CCacheHttpSession', 'cacheID' => 'redis_session', 'timeout' => 14400 ],
```

## Куки

- HttpOnly = да
- Secure = да (production)
- SameSite = Lax

## Выход

`Site/logout` уничтожает сессию и очищает auth-куки. Для
мобильного приложения `POST /api3/logout/index` очищает строку device-token,
но клиент также должен сбросить свой bearer-токен.
