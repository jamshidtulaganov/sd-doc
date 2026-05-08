---
sidebar_position: 2
title: Соглашения
---

# Соглашения

## Именование файлов

- **Модели** — `PascalCase`, одна модель на файл, имя файла = имя класса
  (`Order.php`, `Client.php`).
- **Контроллеры** — `PascalCaseController.php` (`OrderController.php`).
- **Модули** — папка `lowerCamel/` с `<Name>Module.php` внутри
  (`onlineOrder/OnlineOrderModule.php`).
- **Views** — папка на контроллер, `lowercase.php` на действие
  (`views/order/list.php`).
- **Jobs** — `<Name>Job.php`, наследующий `BaseJob`.

## Соглашения базы данных

- **Таблицы** — префикс `d0_` (настраивается per-tenant через
  `tablePrefix` в `main.php`). Всегда используйте плейсхолдер
  `{{prefix}}` в raw SQL.
- **Primary keys** — `ID` для новых таблиц, но legacy миксует
  `<entity>_ID` заглавными буквами (например, `ORDER_ID`, `CLIENT_ID`).
  Не боритесь с существующими соглашениями — соответствуйте таблице,
  которую трогаете.
- **Audit-колонки** — `CREATE_BY`, `CREATE_AT`, `UPDATE_BY`, `UPDATE_AT`,
  `TIMESTAMP_X`. Заполняются хуками сохранения `BaseFilial`.
- **Soft delete / inactive** — `ACTIVE` (`Y` / `N`) на большинстве
  legacy-таблиц.
- **Filial scoping** — каждая tenant-скоупированная таблица имеет
  `FILIAL_ID`. Модели наследуются от `BaseFilial`, который автоматически
  применяет скоуп.

## PHP code style

- **PSR-12**, отступ четыре пробела.
- **Строгая типизация** *не* включена в кодовой базе (PHP 7.3-эра кода).
  Не добавляйте `declare(strict_types=1)` в существующие файлы.
- **Docblocks** на публичных методах (помогает IDE-intellisense поверх
  магических свойств CActiveRecord).
- **Одинарные кавычки** для строк, если не происходит интерполяция.

## Соглашения git

- Имена веток: `feat/<short-desc>`, `fix/<short-desc>`, `chore/...`.
- Заголовок коммита: imperative present tense, ≤ 72 символа.
- Один PR = одно логическое изменение. Избегайте смешивания рефакторинга и фичи.
- Миграции идут в собственный коммит.
