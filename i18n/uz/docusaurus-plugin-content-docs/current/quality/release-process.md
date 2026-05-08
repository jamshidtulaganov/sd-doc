---
sidebar_position: 4
title: Reliz jarayoni
---

# Reliz jarayoni

## Tezlik

- **Hotfix**: istalgan vaqtda, tezkor.
- **Minor**: chorshanba kuni har hafta.
- **Major**: choraklik, ogohlantirish + tenant bo'yicha rollout bilan.

## Versiyalash

`v<major>.<minor>.<patch>`. Git da tag qo'ying. PHP dagi `VERSION`
konstantasi faol build ni aks ettiradi.

## Qadamlar

1. `main` dan `release/<version>` branch i.
2. `VERSION` va `docs/changelog.md` ni yangilang.
3. Tag qo'ying va push qiling.
4. CI tag bilan image qiladi.
5. Reliz poyezdi pipeline orqali **staging** ga deploy qiling.
6. Staging da QA + UAT.
7. **Production** ga bosqichma-bosqich rollout bilan ko'taring (avval
   canary tenant).
8. Metrikalarni 24 soat kuzating. Toza bo'lsa, yopilgan deb belgilang.

## Aloqa

- Ichki: `#release` Slack ga changelog ni post qiling.
- Tashqi: mijozga yo'naltirilgan changelog sahifasi.
- Ko'p tilli reliz eslatmalari (EN / RU / UZ) — shablon uchun
  `pm-workflow` skill ga qarang.
