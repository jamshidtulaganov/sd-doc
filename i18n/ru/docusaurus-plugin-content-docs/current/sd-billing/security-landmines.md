---
sidebar_position: 9
title: Мины безопасности
---

# Мины безопасности (и устранение)

Эта страница **только для внутреннего использования**, но живёт в документации, чтобы контрибьюторы
её видели. Каждый пункт перечисляет severity, где живёт проблема, и
целевой фикс. Источник истины по статусу —
`sd-billing/doc/IMPROVEMENTS.md`.

| # | Проблема | Severity | Где | Целевой фикс |
|---|-------|----------|-------|------------|
| 1 | **MD5-хэширование паролей** | Critical | `UserIdentity::authenticate`, `User::generatePassword` (только sd-billing — статус sd-main см. [security/auth-and-roles](../security/auth-and-roles.md)) | Мигрировать на `password_hash()` (bcrypt). Прозрачное обновление при следующем успешном логине. |
| 2 | **Захардкоженные SMS / Telegram секреты в коде** | Critical | `protected/components/Sms.php` (Eskiz creds, Mobizon API key); `SiteController::actionLogin` (Telegram bot token) | Перенести в env-переменные; немедленно ротировать публично утёкшие токены. |
| 3 | **`Distr::getFilter()` SQL-инъектируем** | Critical | string-интерполирует пользовательские данные | Перевести вызывающих на `protected/helpers/QueryBuilder.php`. Не расширять поверхность `Distr::getFilter()` пока. |
| 4 | **`Controller::hasAccessIpAddress()` короткозамыкается** | High | Первая строка — `return true;`, IP-allowlist ниже недостижим. | Заменить на реальную проверку allowlist; добавить тесты. |
| 5 | **`YII_DEBUG = true` в `index.php`** | High | Stack-trace`и утекают в production-ответах. | Управлять из env (`YII_DEBUG=getenv('APP_DEBUG')`). |
| 6 | **`Curl::run` использует `CURLOPT_TIMEOUT => 0`** | Medium | Исходящие вызовы могут зависнуть навсегда. | Установить разумные дефолты (15 с) + retry. |
| 7 | **`composer.lock` без `composer.json`** | Medium | Состояние зависимостей не воспроизводимо. | Восстановить `composer.json` (Phase 0 в `doc/TESTING_PLAN.md`). |
| 8 | **Проверка доступа партнёра закомментирована** | High | `protected/components/Controller.php:63` | Раскомментировать; проверить тестами. |
| 9 | **License `TOKEN` — захардкоженная константа** | High | `protected/modules/api/controllers/LicenseController.php` | Перенести в env; ротировать; добавить подпись по источнику. |
| 10 | **Покрытие тестами наращивается** | n/a | Считайте непротестированные пути высокорискованными. | Следовать `doc/TESTING_PLAN.md`. |

## Поток репортинга

Когда обнаруживаете новую проблему:

1. Открыть тикет в трекере проекта (метка `security`).
2. Если эксплуатируемо в проде, помечать **P0** и пинговать security-
   канал перед мерджем фикса.
3. Добавить регрессионный тест перед фиксом (по жёсткому правилу §7 CLAUDE.md).
4. Добавить строку в `doc/IMPROVEMENTS.md` со статусом (Open / In progress /
   Closed).

## Defence-in-depth (текущее состояние)

Пока вышеперечисленные пункты открыты, компенсирующие контролы снижают риск:

- WAF перед всеми endpoints sd-billing.
- Регулярное OS-уровневое патчинг хостов контейнеров.
- Network-level allowlist для вызывающих `api/license`.
- Read-only DB-пользователь для аналитических реплик.

## Чего не делать

- Не вводить ещё одну колонку MD5-пароля.
- Не добавлять новых захардкоженных секретов.
- Не расширять вызывающих `Distr::getFilter()` — мигрировать их.
- Не вставлять Telegram-bot токены или Eskiz-креды в тикеты, Slack
  или описания PR.
