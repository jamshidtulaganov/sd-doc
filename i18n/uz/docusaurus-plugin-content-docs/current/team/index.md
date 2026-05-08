---
sidebar_position: 0
title: Jamoa bilim bazasi
slug: /team
audience: Jamoaning barcha a'zolari (QA, PM, yangi muhandislar)
summary: Jamoaga yo'naltirilgan sahifalarga kirish nuqtasi — onboarding, QA jarayoni va Mahsulot Boshqaruvi jarayoni. Xuddi shu kontent jamoaning RAG / vektor ma'lumotlar bazasiga ham yetkaziladi.
topics: [team, knowledge-base, onboarding, qa, pm]
---

# Jamoa bilim bazasi

Ushbu bo'lim **inson jamoa a'zolari** uchun. Bu yerdagi sahifalar
kanonik "bilim bazasi" — ular shuningdek jamoaning RAG / vektor
ma'lumotlar bazasiga ham yetkaziladi, shuning uchun xuddi shu kontentga
ilova ichidagi qidiruv va chat assistantlar orqali erishish mumkin.

| Sahifa | Kim uchun | Nima topasiz |
|--------|-----------|--------------|
| [Yangi dasturchini onboarding](./onboarding.md) | Yangi muhandislar | 1-kun / 1-hafta / 1-oy rejasi, o'qish tartibi, boshlang'ich ticketlar |
| [QA — jarayon va bilim bazasi](./qa.md) | QA jamoasi | Test rejalari, bug shablonlari, jiddiylik, regression issiq nuqtalari |
| [Mahsulot Boshqaruvi — jarayon va bilim bazasi](./pm.md) | Mahsulot jamoasi | PRD shablonlari, RICE, reliz eslatmalari, loyiha konteksti |

## Ushbu bo'lim qanday ishlatiladi

- **Onboarding** — menejerlar yangi xodimlarni 1-kuni shu yerga
  yo'naltiradi.
- **Test holatlari** — QA regression issiq nuqtalariga va
  [Modullar](../modules/overview.md) ostida hujjatlashtirilgan har bir
  modul kalit xususiyatlariga qarshi testlar yozadi.
- **Yangi xususiyatlar** — Product tegishli modul + xususiyat oqimiga
  havola qiluvchi PRD lar yozadi, keyin engineering belgilangan
  patternlarga qarshi amalga oshiradi.
- **RAG / qidiruv** — jamoaning vektor DB si bu sahifalarni
  o'zlashtiradi, shunda foydalanuvchilar "to'lov tasdig'i qanday
  ishlaydi" deb so'rashlari va to'g'ri parchani olishlari mumkin.

## Hujjat = bilim bazasi = onboarding

Yaxshi yozilgan sahifa uchchala auditoriyaga ham xizmat qilishi kerak.
Yangi sahifa yozayotganda, so'rang:

1. Bu **yangi muhandis** uchun platform konteksti bo'lmagan holda
   ma'noli bo'ladimi? (Bo'lmasa, Summary paragrafi qo'shing.)
2. **QA muhandisi** regression xavflarini topadimi? (Tegishli bo'lsa
   "Buzilish rejimlari" yoki "Issiq nuqtalar" bo'limi qo'shing.)
3. **PM** xususiyatning rollar, mobil va muvofiqlikka ta'sirini
   biladimi? (Modul boshiga Kalit xususiyatlar jadvalini ishlating.)
4. **Vektor DB** uni toza ravishda parchalaydi mi? (O'zini o'zi tutuvchi
   bo'limlar, mutlaq havolalar — "yuqoriga qarang" yo'q.)
