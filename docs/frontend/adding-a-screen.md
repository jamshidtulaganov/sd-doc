---
sidebar_position: 4
title: Adding a screen
audience: Frontend engineers shipping their first end-to-end change
summary: A literal recipe for adding a new server-rendered screen — controller action, view file, page-specific JS/CSS, sidebar entry, i18n keys. Cite this as your checklist for any new page.
topics: [frontend, recipes, first-pr]
---

# Adding a screen

This is the recipe for the most common frontend change: a new
server-rendered page (or a new action on an existing page). Follow
it top to bottom for your first PR.

This page assumes you've already done [Getting started](./getting-started.md)
and read [Conventions](./conventions.md).

For substantial interactive widgets (live map, drag-drop kanban),
add an Angular island instead — see
[ng-modules](./ng-modules.md) and
[Frontend overview](./overview.md#when-to-add-an-angular-island).

## Decide first

Answer these before writing code. Each choice locks the path you'll
follow.

| Question | Default answer |
|----------|----------------|
| Top-level or in a module? | If the screen belongs to a feature area (orders, warehouse, etc.), put it in `protected/modules/<name>/`. If it's truly cross-cutting, top-level. |
| New controller or new action? | New action on an existing controller wherever possible. New controller only when the URL is genuinely a new resource. |
| Layout? | `main.php` (default — top bar + sidebar). Use `column1.php` for very wide tables. See [Yii views · Layouts](./yii-views.md#layouts). |
| Visible to which roles? | Match a role from the auth hierarchy (RBAC). Sidebar entries are role-driven. See [Security · RBAC](../security/rbac.md). |
| New i18n keys? | Yes — see [Step 6](#6-add-i18n-keys). |

## The recipe

### 1. Add (or reuse) the controller action

For a top-level screen, the controller lives in
`protected/controllers/`. For a module screen, it lives in
`protected/modules/<name>/controllers/`.

```php
// protected/modules/orders/controllers/OrderController.php
public function actionSummary()
{
    $rows = OrderService::summaryFor(Yii::app()->tenantContext);
    $this->render('summary', ['rows' => $rows]);
}
```

Conventions ([project Conventions](../project/conventions.md)):

- **Thin controllers**. Business logic lives in `OrderService` or
  similar, not the controller.
- **No DB writes inline**. If the action mutates state, queue a job
  (`BaseJob`) — see [Jobs and scheduling](../architecture/jobs-and-scheduling.md).
- **Honour tenant scoping**. Models inheriting from `BaseFilial`
  apply it automatically; raw SQL must include the tenant
  predicate.

### 2. Create the view file

```
protected/modules/orders/views/order/summary.php
```

Folder is the controller name (lowercased, no `Controller` suffix);
file is the action (lowercased).

A minimal view:

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

Notes:

- `$this->breadcrumbs` are mandatory beyond depth 2
  ([UI · Page layout](../ui/page-layout.md)).
- `H` and `Formatter` are the standard view helpers
  ([Yii views · Helpers](./yii-views.md#helpers)).
- Wrap every literal string in `Yii::t('<category>', '...')`
  ([Conventions · i18n in views](./conventions.md#i18n-in-views)).
- The `<?= VERSION ?>` query is for cache-busting on release —
  see [Getting started · Where the frontend code actually comes from](./getting-started.md#where-the-frontend-code-actually-comes-from).

### 3. Add page-specific JS

If the page needs JS beyond what shared snippets cover, drop it
under `js/`:

```
js/orders-summary.js
```

Per [Conventions · JS files in `js/`](./conventions.md#js-files-in-js):

- Lowercase, page-specific name.
- Wrap initialisation in `$(function(){ ... });` — jQuery 1.10
  is the floor; no `let`, no arrow functions in inline scripts
  (browser support across the legacy fleet is unforgiving).
- Reference any plugin from `js_plugins/` you depend on (Chosen,
  fancybox2, etc.) by registering it in the view *before* your
  page-specific file.

### 4. Add page-specific CSS (only if needed)

```
css/orders-summary.css
```

Register from the view:

```php
Yii::app()->clientScript
    ->registerCssFile('/css/orders-summary.css?v=' . VERSION);
```

Don't add a new file just to set two padding values — extend
existing utility classes first.

### 5. Wire up the URL and the menu

#### URL

For module-internal URLs, Yii's default routing handles
`/<module>/<controller>/<action>`. If you need a prettier route,
add a rule in `protected/config/main_static.php`'s
`urlManager.rules` (per
[Project structure · What lives where](../project/structure.md#what-lives-where)).

#### Sidebar entry

Sidebar items live in `protected/views/partial/sidebar.php` (per
[Yii views · Folder](./yii-views.md#folder)).

Add an item gated by the appropriate role check:

```php
<?php if (Yii::app()->user->checkAccess('order_read')): ?>
    <li>
        <a href="<?= $this->createUrl('/orders/order/summary') ?>">
            <?= Yii::t('orders', 'Summary') ?>
        </a>
    </li>
<?php endif; ?>
```

(Confirm the exact role names from
[Security · RBAC](../security/rbac.md) — don't invent a new
permission key.)

### 6. Add i18n keys

Open the catalogues for every active locale that the screen will
ship in:

```
protected/messages/ru/orders.php
protected/messages/en/orders.php
protected/messages/uz/orders.php
```

Each is a `return ['Source string' => 'Translation', ...]` array.
Add the keys you used in the view.

If the source language is RU (most existing catalogues are),
your `ru` file may map a string to itself — that's fine.

Per [Conventions · i18n in views](./conventions.md#i18n-in-views),
you may ship in `ru` only for an RU-first feature, but plan EN + UZ
within the same release.

### 7. Smoke-test in the browser

Per [Getting started · Smoke-test checklist](./getting-started.md#smoke-test-checklist-first-session):

- [ ] DevTools → Network → Disable cache.
- [ ] Hard-refresh the new URL. Confirm the page renders, no 404s
      on `/js/orders-summary.js`, no 404s on `/css/...`.
- [ ] Click every interactive element — table sort, action menu,
      any modal.
- [ ] Switch the locale from RU → EN → UZ — confirm every visible
      string changes (no fallthroughs to the source language).
- [ ] Tail `protected/runtime/application.log` — confirm no
      warnings or errors emitted by your action.
- [ ] Test as a non-admin role — confirm the sidebar item only
      appears when the role check passes, and a direct URL hit
      gets a 403.

## A working example to copy from

For a vanilla list-with-filter screen, the orders list view is the
canonical example. Per
[UI · Component catalog](../ui/component-catalog.md),
`protected/views/orders/list.php` exemplifies the default
table + filter pattern. Read it before writing your own.

## Checklist for the PR

Before you push:

- [ ] Controller action is thin; logic in a service.
- [ ] View has breadcrumbs (if depth > 2) and a primary-action button
      (if applicable) per [UI · Page layout](../ui/page-layout.md).
- [ ] All visible strings are wrapped in `Yii::t()`.
- [ ] i18n keys present in `ru`, `en`, `uz` catalogues.
- [ ] Page-specific JS is under `js/<area>.js` with `?v=` cache-bust.
- [ ] Sidebar entry is role-gated.
- [ ] No console errors in DevTools (above the legacy baseline).
- [ ] No new entries in `application.log` from a smoke test.
- [ ] Branch named `feat/<short-desc>`, single logical change
      (per [Conventions · Git](../project/conventions.md#git-conventions)).

## Open questions / TODO

- **Confirm the global `VERSION` constant** — the symbol used in
  `?v=` may differ from this name. Check an existing view's
  `registerScriptFile` call and copy the pattern.
- **Permission key naming** — `order_read` above is illustrative.
  Confirm the real keys live in
  [Security · RBAC](../security/rbac.md) before copying into a PR.
- **`sidebar.php` exact path** — confirmed as
  `protected/views/partial/sidebar.php` from
  [Yii views](./yii-views.md), but the role-gating helper used in
  the file may differ from `Yii::app()->user->checkAccess(...)`
  in some forks; mirror the surrounding code.
