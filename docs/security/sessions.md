---
sidebar_position: 4
title: Sessions
---

:::warning Stub
This page is a placeholder. The content is incomplete — verify against source before relying on it. See [the audit's stub-backfill list](#) for status.
:::

# Sessions

## Storage

`CCacheHttpSession` over Redis db0. Configured with
`keyPrefix = HTTP_HOST`. Two effects:

1. Each subdomain has a separate session pool.
2. `FLUSHDB 0` on Redis nukes every session (use only with care).

## TTL

Default 7200 s (2 h). Bump in `main_local.php` if needed:

```php
'session' => [ 'class' => 'CCacheHttpSession', 'cacheID' => 'redis_session', 'timeout' => 14400 ],
```

## Cookies

- HttpOnly = yes
- Secure = yes (production)
- SameSite = Lax

## Logging out

`Site/logout` destroys the session and clears auth-related cookies. For
mobile, `POST /api3/logout/index` clears the device token row but the
client must also discard its bearer token.
