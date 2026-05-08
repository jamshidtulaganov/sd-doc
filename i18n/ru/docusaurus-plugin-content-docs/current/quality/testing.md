---
sidebar_position: 1
title: Тестирование
---

# Тестирование

## Обзор статуса

- **sd-main**: ноль тестов в проекте. PHPUnit нет. Директории `tests/` нет. CI нет.
- **sd-billing**: ноль тестов в проекте. PHPUnit не установлен. Подробный
  план развёртывания есть в `doc/TESTING_PLAN.md`, но Phase 0 не стартовал.
  CI нет.
- **sd-cs**: ноль тестов в проекте. PHPUnit нет. CI нет.

Иными словами: каждое изменение в каждом проекте проверяется руками против
staging или копии тенанта. Автоматизированного гейта тестов нигде нет.

## sd-main

### Что есть

- `composer.json` объявляет одну рантайм-зависимость (`minishlink/web-push`). Нет
  `require-dev`, нет `phpunit`.
- Нет `phpunit.xml` и нет директории `tests/`.
- `framework/test/` содержит встроенные `CTestCase`, `CDbTestCase`,
  `CWebTestCase`, `CDbFixtureManager` от Yii 1.1 — не используются.
- `protected/extensions/image2/test/ImageResizeTest.php` и
  `ImageResizeExceptionTest.php` существуют, но вендорные из upstream
  библиотеки `Gumlet\ImageResize` и не запускаются ничем в этом репо.
- `protected/vendor/vendor` — симлинк на
  `/var/www/novus/.../protected/vendor` — поломан на каждой машине,
  кроме production-хоста. Старый wiki-сниппет
  `./protected/vendor/bin/phpunit` локально не работает по этой причине.

### Как запускать

Запускать нечего.

### Пробелы покрытия

Всё. Нет тестов сервисного слоя, тестов контроллеров, тестов моделей,
smoke-тестов против api3 / api4.

## sd-billing

### Что есть

- `composer.lock` есть в корне репо **без `composer.json`** рядом
  (см. security-landmines пункт #7). Свежий клон не имеет вендорного
  PHPUnit; бинарь на production-хосте не воспроизводим.
- Нет `phpunit.xml`, нет директории `tests/`.
- `framework/test/` поставляет `CTestCase` / `CDbTestCase` /
  `CDbFixtureManager` от Yii 1.1 — не используются.
- Сервисные классы, которые *были бы* mockable, уже есть:
  `protected/components/TariffService.php`, `SystemLogService.php`,
  `SystemService.php`, `PartnerAccessService.php`.
- `doc/TESTING_PLAN.md` — канонический план для подключения тестов. Он
  определяет двухуровневую пирамиду (unit + integration), базу
  `billing_test`, фикстуры через `CDbFixtureManager` и характеризационные
  тесты для денежных путей (Click webhook flow, payment triggers,
  settlement command). Ничто из этого ещё не реализовано.

### Как запускать

Запускать нечего.

### Пробелы покрытия

Всё, с самыми высокорисковыми непокрытыми путями:

- `Diler::getBalans()` и `Diler::getTranBalans()`.
- DB-триггеры insert/update `Payment`
  (`m221114_070346_create_triggers_to_payment.php`).
- Webhook-флоу Click / Payme / Paynet / P2P / MBANK.
- Console-команда `settlement`.

См. `sd-billing/doc/TESTING_PLAN.md` Phase 4 для запланированного
порядка характеризации.

## sd-cs

### Что есть

- `composer.json` объявляет `phpoffice/phpspreadsheet` и `yiisoft/yii`.
  Нет `require-dev`, нет `phpunit`.
- Нет `phpunit.xml` и нет директории `tests/`.
- Нет фикстур.

### Как запускать

Запускать нечего.

### Пробелы покрытия

Всё. HQ-репорт пути и код экспорта в Excel не имеют никакого регрессионного
покрытия.

## CI

Ни в одном из трёх проектов нет CI. Нет `.github/workflows/`,
`.gitlab-ci.yml`, Bitbucket pipelines или test-таргетов на основе
`Makefile`. Единственные `Makefile`-файлы в любом дереве принадлежат
вендорным фронтенд-библиотекам (`vendors/bootstrap-datetimepicker`,
`vendors/flot-chart`).

## Конвенции при написании новых тестов

В дереве пока нет конвенции, которой можно следовать. Если стартуете тесты
в **sd-billing**, следуйте `doc/TESTING_PLAN.md` точно — он
определяет раскладку директорий (`tests/unit/`, `tests/integration/`,
`tests/fixtures/`, `tests/support/`), bootstrap-файлы, форму
`phpunit.xml.dist`, имена скриптов `composer test*`, паттерн AAA и
правило именования
`test<MethodName><ExpectedBehavior>When<Condition>`.

Для **sd-main** и **sd-cs** аналогичного плана нет — предложите
соответствующую раскладку в design-документе перед добавлением тестов.

Пока bootstrap проекта не приземлился, не добавляйте отдельные файлы
`*Test.php` под `protected/`: подхватывать их некому, и они тихо сгниют.

## См. также

- `sd-billing/doc/TESTING_PLAN.md` — единственный конкретный план-of-record.
- [`sd-billing/security-landmines.md`](../sd-billing/security-landmines.md)
  пункты #7 (отсутствующий `composer.json`) и #10 (тестовое покрытие в
  процессе наращивания).
- [`quality/contribution.md`](./contribution.md) для более широкого PR-флоу.
