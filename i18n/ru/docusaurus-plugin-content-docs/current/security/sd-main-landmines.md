---
sidebar_position: 6
title: sd-main — ловушки безопасности
---

# sd-main — ловушки безопасности и эксплуатации

Эта страница зеркалит [sd-billing security landmines](../sd-billing/security-landmines.md) для CRM дилера **sd-main**. Пункты — находки из аудита документации 2026-05, основанные на чтении исходников в `/Users/jamshid/projects/salesdoctor/sd-main`. В каждой строке — severity, где это живёт, и целевое исправление.

| # | Проблема | Severity | Где | Целевое исправление |
|---|-------|----------|-------|------------|
| 1 | **MD5-хеширование паролей — нет fallback на bcrypt** | Critical | `protected/components/UserIdentity.php:26` (`md5($this->password) === $user->PASSWORD`); `protected/models/User.php:199, 208` (пишет `md5($PASSWORD)`); `User.php:449` (валидация) | Мигрировать на `password_hash()` (bcrypt). Прозрачный апгрейд при следующем успешном логине. Прежнее утверждение в `auth-and-roles.md` о том, что "bcrypt for new users" активен, было неверным. |
| 2 | **Ноль тестов в проекте** | High | `composer.json` не содержит PHPUnit; единственные файлы `*Test.php` — вендорные из `Gumlet\ImageResize` под `protected/extensions/image2/test/` и не подключены ни к чему | Поднять phpunit; начать с переходов `OrderService` и различия per-line defect / whole-order reject (см. `api/api-v3-mobile/index.md`). |
| 3 | **Нет CI** | High | Нет `.github/workflows/`, нет `.gitlab-ci.yml`, нет конфига test-runner | Подключить phpunit (#2) к CI. Добавить lint-проверку для Mermaid-диаграмм (см. `package.json` `lint:mermaid` в sd-docs). |
| 4 | **Нет healthcheck-эндпоинта приложения** | Medium | Нет маршрутов `/healthz`, `actionHealth` или `actionPing` нигде в `protected/`. Smoke-тест в прежнем deployment-документе со ссылкой на `GET /healthz` был выдачей желаемого за действительное. | Добавить минимальный `SiteController::actionHealthz`, возвращающий 200 + JSON с DB-ping. Добавить в allow-list nginx для проб k8s/orchestrator. |
| 5 | **Нет автоматизации деплоя** | Medium | Нет `deploy.sh`, нет `Makefile`, нет `infra/smoke.sh`, нет `.github/workflows/deploy*` | Задокументировать реальный rollout (теперь в `devops/deployment.md`). Добавить скрипт `bin/deploy`, кодифицирующий его. |
| 6 | **Хардкод dev-кредов в документации** | Low | `docs/project/local-setup.md` поставляет `jamshid / secret` для MySQL и `root / root` для phpMyAdmin | Перейти на нейтральный плейсхолдер (`sd_dev / sd_dev`) и сослаться на `.env.example`. |
| 7 | **PHP 7.3 EOL** | High | `Dockerfile` фиксирует PHP 7.3 (security-патчи прекратились в декабре 2021) | См. [ADR 0001 — keep Yii 1](../adr/yii1-stay.md) для пути обновления до PHP 8.2 с compat-патченным Yii 1.1. |

## Поток репортинга

Когда вы обнаруживаете новую проблему:

1. Откройте тикет в трекере (label `security`).
2. Если эксплуатируется в production, пометьте **P0** и пингуйте
   security-канал перед мержем фикса.
3. Добавьте регрессионный тест перед фиксом — но см. #2 выше (возможно,
   придётся сначала поднять PHPUnit).
4. Добавьте строку в эту таблицу со статусом (Open / In progress / Closed).

## Defence-in-depth (текущее состояние)

Пока пункты выше открыты, компенсирующие меры снижают риск:

- WAF перед всеми эндпоинтами sd-main.
- Сессионные пулы изолированы по поддоменам (префикс `HTTP_HOST` в `redis_session`).
- Изоляция БД на тенанта (DB-per-customer, см. [Мультитенантность](../architecture/multi-tenancy.md)).
- IP allow-list на `api/billing/license` (один IP на сегодня; см. sd-billing landmine #4).

## Чего нельзя

- ❌ Не добавляйте новые колонки или пути на основе MD5.
- ❌ Не добавляйте новые эндпоинты под `api/` или `api2/` — они заморожены. Используйте `api3` (мобильный) или `api4` (онлайн).
- ❌ Не отгружайте dev-креды в коммитимые файлы конфигов.
- ❌ Не утверждайте, что healthcheck-эндпоинт существует, в deploy/runbook документации, пока не закрыт #4.

## См. также

- [sd-billing security landmines](../sd-billing/security-landmines.md) — страница ловушек родственного проекта; некоторые пункты пересекаются.
- [security/auth-and-roles](./auth-and-roles.md) — текущий статус MD5 задокументирован под парольной политикой.
- [quality/testing](../quality/testing.md) — реальное состояние тестов (никакого).
- [devops/deployment](../devops/deployment.md) — реальное состояние деплоя (вручную).
