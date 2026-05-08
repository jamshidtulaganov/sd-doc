---
sidebar_position: 3
title: Модули
---

# Модули sd-billing

## `api` — входящие интеграции

Принимает webhooks и machine-to-machine вызовы от платёжных шлюзов,
1C, SD-app, партнёрских систем и админских инструментов.

| Подмодуль | Назначение |
|-----------|---------|
| `Click` | prepare/confirm шлюза Click |
| `Payme` | Payme JSON-RPC |
| `Paynet` | Paynet SOAP (`extensions/paynetuz`) |
| `License` | Endpoint, защищённые захардкоженным `TOKEN`, для запроса/обновления лицензий |
| `Sms` | Входящие SMS webhooks (DLR) |
| `Host` | Колбэки статуса сервера от `sd-main` |
| `Quest` | Кастомные quest-endpoints |
| `Info` | Публичная информация / health |
| `Maintenance` | Утилиты cleaner / миграции |

Авторизация различается по контроллеру:
- `LicenseController::TOKEN` — захардкоженная константа.
- `ClickController` — проверка подписи шлюза (`checkSign`).
- `PaymeController` — проверка HMAC Payme.
- Несколько endpoints логинятся как фиксированный пользователь через `new UserIdentity("sd","sd")`
  (например, `actionBuyPackages`, `actionExchange`).

API-ответы используют хелперы `sendSuccessResponse` / `sendFailResponse`,
определённые в `application.modules.api.components.*`.

## `dashboard` — внутренний админ-UI

Главный экран operations-команды. Списки дилеров, дистрибьюторов,
платежей, подписок, графики, фиксы для зависших записей.

## `operation` — доменный CRUD

Где случается большинство write-трафика. Владеет:

- Пакетами
- Подписками
- Платежами
- Тарифами
- Чёрным списком
- Уведомлениями

## `partner` — портал самообслуживания

Партнёры (`ROLE_PARTNER`) логинятся сюда, чтобы видеть своих дилеров и доходы.
Ограничены модулями `partner` и `directory` + `dashboard/dashboard/index`
+ `site/*` через `PartnerAccessService::checkAccess`. (В данный момент эта
проверка **закомментирована** в base-контроллере — см. страницу мин
безопасности.)

## `cashbox`

Кассы и offline-источники платежей. Отслеживает переводы между кассами
и расход.

## `report`

Отчётные экраны — медленные агрегаты, часто экспорт через PHPExcel.

## `setting`

Настройки приложения + viewer системного лога.

## `notification` — in-app

In-app уведомления (иконка-колокольчик в дашборде).

## `sms`

SMS-шаблоны + отправка. Провайдеры:

- **Eskiz** (`notify.eskiz.uz`) для UZ
- **Mobizon** для KZ

Захардкоженные креды живут в `protected/components/Sms.php` (мина
безопасности — см. отдельную страницу).

## `bonus`

Логика бонусов / скидок. Квартальные роллапы.

## `access`

Сетка прав на пользователя: `AccessUser`, `AccessOperation`,
`AccessRelation`. У операций бит-флаги доступа:

```
DELETE = 8
SHOW   = 4
UPDATE = 2
CREATE = 1
```

`Access::has($operation, $type_access)` — проверка; `Access::check()`
бросает `CHttpException(403)` при промахе. Админы (`ROLE_ADMIN` или
`IS_ADMIN`) короткозамыкают на allow.

## `directory`

Справочники / справочные данные (города, страны, валюты, типы
пакетов и т. п.).

## `dbservice`

Утилиты обслуживания БД — массовые фиксы, ad-hoc миграции данных,
диагностические запросы.
