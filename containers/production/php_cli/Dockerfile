FROM php:8.4.14-cli-alpine AS builder

RUN apk add --no-cache \
    curl \
    unzip \
    libpq \
    openssl \
    libxml2-dev \
    libcurl \
    icu-dev \
    libzip-dev \
    && docker-php-ext-install -j$(nproc) \
    pdo_pgsql \
    pgsql \
    opcache \
    intl \
    zip \
    bcmath \
    soap \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk cache clean && apk del --purge $(apk info -a | awk '{print $1}' | sort | uniq -u) && rm -rf /var/cache/apk/* && rm -rf /tmp/*

WORKDIR /srv/backend

COPY ./backend /srv/backend

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --optimize-autoloader --no-interaction --no-progress --prefer-dist

FROM php:8.4.14-cli-alpine

RUN apk add --no-cache \
    libpq \
    icu-dev \
    libzip-dev \
    && apk cache clean && apk del --purge $(apk info -a | awk '{print $1}' | sort | uniq -u) && rm -rf /var/cache/apk/* && rm -rf /tmp/*

COPY --from=builder /usr/local/lib/php/extensions /usr/local/lib/php/extensions
COPY --from=builder /usr/local/etc/php/conf.d /usr/local/etc/php/conf.d
COPY --from=builder /usr/local/bin/docker-php-ext-* /usr/local/bin/

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY --from=builder /srv/backend /srv/backend

WORKDIR /srv/backend

RUN chown -R www-data:www-data /srv/backend/storage
RUN chown -R www-data:www-data /srv/backend/bootstrap/cache

USER www-data

CMD ["bash"]
