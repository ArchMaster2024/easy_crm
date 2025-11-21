FROM php:8.4.14-cli-alpine

ARG UID=1000
ARG GUI=1000
ARG NODE_VERSION=22.21.1

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

ARG XDEBUG_ENABLED
ARG XDEBUG_MODE
ARG XDEBUG_HOST
ARG XDEBUG_LOG
ARG XDEBUG_LOG_LEVEL

RUN if [ "${XDEBUG_ENABLED}" = "true" ]; then \
    pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    echo "xdebug.mode=${XDEBUG_MODE}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.log=${XDEBUG_LOG}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.log_level=${XDEBUG_LOG_LEVEL}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.client_host=${XDEBUG_HOST}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ; \
    echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ; \
fi

RUN if getent group ${GID}; then \
        useradd -m -u ${UID} -g www -s /bin/bash www; \
    else \
        groupadd -g ${GID} www && \
        useradd -m -u ${UID} -g www -s /bin/bash www; \
    fi && \
    usermod -aG sudo www && \
    echo 'www ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER www

RUN export NVM_DIR="$HOME/.nvm" && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash && \
    [ -s "$NVIM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    nvm install ${NODE_VERSION} && \
    nvm alias default ${NODE_VERSION} && \
    nvm use default

RUN echo 'export NVM_DIR="$HOME/.nvm"' >> /home/www/.bashrc && \
    echo '[ -s "NVM_DIR/nvm.sh" ] && \. "NVM_DIR/nvm.sh"' >> /home/www/.bashrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /home/www/.bashrc

WORKDIR /srv/backend

ENTRYPOINT []

CMD ["bash"]
