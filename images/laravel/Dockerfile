ARG PHP_VERSION=8.2
FROM webdevops/php:${PHP_VERSION}-alpine as base

WORKDIR /app
ENV APP_SCHEDULE=false
# supervisor || horizon
ENV APP_QUEUE=""
ENV APP_QUEUE_WORKERS=1

RUN docker-service enable cron
RUN apt update && apt-get -yq install gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4
libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget libatk-bridge2.0-0 libgbm-dev

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install nodejs && corepack enable

COPY supervisor.d /opt/docker/etc/supervisor.d
COPY start-app.sh /opt/docker/provision/entrypoint.d/start-app.sh

