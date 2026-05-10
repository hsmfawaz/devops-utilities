#!/bin/sh
set -e

echo "Running startup script..."
cd /var/www/html


if [ "${ENABLE_SCHEDULER}" = true ]; then
  echo ""
  echo "[LOG] Starting Scheduler..."
  echo ""
  cp /etc/supervisor/conf.d/scheduler.x /etc/supervisor/conf.d/scheduler.conf
else
  echo ""
  echo "[LOG] Stopping Scheduler..."
  echo ""
  rm -f /etc/supervisor/conf.d/scheduler.conf
fi



if [ "${ENABLE_QUEUE}" = true ]; then
  echo ""
  echo "[LOG] Starting Queue..."
  echo ""
  mkdir -p /var/www/html/storage/logs
  cp /etc/supervisor/conf.d/queue.x /etc/supervisor/conf.d/queue.conf
  if [ -z "${QUEUE_WORKERS}" ]; then
    QUEUE_WORKERS=1
  fi
  if [ -z "${QUEUE_COMMAND}" ]; then
    QUEUE_COMMAND="php /var/www/html/artisan queue:work --sleep=3 --tries=2 --max-time=3600"
  fi
  sed -i "s|numprocs=.*|numprocs=${QUEUE_WORKERS}|" /etc/supervisor/conf.d/queue.conf
  sed -i "s|command=.*|command=${QUEUE_COMMAND}|" /etc/supervisor/conf.d/queue.conf
else
  echo ""
  echo "[LOG] Stopping Queue..."
  echo ""
  rm -f /etc/supervisor/conf.d/queue.conf
fi



if [ ! -d /var/www/html/vendor ] && [ -f /var/www/html/composer.json ]; then
  echo ""
  echo "[LOG] Running Composer Install..."
  echo ""
  composer install --no-interaction --no-progress --no-suggest || echo "Composer install failed"
  php artisan key:generate || echo "Key generation failed"
  php artisan storage:link || echo "Storage link failed"
  git config --global --add safe.directory /var/www/html 2>> /dev/null || echo "Git config failed"
fi
