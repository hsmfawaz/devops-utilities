#!/usr/bin/env bash

chown -R application:application /app

if [ "${APP_QUEUE}" == "supervisor" ]; then
  if [[ ! -e "/opt/docker/etc/supervisor.d/app-queue-worker.conf" ]]; then
    echo ""
    echo "[LOG] Starting App Queue..."
    echo ""
    mv /opt/docker/etc/supervisor.d/app-queue-worker.conf.x /opt/docker/etc/supervisor.d/app-queue-worker.conf
    # set the queue worker to ${APP_QUEUE_WORKERS}
    sed -i~ "/^numprocs=/s/=.*/=${APP_QUEUE_WORKERS}/" /opt/docker/etc/supervisor.d/app-queue-worker.conf
    supervisorctl start app-worker
  fi
else
  if [[ -e "/opt/docker/etc/supervisor.d/app-queue-worker.conf" ]]; then
    echo ""
    echo "[LOG] Stopping App Queue..."
    echo ""
    supervisorctl stop app-worker
    mv /opt/docker/etc/supervisor.d/app-queue-worker.conf /opt/docker/etc/supervisor.d/app-queue-worker.conf.x
  fi
fi

if [ "${APP_QUEUE}" == "horizon" ]; then
  if [[ ! -e "/opt/docker/etc/supervisor.d/app-horizon.conf" ]]; then
    echo ""
    echo "[LOG] Starting Horizon..."
    echo ""
    mv /opt/docker/etc/supervisor.d/app-horizon.conf.x /opt/docker/etc/supervisor.d/app-horizon.conf
  fi
  supervisorctl start app-horizon
else
  if [[ -e "/opt/docker/etc/supervisor.d/app-horizon.conf" ]]; then
    echo ""
    echo "[LOG] Stopping Horizon..."
    echo ""
    supervisorctl stop app-horizon
    mv /opt/docker/etc/supervisor.d/app-horizon.conf /opt/docker/etc/supervisor.d/app-horizon.conf.x
  fi
fi

if [ "${APP_SCHEDULE}" == "true" ]; then
  echo ""
  echo "[LOG] Starting Cronjob..."
  echo ""
  echo -n "" >  /etc/cron.d/webdevops-docker
  docker-cronjob '* * * * * application /usr/local/bin/php /app/artisan schedule:run'
else
  echo ""
  echo "[LOG] Clearing Cronjob..."
  echo ""
  echo -n "" >  /etc/cron.d/webdevops-docker
fi

#check if vendor folder exists and composer.json exists
if [ ! -d /app/vendor ] && [ -f /app/composer.json ]; then
  echo ""
  echo "[LOG] Running Composer Install..."
  echo ""
  composer install --no-interaction --no-progress --no-suggest || echo "Composer install failed"
  php artisan key:generate || echo "Key generation failed"
  php artisan storage:link || echo "Storage link failed"
fi
