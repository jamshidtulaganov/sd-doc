---
sidebar_position: 7
title: Авторизация и доступ
---

# Авторизация и доступ (sd-billing)

:::note Область
Эта страница описывает роли в **sd-billing** (проект подписок/лицензирования). Числовые ID ролей здесь НЕ совпадают с sd-main. По RBAC в sd-main см. [security/auth-and-roles](../security/auth-and-roles.md). Эти два enum независимы — никогда не сопоставляйте целые числа между проектами.
:::

Два слоя контроля доступа живут бок о бок:

## 1. Сессионный логин

`PhpAuthManager` + `WebUser` + `UserIdentity` — классическая Yii session-
авторизация. Хранение пароля — **MD5(plaintext)** — известная мина. См.
[мины безопасности](./security-landmines.md).

## 2. Сетка доступов на бит-флагах

`Access::has($operation, $type_access)` проверяет права пользователя
по `d0_access_user` с бит-флагами:

```
DELETE = 8
SHOW   = 4
UPDATE = 2
CREATE = 1
```

`Access::check()` бросает `CHttpException(403)` при промахе. Два
коротких замыкания:

- `User.IS_ADMIN = 1` — обходит все проверки.
- `User.ROLE = ROLE_ADMIN (3)` — обходит все проверки.

## Роли

Определены как константы `User::ROLE_*`:

| ID | Имя |
|----|------|
| 3 | `ADMIN` |
| 4 | `MANAGER` |
| 5 | `OPERATOR` |
| 6 | `API` |
| 7 | `SALE` |
| 8 | `MENTOR` |
| 9 | `KEY_ACCOUNT` |
| 10 | `PARTNER` |

## Ограничения партнёра

`PartnerAccessService::checkAccess` ограничивает `ROLE_PARTNER`:

- модулем `partner`
- модулем `directory`
- `dashboard/dashboard/index`
- `site/*`

Проверка **в данный момент закомментирована** в
`protected/components/Controller.php:63` — это значит, что партнёры могут заходить
дальше, чем должны, до тех пор пока эта строка не будет раскомментирована. Считайте это
высокоприоритетным пунктом безопасности.

## Авторизация API

API-endpoints используют смешанные схемы:

| Контроллер | Auth |
|------------|------|
| `LicenseController` | Захардкоженная константа `TOKEN` в файле |
| `ClickController` | Проверка подписи в стиле Click |
| `PaymeController` | HMAC-заголовок Payme |
| `PaynetController` | SOAP / WS-Security в расширении `paynetuz` |
| Несколько других | `new UserIdentity("sd","sd")` — фиксированный логин |

Перенесите захардкоженные токены в переменные окружения и ротируйте после
публикации.

## Сессии

Yii по умолчанию `CHttpSession` (file-backed). Подумайте о переходе на DB-
или Redis-backed сессию, если приложение масштабируется горизонтально.

## Logout

`SiteController::actionLogout` уничтожает сессию. Концепта device-token
здесь нет — sd-billing — это только web-admin.

## Rate limiting

Не реализован. Throttling логина и IP-лимиты — рекомендуемый
харденинг — пока полагайтесь на WAF перед приложением.
