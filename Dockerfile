FROM dunglas/frankenphp:latest

RUN install-php-extensions \
    mysqli \
    gd \
    intl \
    zip \
    opcache \
    exif \
    imagick

COPY ./php/conf.d/ /usr/local/etc/php/conf.d/

COPY Caddyfile /etc/caddy/Caddyfile

WORKDIR /var/www/html

COPY --chown=www-data:www-data ./wordpress /var/www/html

CMD ["frankenphp", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]