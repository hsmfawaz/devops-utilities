[group:app-horizon]
programs=app-horizon
priority=51

[program:app-horizon]
process_name=%(program_name)s_%(process_num)02d
command=php /app/artisan horizon
user=application
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile=/app/storage/logs/horizon.log
logfile_maxbytes=50MB
stderr_logfile=/dev/stderr