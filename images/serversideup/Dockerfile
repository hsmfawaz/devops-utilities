ARG PHP_VERSION=8.3
FROM serversideup/php:${PHP_VERSION}-fpm

USER root

ENV PHP_OPCACHE_ENABLE=1 \
    PHP_OPCACHE_MEMORY_CONSUMPTION=128 \
    PHP_OPCACHE_MAX_ACCELERATED_FILES=10000 \
    PHP_OPCACHE_REVALIDATE_FREQ=0 \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS=0 \
    ENABLE_SCHEDULER=false \
    ENABLE_QUEUE=false \
    QUEUE_WORKERS=1 \
    QUEUE_COMMAND="php /var/www/html/artisan queue:work --sleep=3 --tries=2 --max-time=3600"

RUN install-php-extensions \
    gd \
    intl \
    bcmath \
    exif 

RUN apt-get update && apt-get install -y --no-install-recommends \
    supervisor \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy supervisor config
COPY supervisord.conf /etc/supervisor/supervisord.conf

# Copy worker configs
COPY ./workers/queue.conf /etc/supervisor/conf.d/queue.x
COPY ./workers/scheduler.conf /etc/supervisor/conf.d/scheduler.x
COPY startup.sh /etc/entrypoint.d/10-laravel-startup.sh





RUN chown -R www-data:www-data /etc/supervisor/conf.d

USER www-data
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
