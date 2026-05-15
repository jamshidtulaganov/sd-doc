---
sidebar_position: 2
title: Docker Compose
---

# Docker Compose

The repo ships a single dev-friendly `docker-compose.yml`
([`/Users/jamshid/projects/salesdoctor/sd-main/docker-compose.yml`](../project/structure.md)).
It is **not** production-ready; treat it as the developer-loop stack.
For prod, derive a `docker-compose.prod.yml` overlay (sample below).

## Committed services

Verified against `docker-compose.yml` at audit time:

| Service | Image | Build context | Host ports | Notes |
|---------|-------|--------------|------------|-------|
| `web` | (built from `./Dockerfile`) | repo root | `8080:80` | nginx + php-fpm 7.3 in one container (see [Deployment](./deployment.md)). Bind-mounts `.:/var/www/html` for dev hot-reload. `depends_on: [db, redis]`. Env: `DB_HOST=db, DB_PORT=3306`. |
| `db` | `mysql:8.0` | n/a | `3306:3306` | `MYSQL_ROOT_PASSWORD=root`, `MYSQL_DATABASE=sd_main`, `MYSQL_USER=jamshid`, `MYSQL_PASSWORD=secret`. Volume `db_data:/var/lib/mysql`. Custom config bind-mounted: `./mysql.cnf:/etc/mysql/conf.d/custom.cnf`. |
| `redis` | `redis:7-alpine` | n/a | `6379:6379` | Single instance; three logical DBs are partitioned at the application layer (see [Caching](../architecture/caching.md)). No persistence flags. |
| `phpmyadmin` | `phpmyadmin/phpmyadmin` | n/a | `8081:80` | `PMA_HOST=db, PMA_PORT=3306`. `restart: always`. **Dev convenience only — must be removed in prod overlays.** |

Top-level `volumes:` declares `db_data`. There are no named networks
(everything sits on the implicit Compose default bridge) and no
healthchecks on any service.

### Dev credentials warning

The committed compose file ships hard-coded credentials
(`jamshid / secret`, `MYSQL_ROOT_PASSWORD=root`) and the phpMyAdmin
service is reachable on `:8081`. These are flagged in
[sd-main security landmines](../security/sd-main-landmines.md) item #6.
**Do not deploy this file as-is.**

## Production overlay — derive your own

```yaml
# docker-compose.prod.yml
services:
  web:
    image: registry.example.com/sd-main:${VERSION}
    restart: unless-stopped
    environment:
      - APP_ENV=production
    volumes:
      - /srv/sd-main/uploads:/var/www/html/upload
      - /srv/sd-main/config/main_local.php:/var/www/html/protected/config/main_local.php:ro
    deploy:
      resources:
        limits: { cpus: '2.0', memory: 1g }

  db:
    image: mysql:8.0
    restart: unless-stopped
    volumes:
      - /srv/sd-main/mysql:/var/lib/mysql
    command:
      - --innodb-buffer-pool-size=4G
      - --max-connections=300

  redis:
    image: redis:7-alpine
    restart: unless-stopped
    command: ['redis-server', '--maxmemory', '2gb', '--maxmemory-policy', 'allkeys-lru']
    volumes:
      - /srv/sd-main/redis:/data
```

Don't bind `phpmyadmin` in production. Don't expose `:3306` or `:6379`
beyond the VPC.

## Queue workers

The committed compose file does **not** run a queue worker by default.
For dev work that touches background jobs, either run the worker by hand
inside the `web` container:

```bash
docker compose exec web php console.php queue work --queue=default
```

…or add a sidecar service to the prod overlay:

```yaml
  worker:
    image: registry.example.com/sd-main:${VERSION}
    restart: unless-stopped
    command: ['php', 'console.php', 'queue', 'work', '--queue=default', '--memory=128']
    depends_on: [redis, db]
    volumes:
      - /srv/sd-main/config/main_local.php:/var/www/html/protected/config/main_local.php:ro
```

See [Jobs and scheduling](../architecture/jobs-and-scheduling.md#running-workers)
for the full parameter list and supervisord recipe.

## See also

- [Deployment](./deployment.md) — Dockerfile shape, rollout, smoke tests.
- [Nginx](./nginx.md) — vhost layout (one per tenant subdomain).
- [Caching](../architecture/caching.md) — Redis db0/db1/db2 split.
- [Multi-tenancy](../architecture/multi-tenancy.md) — how the single
  `web`/`db`/`redis` stack hosts many tenants.
