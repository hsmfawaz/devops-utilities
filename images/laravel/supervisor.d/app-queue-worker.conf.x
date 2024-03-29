[group:app-worker]
programs=app-worker
priority=50

[program:app-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /app/artisan queue:work --sleep=3 --tries=2
user=application
autostart=true
autorestart=true
redirect_stderr=true
numprocs=1
stdout_logfile=/app/storage/logs/worker.log
logfile_maxbytes=50MB
stderr_logfile=/dev/stderr