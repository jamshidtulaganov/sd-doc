---
sidebar_position: 2
title: Docker Compose
---

# Docker Compose

The repo ships a dev-friendly `docker-compose.yml`. For production, derive
a `docker-compose.prod.yml` overlay:

```yaml
services:
  web:
    image: registry.example.com/sd-main:${VERSION}
    restart: unless-stopped
    environment:
      - APP_ENV=production
    volumes:
      - /srv/sd-main/uploads:/var/www/html/upload
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
