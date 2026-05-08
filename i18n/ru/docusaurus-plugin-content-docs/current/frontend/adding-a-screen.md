---
sidebar_position: 4
title: Добавление экрана
audience: Frontend engineers shipping their first end-to-end change
summary: Буквальный рецепт добавления нового серверно-рендерного экрана — экшен контроллера, файл view, JS/CSS для страницы, пункт в сайдбаре, ключи i18n. Используйте как чек-лист для любой новой страницы.
topics: [frontend, recipes, first-pr]
---

# Добавление экрана

Это рецепт самого частого фронтенд-изменения: новая серверно-рендерная
страница (или новый экшен на существующей странице). Идите по нему сверху
вниз для своего первого PR.

Эта страница предполагает, что вы уже сделали
[Старт работы](./getting-started.md) и прочитали
[Соглашения](./conventions.md).

Для существенных интерактивных виджетов (live-карта, drag-drop канбан) —
добавляйте Angular-«остров» вместо этого, см.
[ng-modules](./ng-modules.md) и
[Обзор фронтенда](./overview.md#when-to-add-an-angular-island).

## Сначала решите

Ответьте на эти вопросы до того, как писать код. Каждый выбор фиксирует
дальнейший путь.

| Вопрос | Дефолтный ответ |
|--------|-----------------|
| Top-level или внутри модуля? | Если экран принадлежит области-фиче (заказы, склад и т.д.), кладите в `protected/modules/<name>/`. Если экран действительно сквозной — top-level. |
| Новый контроллер или новый экшен? | Новый экшен на существующем контроллере, где это возможно. Новый контроллер — только когда URL действительно представляет новый ресурс. |
| Layout? | `main.php` (по умолчанию — топ-бар + сайдбар). Используйте `column1.php` для очень широких таблиц. См. [Yii views · Layouts](./yii-views.md#layouts). |
| Видим какими ролями? | Сопоставьте роль из иерархии прав (RBAC). Пункты сайдбара — role-driven. См. [Безопасность · RBAC](../security/rbac.md). |
| Новые i18n-ключи? | Да — см. [Шаг 6](#6-add-i18n-keys). |

## Рецепт

### 1. Добавьте (или переиспользуйте) экшен контроллера

Для top-level-экрана контроллер живёт в `protected/controllers/`. Для
модульного экрана — в `protected/modules/<name>/controllers/`.

```php
// protected/modules/orders/controllers/OrderController.php
public function actionSummary()
{
    $rows = OrderService::summaryFor(Yii::app()->tenantContext);
    $this->render('summary', ['rows' => $rows]);
}
```

Соглашения ([Проектные соглашения](../project/conventions.md)):

- **Тонкие контроллеры**. Бизнес-логика живёт в `OrderService` или
  подобном, а не в контроллере.
- **Никаких inline-DB-записей**. Если экшен мутирует состояние,
  поставьте задачу в очередь (`BaseJob`) — см.
  [Jobs и шедулинг](../architecture/jobs-and-scheduling.md).
- **Соблюдайте tenant scoping**. Модели, унаследованные от `BaseFilial`,
  применяют его автоматически; сырой SQL должен включать
  tenant-предикат.

### 2. Создайте view-файл

```
protected/modules/orders/views/order/summary.php
```

Папка — имя контроллера (нижний регистр, без суффикса `Controller`);
файл — экшен (нижний регистр).

Минимальный view:

```php
<?php
/** @var array $rows */
$this->breadcrumbs = [
    Yii::t('orders', 'Orders') => ['/orders/order/list'],
    Yii::t('orders', 'Summary'),
];
?>

<h1><?= Yii::t('orders', 'Order summary') ?></h1>

<table class="table table-striped" id="orders-summary">
    <thead>
        <tr>
            <th><?= Yii::t('orders', 'Date') ?></th>
            <th><?= Yii::t('orders', 'Total') ?></th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($rows as $row): ?>
            <tr>
                <td><?= H::date($row['CREATE_AT']) ?></td>
                <td><?= Formatter::money($row['TOTAL']) ?></td>
            </tr>
        <?php endforeach; ?>
    </tbody>
</table>

<?php
Yii::app()->clientScript
    ->registerScriptFile('/js/orders-summary.js?v=' . VERSION);
?>
```

Заметки:

- `$this->breadcrumbs` обязательны при глубине больше 2
  ([UI · Page layout](../ui/page-layout.md)).
- `H` и `Formatter` — стандартные view-хелперы
  ([Yii views · Хелперы](./yii-views.md#helpers)).
- Оборачивайте каждую литерал-строку в `Yii::t('<category>', '...')`
  ([Соглашения · i18n во views](./conventions.md#i18n-in-views)).
- Query-параметр `<?= VERSION ?>` — для cache-busting на релизе, см.
  [Старт работы · Откуда реально берётся frontend-код](./getting-started.md#where-the-frontend-code-actually-comes-from).

### 3. Добавьте JS для конкретной страницы

Если странице нужен JS сверх того, что покрывают общие сниппеты,
положите его под `js/`:

```
js/orders-summary.js
```

Согласно [Соглашения · JS-файлы в `js/`](./conventions.md#js-files-in-js):

- Нижний регистр, page-specific имя.
- Оборачивайте инициализацию в `$(function(){ ... });` — нижняя
  планка — jQuery 1.10; никакого `let`, никаких arrow-функций в
  inline-скриптах (поддержка браузеров в legacy-парке непрощающая).
- Подключите все плагины из `js_plugins/`, от которых вы зависите
  (Chosen, fancybox2 и т.д.), зарегистрировав их во view *до* вашего
  page-specific файла.

### 4. Добавьте CSS для конкретной страницы (только если нужен)

```
css/orders-summary.css
```

Зарегистрируйте из view:

```php
Yii::app()->clientScript
    ->registerCssFile('/css/orders-summary.css?v=' . VERSION);
```

Не добавляйте новый файл просто чтобы задать два значения padding —
сначала расширьте существующие utility-классы.

### 5. Прокиньте URL и пункт меню

#### URL

Для внутренних URL модуля Yii-овский дефолтный роутинг обрабатывает
`/<module>/<controller>/<action>`. Если нужен более красивый маршрут —
добавьте правило в `urlManager.rules` файла
`protected/config/main_static.php` (согласно
[Структура проекта · Что где живёт](../project/structure.md#what-lives-where)).

#### Пункт сайдбара

Пункты сайдбара живут в `protected/views/partial/sidebar.php` (согласно
[Yii views · Папка](./yii-views.md#folder)).

Добавьте пункт, отгороженный соответствующей ролевой проверкой:

```php
<?php if (Yii::app()->user->checkAccess('order_read')): ?>
    <li>
        <a href="<?= $this->createUrl('/orders/order/summary') ?>">
            <?= Yii::t('orders', 'Summary') ?>
        </a>
    </li>
<?php endif; ?>
```

(Точные имена ролей подтвердите в
[Безопасность · RBAC](../security/rbac.md) — не выдумывайте новый
permission-ключ.)

### 6. Добавьте i18n-ключи

Откройте каталоги для каждой активной локали, в которой будет шипиться
экран:

```
protected/messages/ru/orders.php
protected/messages/en/orders.php
protected/messages/uz/orders.php
```

Каждый — массив `return ['Source string' => 'Translation', ...]`.
Добавьте ключи, использованные во view.

Если исходный язык — RU (большинство существующих каталогов такие),
ваш `ru` файл может маппить строку на саму себя — это нормально.

Согласно [Соглашения · i18n во views](./conventions.md#i18n-in-views),
вы можете шипить только в `ru` для RU-first фичи, но планируйте EN + UZ
внутри того же релиза.

### 7. Smoke-тест в браузере

Согласно [Старт работы · Smoke-тест чек-лист](./getting-started.md#smoke-test-checklist-first-session):

- [ ] DevTools → Network → Disable cache.
- [ ] Hard-refresh нового URL. Проверьте, что страница рендерится,
      нет 404 на `/js/orders-summary.js`, нет 404 на `/css/...`.
- [ ] Кликните каждый интерактивный элемент — сортировку таблицы,
      action-меню, любую модалку.
- [ ] Переключите локаль RU → EN → UZ — убедитесь, что каждая
      видимая строка меняется (нет фолбэков на исходный язык).
- [ ] Tail-ните `protected/runtime/application.log` — убедитесь,
      что ваш экшен не emit'ит warning'и или ошибки.
- [ ] Проверьте под non-admin ролью — убедитесь, что пункт сайдбара
      показывается только когда ролевая проверка проходит, а прямой
      переход по URL отдаёт 403.

## Рабочий пример для копирования

Для ванильного экрана list-with-filter — view списка заказов
канонический пример. Согласно
[UI · Каталог компонентов](../ui/component-catalog.md),
`protected/views/orders/list.php` иллюстрирует дефолтный паттерн
таблица + фильтры. Прочитайте его перед тем, как писать свой.

## Чек-лист для PR

Перед пушем:

- [ ] Экшен контроллера тонкий; логика в сервисе.
- [ ] У view есть breadcrumbs (если глубина > 2) и primary-action кнопка
      (если применимо), согласно [UI · Page layout](../ui/page-layout.md).
- [ ] Все видимые строки обёрнуты в `Yii::t()`.
- [ ] i18n-ключи присутствуют в каталогах `ru`, `en`, `uz`.
- [ ] Page-specific JS под `js/<area>.js` с `?v=` cache-bust.
- [ ] Пункт сайдбара огорожен ролью.
- [ ] Нет console-ошибок в DevTools (выше legacy-базовой линии).
- [ ] Нет новых записей в `application.log` от smoke-теста.
- [ ] Ветка названа `feat/<short-desc>`, одно логическое изменение
      (согласно [Соглашения · Git](../project/conventions.md#git-conventions)).

## Открытые вопросы / TODO

- **Подтвердите глобальную константу `VERSION`** — символ, используемый в
  `?v=`, может отличаться от этого имени. Проверьте вызов
  `registerScriptFile` в существующем view и скопируйте паттерн.
- **Нейминг permission-ключей** — `order_read` выше иллюстративен.
  Подтвердите реальные ключи в [Безопасность · RBAC](../security/rbac.md)
  перед копированием в PR.
- **Точный путь `sidebar.php`** — подтверждён как
  `protected/views/partial/sidebar.php` в [Yii views](./yii-views.md),
  но role-gating-хелпер в файле может отличаться от
  `Yii::app()->user->checkAccess(...)` в некоторых форках; повторяйте
  окружающий код.
