#!/bin/bash

alias dc-up="docker-compose up -d nginx mysql redis"
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


mkdir -p project
dc-composer create-project laravel/laravel /var/www --prefer-dist

echo "APP_NAME=laravel" > .env
echo "MYSQL_ROOT_PASSWORD=default-sql-pass" >> .env
sed -e 's/DB_HOST=127.0.0.1/DB_HOST=laravel-db/g' project/.env | sed -e 's/REDIS_HOST=127.0.0.1/REDIS_HOST=laravel-redis/g' | sed -e 's/REDIS_PASSWORD=null/REDIS_PASSWORD=redis-pass/g'>> .env
cp .env project/.env
rm .env
ln -s project/.env .env
dc-art key:generate
