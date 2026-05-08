---
sidebar_position: 13
title: Справочник API (входящие)
audience: Backend-инженеры, интеграционные партнёры, ops
summary: Полный перечень всех контроллеров и actions в sd-billing/protected/modules/api — схема авторизации, форма payload, форма ответа и call site для каждого endpoint. Включает Click, Payme, Paynet, License, Sms, Host, Info, Quest, App, Api1C.
topics: [api, license, click, payme, paynet, sms, host, info, quest, 1c, sd-billing]
---

# Справочник API (входящие)

Все endpoints из `sd-billing/protected/modules/api/`. Это
**входящая** поверхность — то, что другие системы (sd-main дилеров, платёжные шлюзы, 1C, инструменты партнёров) вызывают у sd-billing.

> Исходящие вызовы (sd-billing → sd-main дилера, sd-billing → sd-cs)
> описаны в [Кросс-проектной интеграции](../architecture/cross-project-integration.md).

## Схемы авторизации в общих чертах

Модуль api использует **пять различных схем авторизации**, по одной на
контроллер (а иногда на action). Когда добавляете endpoint, придерживайтесь существующей схемы контроллера, в котором работаете — не смешивайте.

| Схема | Где | Что означает |
|--------|-------|---------------|
| **Общий статический `TOKEN`** | `LicenseController` | `$_POST['token']` должен совпадать с константой `LicenseController::TOKEN` |
| **Псевдо-пользователь `sd/sd`** | `SmsController::init` | Автоматически логинит `User(LOGIN='sd')`; всё последующее считается «авторизованным» |
| **Логин в теле запроса** | `Api1CController::checkAuth` | JSON-тело содержит `auth: {login, password}`; `password` — MD5 |
| **Bearer token** | `HostController`, части `AppController` | `Authorization: Bearer <User.TOKEN>` после первичного обмена `actionAuth` |
| **Подпись шлюза** | `ClickController`, `PaymeController`, `PaynetController` | Проверка HMAC / sign по каждому шлюзу |
| **HTTP Basic** | `QuestController` | `Authorization: Basic …` |

> ⚠️ Общий `LicenseController::TOKEN` **захардкожен в исходниках**.
> См. [мины безопасности](./security-landmines.md). То же предупреждение касается
> любого использования `new UserIdentity("sd","sd")`.

## Конфигурация модуля

`api` зарегистрирован в `protected/config/main.php` как и другие модули.
Маршруты разрешаются как
`/api/<controller>/<action>` (например, `/api/license/buyPackages`,
`/api/click`, `/api/payme`).

---

## 1. `LicenseController` — `/api/license/*`

Auth: захардкоженный `const TOKEN = "...";`, проверяется как `$_POST['token']`. Общий пользователь, под которым логинятся такие вызовы — обычно `UserIdentity("sd","sd")`.

Самый используемый контроллер во всём модуле api. Вызывается каждым sd-main дилера всякий раз, когда дилер взаимодействует с пакетами или балансом.

| Action | Method | Body | Returns | Notes |
|--------|--------|------|---------|-------|
| `actionIndex` | `POST /api/license` | `{token, dealer}` | `{balance, minAmount, currency, credit_limit, credit_date, …}` | Legacy — комментарий в файле `// old, we should delete it` |
| `actionIndexBatch` | `POST /api/license/indexBatch` | `{token, dealers[]}` | то же, батчем | |
| `actionPackages` | `POST /api/license/packages` | `{token, dealer}` | `[{package_id, name, type, price, currency, …}]` | Фильтрация по `Diler.COUNTRY_ID`, `CURRENCY_ID`, demo-флагу |
| `actionBotPackages` | `POST /api/license/botPackages` | то же | пакеты только для ботов (`bot_order`, `bot_report`) | |
| `actionHalfPackages` | `POST /api/license/halfPackages` | то же | полумесячные/частичные пакеты | |
| `actionBuyPackages` | `POST /api/license/buyPackages` | `{token, dealer, packages[], date?}` | `{success, balance, subscriptions[]}` | **Денежно-движущий вызов.** Вставляет строки `Subscription` + отрицательный `Payment(TYPE=license)`. См. [Поток подписок](./subscription-flow.md). |
| `actionChangePackage` | `POST /api/license/changePackage` | `{token, dealer, sub_id, new_package_id}` | `{success, …}` | Перерасчёт дней пропорционально |
| `actionRevise` | `POST /api/license/revise` | `{token, dealer, from, to}` | снимок сверки | |
| `actionDistrRevise` | `POST /api/license/distrRevise` | `{token, distr, from, to}` | сверка на уровне дистрибьютора | |
| `actionPayments` | `POST /api/license/payments` | `{token, dealer}` | недавние строки `Payment` | |
| `actionCheckMin` | `POST /api/license/checkMin` | `{token, dealer}` | `{ok\|fail, min_summa}` | Проверяет `BALANS ≥ MIN_SUMMA` |
| `actionBonusPackages` | `POST /api/license/bonusPackages` | `{token, dealer}` | строки бонусного каталога | |
| `actionExchangeable` | `POST /api/license/exchangeable` | `{token, dealer}` | подписки, доступные к обмену | |
| `actionExchange` | `POST /api/license/exchange` | `{token, dealer, src_sub_id, dst_package_id}` | новые строки `Subscription` | Переносит неиспользованные дни одного пакета на другой |
| `actionDeleteOne` | `POST /api/license/deleteOne` | `{token, dealer, sub_id}` | `{success}` | Софт-удаляет одну подписку |

### Поведение `init`

```php
public function init() {
    $this->date = date("Y-m-d");
    if (DateHelper::validateDate($_POST["date"], "Y-m-d")) {
        $this->date = $_POST["date"];
    }
}
```

Передавайте `date` в теле, когда часы дилера в другом часовом поясе
(Казахстан против Узбекистана и т. п.).

### Проверка токена

Каждое action вызывает `auth()`, который проверяет `self::TOKEN != $_POST['token']`
и в случае несовпадения сразу прерывается. Сегодня нет ротации токенов на каждого вызывающего.

---

## 2. `ClickController` — `/api/click`

Auth: **HMAC-подпись** со стороны Click, проверяется через `ClickTransaction::checkSign`.

Click обращается к одному endpoint с полем `action`, которое управляет prepare/confirm.

| `action` | Фаза | Эффект |
|----------|-------|--------|
| `0` (prepare) | резервирование | Вставка `ClickTransaction` (state = prepared) |
| `1` (confirm) | расчёт | Установка state = confirmed, вставка `Payment(TYPE_CLICKONLINE)`, `Diler::deleteLicense()`, `Diler::refresh()` |

Идемпотентность: повторный `prepare` или `confirm` возвращает тот же
ответ без вставки нового `Payment` (state-машина `ClickTransaction`
защищает от этого).

Коды ошибок (через `ClickController::send`):

| Код | Значение |
|------|---------|
| `0` | success |
| `-1` | ошибка проверки подписи |
| `-2` | некорректный `amount` |
| `-3` | action не найден |
| `-4` | уже оплачено |
| `-5` | дилер не найден |
| `-6` | транзакция не найдена |
| `-7` | срок транзакции истёк |
| `-8` | транзакция БД не удалась |
| `-9` | прочее |

См. [Платёжные шлюзы · Click flow](./payment-gateways.md#click-flow-canonical) для sequence-диаграммы.

---

## 3. `PaymeController` — `/api/payme`

Auth: **HMAC** Payme через заголовок `Authorization`, проверяется внутри
`api/helpers/PaymeHelper`.

Один JSON-RPC endpoint, диспетчеризация по `method`:

| Метод Payme | Эффект |
|--------------|--------|
| `CheckPerformTransaction` | Валидирует дилера и сумму, без записи в БД |
| `CreateTransaction` | Вставляет `PaymeTransaction(state=created)` |
| `PerformTransaction` | Устанавливает state = performed, вставляет `Payment(TYPE_PAYMEONLINE)`, проводит расчёт |
| `CancelTransaction` | Откат |
| `CheckTransaction` | Чтение состояния |
| `GetStatement` | Range-запрос для сверки |

Ошибки следуют контракту JSON-RPC ошибок Payme.

Тело контроллера короткое (`PaymeController.php:16`) — почти вся
логика живёт в `PaymeHelper` и модели `PaymeTransaction`.

---

## 4. `PaynetController` — `/api/paynet`

Auth: SOAP / WS-Security через расширение `paynetuz`
(`protected/extensions/paynetuz/`). Шаблон учётных данных живёт в
`_constants.php`.

Это SOAP-endpoint, не REST. Шлюз Paynet обращается к soap-endpoint с вызовами
`Pay`, `Status`, `Cancel`; контроллер сбрасывает каждый
в `PaynetTransaction` и (при успехе) в строку
`Payment(TYPE_PAYNETONLINE)`.

---

## 5. `Api1CController` — `/api/api1C/*` (интеграция с 1C)

Auth: **логин в теле запроса** — JSON-тело должно содержать
`auth: {login, password}`. Пароль соответствует `User.PASSWORD = MD5($pwd)`.

Входящая интеграция с 1C — большой контроллер (985 строк), затрагивающий импорт безналичных платежей и запросы подписок.

| Action | Method | Назначение |
|--------|--------|---------|
| `actionIndex` | `POST /api/api1C` | Health/auth check |
| `actionAddCashless` | `POST /api/api1C/addCashless` | Массовый импорт безналичных платежей из 1C; вставляет `Payment(TYPE_CASHLESS)` с ключом `(inn, payment_1c)` для идемпотентности |
| `actionGetSubscriptionsOld` | `POST /api/api1C/getSubscriptionsOld` | Legacy-экспорт подписок — оставлен для старых развёртываний 1C |
| `actionGetSubscriptions` | `POST /api/api1C/getSubscriptions` | Текущий экспорт подписок |

Форма запроса для `addCashless`:

```json
{
  "auth": {"login": "...", "password": "..."},
  "content": [
    {
      "inn": "123456789",
      "payment_1c": "PAY-2026-00001",
      "amount": 100000,
      "currency": "UZS",
      "date": "2026-05-08",
      "comment": "..."
    }
  ]
}
```

Ответ включает массив `errors[]` по каждой строке, чтобы частичные успехи были видны на стороне 1C.

---

## 6. `SmsController` — `/api/sms/*`

Auth: `init()` автоматически логинит как `User(LOGIN='sd', PASSWORD='sd')`.

| Action | Method | Назначение |
|--------|--------|---------|
| `actionPackages` | `POST /api/sms/packages` | Список покупаемых SMS-пакетов для валюты |
| `actionBuySmsPackage` | `POST /api/sms/buySmsPackage` | Списать `BALANS`, привязать SMS-пакет к дилеру |
| `actionBoughtSmsPackages` | `POST /api/sms/boughtSmsPackages` | История покупок дилера |
| `actionCreateTemplate` | `POST /api/sms/createTemplate` | Зарегистрировать шаблон в Eskiz |
| `actionCheckingTemplates` | `POST /api/sms/checkingTemplates` | Синхронизация локальных ↔ Eskiz шаблонов |
| `actionOne` | `POST /api/sms/one` | Отправить одну SMS |
| `actionSend` | `POST /api/sms/send` | Массовая отправка через `Sms::multy` |
| `actionSendingForward` | `POST /api/sms/sendingForward` | Пересылка очереди отправок |
| `actionCallback` | `POST /api/sms/callback?host=…` | Webhook доставки от Eskiz |

Подробности SMS-провайдеров (Eskiz UZ, Mobizon KZ): см.
[Уведомления · SMS](./notifications.md#7-sms--eskiz-uz-and-mobizon-kz).

---

## 7. `HostController` — `/api/host/*`

Auth: **Bearer token** (`User.TOKEN`) из предыдущего обмена `actionAuth`.

Используется внутренними мониторинговыми инструментами / дашбордами, которым нужен список
«кто куда задеплоен».

| Action | Method | Назначение |
|--------|--------|---------|
| `actionAuth` | `POST /api/host/auth` | `{login, password}` (MD5) → `{token}` (обновляет `User.TOKEN`) |
| `actionActiveHosts` | `GET /api/host/activeHosts` | Все строки `Diler` со `STATUS = ACTIVE` |
| `actionActivities` | `GET /api/host/activities?date_from=&date_to=` | Параллельный multi-curl fan-out по активным хостам для подтягивания их активности. |
| `actionActivityByHost` | `GET /api/host/activityByHost?host=` | Детали по одному хосту |

Учтите: `actionActivities` открывает десятки исходящих curl параллельно через
`curl_multi_init` — будьте осторожны при добавлении хостов; контейнеру sd-billing
нужен сетевой egress, чтобы достучаться до каждого дилера.

---

## 8. `InfoController` — `/api/info/*`

Auth: смешанная. Большинство actions **псевдо-публичные** (без токена) и полагаются на
сетевой контроль доступа.

| Action | Method | Назначение |
|--------|--------|---------|
| `actionIndex` | `POST /api/info` | Поиск дилера по `dealer_id` или `host`; возвращает `{id, host, domain, is_demo, status, db_name, db_status, max_id, min_id}` |
| `actionSdToken` | `POST /api/info/sdToken` | Выдать / обновить общий «sd» токен, используемый некоторыми внутренними инструментами |
| `actionChangePassword` | `POST /api/info/changePassword` | Сменить пароль `User` — редкий админ-путь |

Относитесь к `actionIndex` как к **обнаружению дилеров** — каждый, кто может достучаться до
endpoint, может перечислить хосты дилеров. Ужесточите доступ перед широкой публикацией.

---

## 9. `QuestController` — `/api/quest/*`

Auth: **HTTP Basic** (`Authorization: Basic …`) на `actionIndex`,
**параметр `token` в query** на `actionDetail`.

| Action | Method | Назначение |
|--------|--------|---------|
| `actionIndex` | `GET /api/quest` | Снимок KPI — price, idokon, ibox, np, churn, upSall, netSale, golden |
| `actionDetail` | `GET /api/quest/detail?token=…` | Деталь по пользователю; параметр query `User.TOKEN` |

Это в основном внутренняя поверхность, смежная с партнёрским порталом — редко
затрагивается в обычных биллинговых потоках.

---

## 10. `AppController` — `/api/app/*`

Auth: `actionAuth` выполняет логин и возвращает `token`; последующие
actions ищут `User.TOKEN`.

| Action | Method | Назначение |
|--------|--------|---------|
| `actionAuth` | `POST /api/app/auth` | Login, возвращает `{success, token}` |
| `actionGetPrinters` | `POST /api/app/getPrinters` | Реестр принтеров для desktop-приложения |
| `actionExecute` | `POST /api/app/execute` | Универсальный диспетчер — используется desktop-приложением для запуска предзаготовленных операций |

Используется операторским desktop-приложением, не дилерами.

---

## 11. Общие хелперы ответа

Все контроллеры в итоге рендерят через один из:

| Хелпер | Где определён | Форма |
|--------|---------------|-------|
| `sendSuccessResponse($data)` | `application.modules.api.components.*` | `{success: true, data: <data>}` |
| `sendFailResponse($errors[, $extra])` | то же | `{success: false, errors: [...], data?: <extra>}` |
| `_sendSuccessResponse($code, $data, $errors)` (`Api1CController`) | inline | специфичный для 1C — другая форма |
| `response($payload, $statusCode = 200)` (`HostController`) | inline | устанавливает HTTP-статус, JSON-кодирует |
| `json($data)` | controller-base | JSON, die после print |
| `send($data, $errorCode, $click=false, …)` (`ClickController`) | inline | специфичный для Click — см. код |

Формы **не консистентны** между контроллерами — придерживайтесь той,
которая уже используется в трогаемом контроллере, не смешивайте.

---

## 12. Логирование

`Logger::writeLog2($data, $is_req, $path)` пишет JSON-файлы по дню по action
в `log/<controller>/<YYYY-MM-DD>/`. Активно используется
gateway- и 1C-контроллерами.

> ⚠️ Санитизируйте входы перед логированием. Никогда не логируйте детали карты, полные
> payload Payme/Click или пароли дилеров. Текущая
> реализация логирует сырое `$body` в нескольких местах — исправляйте
> по случаю, по мере того как вы их трогаете.

---

## 13. Соглашения о кодах ошибок / статусах

API-поверхность предшествует унифицированному соглашению. Сегодня:

| Источник | Что вы увидите |
|--------|-----------------|
| `LicenseController` | HTTP 200 с телом `{success: false, errors: [...]}` почти для всех ошибок; 4xx редок |
| `Api1CController` | `_sendFailResponse(401, [...])` для auth, `_sendSuccessResponse(200, ...)` иначе |
| `HostController` | корректные HTTP-коды (`401`, `200`, `400`) |
| `Click`, `Payme`, `Paynet` | специфичные конверты ошибок шлюза |

При добавлении новых actions предпочитайте стиль `HostController` (реальные HTTP-
коды) — это правильный паттерн на будущее. Не рефакторите
остальные без явного одобрения; downstream-вызывающие зависят от
старых форм.

---

## 14. Чек-лист по харденингу

- [ ] Заменить `LicenseController::TOKEN` на подписанные JWT по каждому вызывающему.
- [ ] Заменить `new UserIdentity("sd","sd")` на явные сервисные
      аккаунты с минимальными строками `Access`.
- [ ] Добавить rate limits (логин, callback шлюзов) на уровне WAF.
- [ ] Стандартизировать форму ответа `HostController` — и мигрировать
      вызывающих в течение релизного окна.
- [ ] Санитизировать входы `Logger::writeLog2` по всему `Api1CController`.
- [ ] Добавить структурированный аудит запрос/ответ по каждому endpoint (заменить
      ad-hoc JSON-файлы по дням).

## См. также

- [Платёжные шлюзы](./payment-gateways.md) — потоки Click/Payme/Paynet в деталях.
- [Подписка и лицензирование](./subscription-flow.md) — что на самом деле делает `actionBuyPackages`.
- [Уведомления](./notifications.md) — детали `SmsController` + Eskiz/Mobizon.
- [Кросс-проектная интеграция](../architecture/cross-project-integration.md) — исходящая сторона провода.
- [Мины безопасности](./security-landmines.md) — захардкоженные токены, MD5-пароли, отключённая проверка партнёров.
