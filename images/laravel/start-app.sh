#!/usr/bin/env bash

chown -R application:application "${WEB_DOCUMENT_ROOT}"/../

if [ "${APP_QUEUE}" = "supervisor" ]; then

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

if [ "${APP_HORIZON}" = "horizon" ]; then
  echo ""
  echo "[LOG] Starting Horizon..."
  echo ""
  if [[ ! -e "/opt/docker/etc/supervisor.d/app-horizon.conf" ]]; then
    mv /opt/docker/etc/supervisor.d/app-horizon.conf.x /opt/docker/etc/supervisor.d/app-horizon.conf
  fi
  supervisorctl start app-horizon
else
  echo ""
  echo "[LOG] Stopping Horizon..."
  echo ""
  if [[ -e "/opt/docker/etc/supervisor.d/app-horizon.conf" ]]; then
    supervisorctl stop app-horizon
    mv /opt/docker/etc/supervisor.d/app-horizon.conf /opt/docker/etc/supervisor.d/app-horizon.conf.x
  fi
fi



if [ "${APP_DOMAIN}" != "" ] && [ ! -e "/usr/local/share/ca-certificates/server_ng.crt" ]; then
  echo ""
  echo "[LOG] Generating local ssl file..."
  echo ""
  openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
    -subj "/C=EG/ST=QC/O=Codebase, Inc./CN=${APP_DOMAIN}" \
    -addext "subjectAltName=DNS:${APP_DOMAIN},DNS:*.${APP_DOMAIN}" \
    -keyout /etc/ssl/private/server.key \
    -out /etc/ssl/certs/server.crt

  chmod 777 /etc/ssl/private/server.key /etc/ssl/certs/server.crt

  rm -f /opt/docker/etc/nginx/ssl/server.crt /opt/docker/etc/nginx/ssl/server.key

  ln -s /etc/ssl/certs/server.crt /opt/docker/etc/nginx/ssl/server.crt
  ln -s /etc/ssl/private/server.key /opt/docker/etc/nginx/ssl/server.key
  cp /etc/ssl/certs/server.crt /usr/local/share/ca-certificates/server_ng.crt
  update-ca-certificates
fi

if [ "${APP_SCHEDULE}" = "true" ]; then
  echo ""
  echo "[LOG] Starting Cronjob..."
  echo ""
  echo -n "" >  etc/cron.d/webdevops-docker
  docker-cronjob '* * * * * application /usr/local/bin/php /app/artisan schedule:run'
else
  echo ""
  echo "[LOG] Clearing Cronjob..."
  echo ""
  echo -n "" >  etc/cron.d/webdevops-docker
fi