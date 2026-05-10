ARG PHP_VERSION=8.3
FROM serversideup/php:${PHP_VERSION}-fpm


USER root

ENV PHP_OPCACHE_ENABLE=1 \
    PHP_OPCACHE_MEMORY_CONSUMPTION=128 \
    PHP_OPCACHE_MAX_ACCELERATED_FILES=10000 \
    PHP_OPCACHE_REVALIDATE_FREQ=0 \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS=0

RUN install-php-extensions \
    gd \
    intl \
    zip \
    pdo_mysql \
    pdo_pgsql \
    redis \
    bcmath \
    exif 

RUN apt-get update && apt-get install -y --no-install-recommends \
    supervisor \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy supervisor config
COPY supervisord.conf /etc/supervisor/supervisord.conf

# Copy worker configs as placeholders
COPY ./workers/queue.conf /etc/supervisor/conf.d/queue.x
COPY ./workers/scheduler.conf /etc/supervisor/conf.d/scheduler.x

USER www-data

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]

