---
sidebar_position: 5
title: Локальная установка
---

# Локальная установка sd-cs

sd-cs — это old-school host-PHP Yii 1.1 приложение. В репозитории нет Dockerfile или
compose-стека — вы обслуживаете `index.php` из локального webroot
(nginx/Apache + PHP-FPM, или `php -S` для быстрой проверки). Реальные
болевые точки — **два MySQL-подключения** и **Redis-кэш**.

## Предусловия

- PHP 7.3+ с расширениями `pdo_mysql`, `mbstring`, `gd`, `bcmath`, `redis`
- Composer
- Локальный MySQL 5.7/8.x
- Достижимый Redis (входящий конфиг указывает на `10.0.0.11:6379` —
  см. подводный камень внизу)
- Webroot, обслуживаемый из директории клонированного репозитория
- `sd-main`, уже запущенный локально (Option A seed ниже зависит от него)

## Поднять

```bash
git clone <repo> sd-cs
cd sd-cs

# 1. Pull the framework + phpspreadsheet into vendor/
composer install

# 2. Bootstrap runtime / assets / uploads folders (one-time)
php default_folders.php

# 3. Provide DB credentials (gitignored)
cp protected/config/db_sample.php protected/config/db.php
$EDITOR protected/config/db.php
```

Затем направьте document root вашего веб-сервера на директорию репозитория. С
`php -S` для быстрой smoke-проверки:

```bash
php -S 127.0.0.1:8090 index.php
```

Для nginx проект полагается на то, что `$_SERVER['DOCUMENT_ROOT']` резолвится в
корень репозитория (см. `protected/config/main.php`) — убедитесь, что `root` в вашем
server-блоке указывает туда, а не на поддиректорию.

## Сконфигурировать два DB-подключения

`db_sample.php` поставляется с двумя stub-подключениями. Хосты-плейсхолдеры
(`localhost1`, `localhost2`) — намеренные напоминания, что два
подключения могут — и в production живут — на разных MySQL-хостах.

### `db` — собственная схема `cs_*`

Собственная база данных sd-cs. Создайте её локально:

```sql
CREATE DATABASE cs_dev CHARACTER SET utf8mb4;
```

Вам понадобится дамп или источник миграций для таблиц `cs_*`; спросите в
`#sd-cs`, если в SharePoint нет свежего санитизированного дампа.

### `dealer` — swappable `d0_*` подключение

Это БД sd-main дилера. DSN компонента `dealer`
**заменяется в runtime**, когда sd-cs читает у другого дилера (см.
`docs/sd-cs/multi-db.md`); значение в `db.php` — это просто дефолт.

Рабочий `db.php` для локальной разработки:

```php
return [
    'db' => [
        'connectionString' => 'mysql:host=127.0.0.1;dbname=cs_dev',
        'emulatePrepare'   => true,
        'username'         => 'root',
        'password'         => 'secret',
        'charset'          => 'utf8',
        'tablePrefix'      => 'cs_',
    ],
    'dealer' => [
        'class'            => 'CDbConnection',
        'connectionString' => 'mysql:host=127.0.0.1;dbname=sd_main',
        'emulatePrepare'   => true,
        'username'         => 'root',
        'password'         => 'secret',
        'charset'          => 'utf8',
        'tablePrefix'      => 'd0_',
    ],
];
```

## Seed-данные

### Option A — направить `dealer` на локальную БД sd-main (рекомендуется)

Если у вас sd-main работает локально по `docs/project/local-setup.md`,
у вас уже есть схема `sd_main` с таблицами `d0_`. Просто направьте
`dealer` на неё (DSN выше). Никакой дополнительной работы по дампам.

Если sd-main в Docker, выставьте 3306 на хост (дефолтный compose-
файл это делает) и используйте `127.0.0.1:3306` из sd-cs.

### Option B — два MySQL-инстанса

При тестировании cross-host случая (форма реального production) запустите второй
MySQL на другом порту (например, 3307) и направьте `dealer` на него. Вам
понадобится `d0_` дамп от реального дилера — синтетического seed нет.

### Option C — read-only staging-реплика

Направьте `dealer` на DSN staging-реплики, если у вас есть доступ. Относитесь как к
read-only; sd-cs в основном — репортер и не должен писать в любом случае.

## Тестовый логин

`cs_*` пользователи живут в `cs_users` (или эквиваленте — проверьте seed-дамп).
В репозитории нет фиксированных дефолтных учётных данных; кто бы ни
давал вам дамп, тот даст и логин.

## Smoke-проверка multi-DB swap

Минимальный контроллер, доказывающий, что оба подключения работают:

```php
public function actionPing() {
    $cs = Yii::app()->db->createCommand('SELECT 1')->queryScalar();
    $dl = Yii::app()->dealer->createCommand(
        'SELECT COUNT(*) FROM d0_users'
    )->queryScalar();
    echo "cs={$cs}, dealer_users={$dl}";
}
```

Зайдите на `/site/ping` (или куда вы это привязали). Если `cs=1`, но `dealer_users`
бросает ошибку, ваши DSN/учётки `dealer` неверные.

## Типичные подводные камни

- **Redis hostname захардкожен.** `protected/config/main.php` ставит
  `redis_cache.hostname = '10.0.0.11'`. Локально вам почти наверняка
  нужно `127.0.0.1`. Не коммитьте изменение — оставьте как локальную
  правку, или переопределяйте через gitignored `params.php`-стиль include.
- **Сессии идут через Redis.** При недоступном Redis логин тихо
  падает (`CCacheHttpSession` не может persist`ить). Проверьте логи
  `protected/runtime` сначала, когда логин выглядит сломанным.
- **Оверрайды в `themes/classic/` побеждают.** Если правка view не показывается,
  проверьте, не затеняет ли `themes/classic/views/<...>` файл, который вы редактировали.
- **Permissions на `assets/`.** `default_folders.php` создаёт её 0777, но
  если ваш webserver-юзер отличается от вашего CLI-юзера, регенерируйте или
  `chown` после запуска bootstrap.
- **Кросс-БД JOIN запрещены.** `db` и `dealer` могут быть на разных
  хостах в production, поэтому JOIN между ними ломаются в реальных окружениях,
  даже когда работают локально. Агрегируйте в PHP.
- **`YII_DEBUG` переключается sentinel-файлом.** `touch DEBUG` в
  корне репозитория включает debug-режим (см. `index.php`).

## См. также

- [Multi-DB connection](./multi-db.md) — как работает swap `dealer` в runtime
- [`docs/project/local-setup.md`](../project/local-setup.md) — установка sd-main, из которой sd-cs читает в Option A
