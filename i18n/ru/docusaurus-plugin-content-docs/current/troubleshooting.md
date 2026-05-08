---
sidebar_position: 99
title: Troubleshooting
---

# Troubleshooting

## «Cannot resolve tenant» / пустая страница

**Причина**: `HTTP_HOST` не соответствует известному тенанту.

- Проверьте Nginx `server_name` и `fastcgi_param HTTP_HOST $host;`.
- Убедитесь, что тенант существует в registry.
- Проверьте `protected/runtime/application.log` на сбой резолва.

## 500 — `Class 'X' not found`

**Причина**: отсутствует директива `import` в `main_static.php` или
промах автолоада.

- Добавьте `application.modules.<module>.models.*` в `import`.
- Если это сервис, убедитесь, что файл лежит под `protected/components/`.

## «Срок лицензии программы истёк»

**Причина**: лицензия тенанта истекла (`hasSystemActive` возвращает
false).

- Обновите запись лицензии для этого тенанта через super-admin UI.
- Проверьте пары date / system-id в таблице лицензий.

## Mobile login падает (api3)

- Убедитесь, что `deviceToken` не пустой.
- Убедитесь в формате хеша пароля — старые пользователи могут до сих
  пор быть в MD5 (прозрачно при первом логине).
- Проверьте `ACTIVE = 'Y'` пользователя и активную лицензию для системы 4.

## Excel export OOM

- Экспорт, скорее всего, грузит всё в PHPExcel-объекты.
- При > 10k строк переключайтесь на стриминг через `XLSXWriter` или
  чанкованный CSV.

## Очередь не дренируется

- Воркеры упали. Проверьте supervisor.
- `LLEN sd_queue:default` не должна монотонно расти.
- Изучите первый элемент: `LRANGE sd_queue:default 0 0` — частая причина
  poison pill, который кидает на каждом ретрае.

## Redis db2 продолжает расти

- Новый код-путь пишет без TTL. Поищите `set(.*null` или голые
  вызовы `set(` в недавно изменённых файлах.
- `MEMORY USAGE <prefix>:*`, чтобы найти offender-ов.

## «Cannot redeclare class»

- Два файла определяют один и тот же класс. Посмотрите недавние
  переименования; старое имя файла может всё ещё существовать как
  `*.obsolete`, но Composer / Yii грузит оба.
