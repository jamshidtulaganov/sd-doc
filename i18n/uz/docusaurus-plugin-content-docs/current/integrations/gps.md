---
sidebar_position: 9
title: GPS provayderlari
---

# GPS provayderlari

Mobil ilova GPS namunalarini api3 ga yuboradi (`POST /api3/gps/index`).
Avtomobillarni kuzatish uchun tashqi provayderlar to'g'ridan-to'g'ri
yuborishi mumkin:

| Provayder | Endpoint |
|-----------|----------|
| Umumiy JSON | `POST /gps3/backend/ingest` |
| Wialon uslubidagi | `POST /gps3/backend/wialon` |

Autentifikatsiya har bir provayder uchun (URL yoki sarlavhadagi token).
Namunalar `gps_track` ga yoziladi, so'ngra `MonitoringController` va
Angular xarita UI tomonidan iste'mol qilinadi.
