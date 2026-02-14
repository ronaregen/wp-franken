FROM dunglas/frankenphp:latest

# Install extensions wajib WP + Opcache buat speed
RUN install-php-extensions \
    mysqli \
    gd \
    intl \
    zip \
    opcache \
    exif \
    imagick

# Copy custom php.ini
COPY ./php/conf.d/ /usr/local/etc/php/conf.d/

# Copy Caddyfile
COPY Caddyfile /etc/caddy/Caddyfile

WORKDIR /var/www/html

# Source code WP (asumsi lo download dan taro di folder /src)
COPY --chown=www-data:www-data ./wordpress /var/www/html

CMD ["frankenphp", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]