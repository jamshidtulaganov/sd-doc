---
sidebar_position: 6
title: jQuery / AJAX patterns
audience: New frontend developers
summary: The standard jQuery + AJAX patterns used across sd-main views — DataTables server-side fetch, fancybox modal, form submit, file upload, polling, debounced filter. Copy-paste recipes from the existing codebase.
topics: [jquery, ajax, datatables, fancybox, modal, polling, frontend-patterns]
---

# jQuery / AJAX patterns

The sd-main frontend is **jQuery + Yii server-rendered views**. There
is no SPA framework. Every interactive screen follows one of the
patterns below — copy from the closest existing example.

## Why jQuery (still)

- Tiny dependency on top of the bundled jQuery 1.10.
- Works without a build pipeline.
- Every existing view uses it — consistency wins.

If you need richer interactivity, embed an Angular island
([ng-modules](./ng-modules.md)) — don't introduce React / Vue here.

## Pattern 1 — DataTables server-side fetch

The bread-and-butter of every list page.

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

Server side returns:

```json
{
  "draw": 1,
  "recordsTotal": 1247,
  "recordsFiltered": 312,
  "data": [{ "id": 1, "order_id": "O-…", … }]
}
```

## Pattern 2 — Fancybox modal

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

Server returns a partial HTML view of the form. After save, close
the modal and reload the parent table.

Library: `js_plugins/fancybox2`.

## Pattern 3 — Async form submit

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

`noty` is the toast library (`js_plugins/noty`).

## Pattern 4 — Confirm modal before destructive action

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

For a richer confirm, use a fancybox modal with a custom template
instead of the browser `confirm`.

## Pattern 5 — Debounced filter (live search)

```js
let timer;
$('#search').on('input', function () {
  clearTimeout(timer);
  timer = setTimeout(() => {
    $('#orders-table').DataTable().ajax.reload(null, false);
  }, 300);
});
```

300 ms is the standard debounce.

## Pattern 6 — Polling for status updates

For long-running jobs (export to Excel, EDI submission, large
imports):

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

2-second cadence. Stop on terminal status. Server includes a
`progress` field (0–100) for a progress bar.

## Pattern 7 — File upload (drag-drop, photos)

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

## Pattern 8 — Chained selects

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

Used by client edit, agent edit, route assignment.

## Pattern 9 — chosen.js searchable selects

```js
$('select.searchable').chosen({ width: '100%', search_contains: true });
```

Library: `js_plugins/chosen`. Use for any `<select>` with > 10
options.

## Pattern 10 — Charts (Highcharts)

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

Library: `js_plugins/jquery-highcharts-10.3.3`. Server returns
chart-shaped JSON via an AJAX endpoint.

## Anti-patterns

- ❌ Loading > 5,000 rows into a DataTable client-side. Use
  `serverSide: true`.
- ❌ Building HTML by string concatenation in long blocks. Use a
  template tag or a small helper.
- ❌ `$.ajax({ async: false })` — blocks the UI thread.
- ❌ Storing state in DOM `data-*` instead of in JS variables on
  long-lived screens.
- ❌ Using `alert()` / `confirm()` for production UX. Use a fancybox
  modal.

## Helpers / utilities

| Function | Where | Purpose |
|----------|-------|---------|
| `formatMoney(n)` | `js/format.js` | Currency formatting per `params.numberFormat` |
| `formatDate(s)` | `js/format.js` | Date in tenant locale |
| `noty({...})` | `js_plugins/noty/jquery.noty.js` | Toast |
| `renderPill(s)` | `js/render.js` | Status pill markup |
| `renderActions(row)` | `js/render.js` | Row-action `⋮` menu |
