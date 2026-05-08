---
sidebar_position: 4
title: Процесс релизов
---

# Процесс релизов

## Каденция

- **Hotfix**: в любой момент, по fast-track.
- **Minor**: еженедельно по средам.
- **Major**: ежеквартально с уведомлением + tenant-by-tenant rollout.

## Версионирование

`v<major>.<minor>.<patch>`. Тег в git. Константа `VERSION` в PHP
отражает активную сборку.

## Шаги

1. Ветка `release/<version>` от `main`.
2. Обновить `VERSION` и `docs/changelog.md`.
3. Тегнуть и запушить.
4. CI собирает образ с тегом.
5. Деплой на **staging** через пайплайн релизного поезда.
6. QA + UAT на staging.
7. Промоут в **production** со stage rollout (сначала канарейный тенант).
8. Следить за метриками 24 ч. Если чисто — закрывать.

## Коммуникация

- Внутри: пост в Slack `#release` с changelog.
- Снаружи: customer-facing changelog-страница.
- Многоязычные release notes (EN / RU / UZ) — см. шаблон в скилле
  `pm-workflow`.
