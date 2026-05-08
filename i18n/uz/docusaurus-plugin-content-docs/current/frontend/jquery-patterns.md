---
sidebar_position: 6
title: jQuery / AJAX patternlari
audience: New frontend developers
summary: sd-main view-larida ishlatiladigan standart jQuery + AJAX patternlari — DataTables server-side fetch, fancybox modal, form submit, file upload, polling, debounced filter. Mavjud kodbazadan nusxa olish uchun retseptlar.
topics: [jquery, ajax, datatables, fancybox, modal, polling, frontend-patterns]
---

# jQuery / AJAX patternlari

sd-main frontend — bu **jQuery + Yii server tomonida render qilingan view-lar**. SPA framework yo'q. Har bir interaktiv ekran quyidagi patternlardan birini bajaradi — eng yaqin mavjud misoldan nusxa oling.

## Nima uchun jQuery (hali ham)

- Bundle qilingan jQuery 1.10 ustida kichik bog'liqlik.
- Build pipeline-siz ishlaydi.
- Har bir mavjud view undan foydalanadi — izchillik g'olib bo'ladi.

Agar sizga boyroq interaktivlik kerak bo'lsa, Angular orolini joylashtiring ([ng-modules](./ng-modules.md)) — bu yerga React / Vue ni kiritmang.

## Pattern 1 — DataTables server tomonidagi fetch

Har bir list sahifasining asosi.

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

Server tomoni qaytaradi:

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
    src: this.href,        // tahrirlash forma HTML URL
    type: 'ajax',
    opts: {
      afterShow: () => bindFormHandlers('#edit-form'),
      afterClose: () => $('#orders-table').DataTable().ajax.reload(null, false),
    },
  });
});
```

Server forma partial HTML view-ini qaytaradi. Saqlashdan keyin, modalni yoping va parent jadvalni qayta yuklang.

Kutubxona: `js_plugins/fancybox2`.

## Pattern 3 — Async forma yuborish

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

`noty` toast kutubxonasi (`js_plugins/noty`).

## Pattern 4 — Buzilishli harakatdan oldin tasdiqlovchi modal

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

Boyroq tasdiqlash uchun, brauzer `confirm` o'rniga maxsus shablonli fancybox modal ishlating.

## Pattern 5 — Debounced filter (jonli qidiruv)

```js
let timer;
$('#search').on('input', function () {
  clearTimeout(timer);
  timer = setTimeout(() => {
    $('#orders-table').DataTable().ajax.reload(null, false);
  }, 300);
});
```

300 ms — standart debounce.

## Pattern 6 — Status yangilanishlari uchun polling

Uzoq davom etadigan ishlar uchun (Excel-ga eksport, EDI yuborish, katta importlar):

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

2 soniyalik kadens. Terminal status-da to'xtang. Server progress bar uchun `progress` maydonini (0–100) qo'shadi.

## Pattern 7 — File upload (drag-drop, fotosuratlar)

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

## Pattern 8 — Zanjirli select-lar

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

Mijozni tahrirlash, agentni tahrirlash, marshrut tayinlashda foydalaniladi.

## Pattern 9 — chosen.js qidiruvli select-lar

```js
$('select.searchable').chosen({ width: '100%', search_contains: true });
```

Kutubxona: `js_plugins/chosen`. > 10 variantli har qanday `<select>` uchun ishlating.

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

Kutubxona: `js_plugins/jquery-highcharts-10.3.3`. Server AJAX endpoint orqali chart shaklidagi JSON ni qaytaradi.

## Anti-patternlar

- Klient tomonida DataTable ga > 5,000 qatorni yuklash. `serverSide: true` ishlating.
- Uzoq bloklarda string konkatenatsiya orqali HTML qurish. Template tag yoki kichik yordamchi ishlating.
- `$.ajax({ async: false })` — UI thread-ni bloklaydi.
- Uzoq yashaydigan ekranlarda holatni JS o'zgaruvchilari o'rniga DOM `data-*` da saqlash.
- Production UX uchun `alert()` / `confirm()` dan foydalanish. Fancybox modal ishlating.

## Yordamchilar / utility-lar

| Funktsiya | Qayerda | Maqsad |
|----------|-------|---------|
| `formatMoney(n)` | `js/format.js` | `params.numberFormat` bo'yicha valyuta formatlash |
| `formatDate(s)` | `js/format.js` | Tenant locale-da sana |
| `noty({...})` | `js_plugins/noty/jquery.noty.js` | Toast |
| `renderPill(s)` | `js/render.js` | Status pill markup |
| `renderActions(row)` | `js/render.js` | Qator harakatlari `⋮` menyusi |
