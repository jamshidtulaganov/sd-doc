---
sidebar_position: 2
title: Docker Compose
---

# Docker Compose

Repo dev-friendly `docker-compose.yml` ni jo'natadi. Production uchun
`docker-compose.prod.yml` overlay ishlab chiqing:

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

Production da `phpmyadmin` ni bind qilmang. `:3306` yoki `:6379` ni VPC
dan tashqariga ochmang.
