---
sidebar_position: 3
title: Nginx
---

:::warning Stub
This page is a placeholder. The content is incomplete — verify against source before relying on it. See [the audit's stub-backfill list](#) for status.
:::

# Nginx

The repo ships `nginx.conf` for dev. For production, expand it to a
multi-vhost layout:

```nginx
# /etc/nginx/sites-enabled/sd-main.conf
server {
    listen 443 ssl http2;
    server_name *.salesdoc.io;
    ssl_certificate     /etc/ssl/wildcard.crt;
    ssl_certificate_key /etc/ssl/wildcard.key;

    client_max_body_size 50M;
    root /var/www/html;
    index index.php;

    # Static assets
    location ~* \.(css|js|png|jpg|svg|woff2?)$ {
        expires 30d;
        access_log off;
    }

    # PHP
    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass php:9000;
        fastcgi_read_timeout 60s;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param HTTP_HOST       $host;
    }

    # Block legacy index2.php and a.php in production
    location = /index2.php { return 404; }
    location = /a.php      { return 404; }
}
```

## Tenant routing

`HTTP_HOST` reaches PHP (forwarded by `fastcgi_param`); the app uses it
in `TenantContext` to select the database. Wildcard DNS + wildcard SSL
make adding a tenant a 30-second operation.

## Rate limiting

```nginx
limit_req_zone $binary_remote_addr zone=login:10m rate=5r/s;

location ~ /api3/login {
    limit_req zone=login burst=10 nodelay;
    include fastcgi_params; ...
}
```

## Health check

```nginx
location = /healthz { return 200 "ok\n"; default_type text/plain; }
```

Point your load balancer at `/healthz`.
