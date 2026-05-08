---
sidebar_position: 6
title: Паттерны jQuery / AJAX
audience: New frontend developers
summary: Стандартные паттерны jQuery + AJAX, используемые в views sd-main — server-side fetch DataTables, fancybox-модалка, сабмит формы, загрузка файла, polling, debounced-фильтр. Copy-paste рецепты из существующего кодбейза.
topics: [jquery, ajax, datatables, fancybox, modal, polling, frontend-patterns]
---

# Паттерны jQuery / AJAX

Фронтенд sd-main — это **jQuery + Yii server-rendered views**. SPA-фреймворка
нет. Каждый интерактивный экран следует одному из паттернов ниже —
копируйте от ближайшего существующего примера.

## Почему jQuery (всё ещё)

- Крошечная зависимость поверх входящего jQuery 1.10.
- Работает без build-пайплайна.
- Каждый существующий view использует его — выигрывает консистентность.

Если нужна более богатая интерактивность — встройте Angular-«остров»
([ng-modules](./ng-modules.md)) — не вводите сюда React / Vue.

## Паттерн 1 — DataTables server-side fetch

Хлеб-и-масло каждой list-страницы.

```js
$(function () {
  const table = $('#orders-table').DataTable({
    serverSide: true,
    processing: true,
    ajax: {
      url: '/orders/list/getData',
      data: (d) => {
        d.from   = $('#from').val();
        d.to     = $('#to').val();
        d.status = $('#status').val();
      },
    },
    columns: [
      { title: '#',         data: 'id' },
      { title: 'Order',     data: 'order_id' },
      { title: 'Date',      data: 'date',   render: formatDate },
      { title: 'Client',    data: 'client_name' },
      { title: 'Sum',       data: 'summa',  render: formatMoney, className: 'text-right' },
      { title: 'Status',    data: 'status', render: renderPill },
      { title: '',          data: null,     render: renderActions, orderable: false },
    ],
    order: [[2, 'desc']],
    pageLength: 25,
    lengthMenu: [25, 50, 100],
  });

  $('#apply').on('click', () => table.ajax.reload(null, false));
});
```

Сервер возвращает:

```json
{
  "draw": 1,
  "recordsTotal": 1247,
  "recordsFiltered": 312,
  "data": [{ "id": 1, "order_id": "O-…", … }]
}
```

## Паттерн 2 — Fancybox-модалка

```js
$('.js-edit').on('click', function (e) {
  e.preventDefault();
  $.fancybox.open({
    src: this.href,        // URL of the edit form HTML
    type: 'ajax',
    opts: {
      afterShow: () => bindFormHandlers('#edit-form'),
      afterClose: () => $('#orders-table').DataTable().ajax.reload(null, false),
    },
  });
});
```

Сервер возвращает partial-HTML view формы. После сохранения закройте
модалку и перезагрузите родительскую таблицу.

Библиотека: `js_plugins/fancybox2`.

## Паттерн 3 — Async-сабмит формы

```js
function bindFormHandlers(selector) {
  $(selector).on('submit', function (e) {
    e.preventDefault();
    const $f = $(this);
    $.post($f.attr('action'), $f.serialize())
      .done((res) => {
        if (res.success) {
          noty({ text: 'Saved', type: 'success' });
          $.fancybox.close();
        } else {
          showFormErrors($f, res.errors);
        }
      })
      .fail(() => noty({ text: 'Server error', type: 'error' }));
  });
}
```

`noty` — toast-библиотека (`js_plugins/noty`).

## Паттерн 4 — Confirm-модалка перед деструктивным действием

```js
$('.js-delete').on('click', function (e) {
  e.preventDefault();
  const id = $(this).data('id');
  if (!confirm(`Cancel order #${id}?`)) return;
  $.post(`/orders/list/cancel/${id}`)
    .done((res) => {
      if (res.success) {
        $('#orders-table').DataTable().ajax.reload(null, false);
        noty({ text: `Order #${id} cancelled`, type: 'success' });
      }
    });
});
```

Для более богатого подтверждения — используйте fancybox-модалку с
кастомным шаблоном вместо браузерного `confirm`.

## Паттерн 5 — Debounced-фильтр (live-поиск)

```js
let timer;
$('#search').on('input', function () {
  clearTimeout(timer);
  timer = setTimeout(() => {
    $('#orders-table').DataTable().ajax.reload(null, false);
  }, 300);
});
```

300 мс — стандартный debounce.

## Паттерн 6 — Polling статуса

Для долго-выполняющихся задач (экспорт в Excel, EDI-сабмит, большие
импорты):

```js
function pollStatus(jobId) {
  $.get(`/jobs/status/${jobId}`)
    .done((res) => {
      if (res.status === 'done')   onDone(res);
      else if (res.status === 'failed') onFailed(res);
      else setTimeout(() => pollStatus(jobId), 2000);
    });
}
```

Каденс 2 секунды. Останавливайте на терминальном статусе. Сервер
включает поле `progress` (0–100) для прогресс-бара.

## Паттерн 7 — Загрузка файла (drag-drop, фото)

```js
const $drop = $('#drop-zone');
$drop.on('dragover', (e) => e.preventDefault());
$drop.on('drop', function (e) {
  e.preventDefault();
  const fd = new FormData();
  for (const f of e.originalEvent.dataTransfer.files) fd.append('files[]', f);
  $.ajax({
    url: '/inventory/photo/upload',
    type: 'POST',
    data: fd,
    processData: false,
    contentType: false,
    xhr: function () {
      const xhr = new window.XMLHttpRequest();
      xhr.upload.addEventListener('progress', (ev) => {
        if (ev.lengthComputable) updateProgressBar(ev.loaded / ev.total);
      });
      return xhr;
    },
    success: () => $('#photos').load('/inventory/photo/list'),
  });
});
```

## Паттерн 8 — Цепочка селектов

```js
$('#country').on('change', function () {
  const cid = $(this).val();
  $.get('/directory/cities', { country: cid })
    .done((cities) => {
      const $city = $('#city').empty();
      cities.forEach((c) => $city.append(`<option value="${c.id}">${c.name}</option>`));
      $city.trigger('change');
    });
});
```

Используется при редактировании клиента, агента, назначении маршрута.

## Паттерн 9 — Поисковые селекты chosen.js

```js
$('select.searchable').chosen({ width: '100%', search_contains: true });
```

Библиотека: `js_plugins/chosen`. Используйте для любого `<select>` с
> 10 опциями.

## Паттерн 10 — Графики (Highcharts)

```js
Highcharts.chart('chart-container', {
  chart: { type: 'column' },
  title: { text: 'Sales by week' },
  xAxis: { categories: data.weeks },
  yAxis: { title: { text: 'Amount' } },
  series: [
    { name: 'Plan', data: data.plan },
    { name: 'Fact', data: data.fact },
  ],
});
```

Библиотека: `js_plugins/jquery-highcharts-10.3.3`. Сервер возвращает
chart-shaped JSON через AJAX-эндпоинт.

## Анти-паттерны

- ❌ Загрузка > 5 000 строк в DataTable client-side. Используйте
  `serverSide: true`.
- ❌ Сборка HTML конкатенацией строк в длинных блоках. Используйте
  template-tag или маленький хелпер.
- ❌ `$.ajax({ async: false })` — блокирует UI-поток.
- ❌ Хранение состояния в DOM `data-*` вместо JS-переменных на
  долгоживущих экранах.
- ❌ Использование `alert()` / `confirm()` для production-UX. Используйте
  fancybox-модалку.

## Хелперы / утилиты

| Функция | Где | Назначение |
|---------|-----|------------|
| `formatMoney(n)` | `js/format.js` | Форматирование валюты по `params.numberFormat` |
| `formatDate(s)` | `js/format.js` | Дата в локали тенанта |
| `noty({...})` | `js_plugins/noty/jquery.noty.js` | Toast |
| `renderPill(s)` | `js/render.js` | Разметка status-pill |
| `renderActions(row)` | `js/render.js` | Меню действий строки `⋮` |
