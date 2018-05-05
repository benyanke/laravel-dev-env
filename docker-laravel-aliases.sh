alias dc-up="docker-compose up -d app"
# alias dc-up="docker-compose up -d nginx mysql redis queue-daemon"
alias dc-down="docker-compose down"
alias dc-art="docker-compose run --rm artisan"
alias dc-artisan="docker-compose run --rm artisan"
alias dc-phpunit="docker-compose run --rm phpunit"
alias dc-phpspec="docker-compose run --rm phpspec"
alias dc-composer="docker-compose run --rm composer"
alias dc-node="docker-compose run --rm node node"
alias dc-gulp="docker-compose run --rm node gulp"
alias dc-npm="docker-compose run --rm node npm"
alias dc-bower="docker-compose run --rm node bower"

alias dc-backup="docker-compose up -d mysql-backup"
alias dc-adminer="docker-compose up -d adminer"
alias dc-queue="docker-compose up -d queue-daemon"


alias logview="tail -f /var/www/laravel/storage/logs/laravel.log"
