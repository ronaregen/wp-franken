FROM dunglas/frankenphp:latest

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*
    
RUN install-php-extensions \
    pdo_sqlite \
    sqlite3 \
    mysqli \
    gd \
    intl \
    zip \
    opcache \
    exif \
    imagick

COPY ./php/conf.d/ /usr/local/etc/php/conf.d/

COPY Caddyfile /etc/caddy/Caddyfile

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html

COPY --chown=www-data:www-data ./wordpress /var/www/html

ENTRYPOINT ["entrypoint.sh"]

CMD ["frankenphp", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]