---
sidebar_position: 1
title: Deployment
---

# Deployment

## Targets

The reference deployment is **Docker on Linux VMs** behind an external
load balancer. Production-ready alternatives: Kubernetes (`Deployment`
per service) or a managed PaaS (Render, Fly.io) — same containers.

## Deployment artefacts

- `web` image — built from `Dockerfile` (php-fpm + nginx in one
  container). For production, split into separate `nginx` and `php` images
  if you need them to scale independently.
- App config — `protected/config/main_local.php` overrides env-specific
  values.

## Steps (zero-downtime)

```bash
# 1. Build
docker build -t registry.example.com/sd-main:$(git rev-parse --short HEAD) .

# 2. Push
docker push registry.example.com/sd-main:<tag>

# 3. Roll
ssh prod 'docker compose pull web && docker compose up -d web'
```

If you split nginx / php-fpm: roll php-fpm first, then nginx.

## Database migrations

Run migrations BEFORE the new app starts:

```bash
docker compose exec web php protected/yiic migrate up
```

For the multi-tenant fan-out, see [Migrations](../data/migrations.md).

## Rollback

`docker compose up -d web` with the previous tag. Database migrations
should be **forward-compatible** — ideally additive only — so an old app
can run against a newer schema.

## Smoke tests

After deploy, hit:

```
GET /healthz                   → 200
GET /site/index                → 200
GET /api3/config/index         → 200 with expected JSON
```

A simple `curl` script in `infra/smoke.sh` is the canonical version.
