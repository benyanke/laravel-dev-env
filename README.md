# Laravel Development environment

# Services
This docker-compose development environment provides the following services:
  * Nginx/PHP-FPM application server with php7.2
    * Default: `127.0.0.1:8080`, override with `PORT_APP`
  * MySQL database
  * Redis cache
  * Queue worker
  * phpMyAdmin - MySQL web administration tool
    * Default: `127.0.0.1:8081`, override with `PORT_PMA`
  * Mailcatcher - SMTP mail catchall server for development
    * Default: `127.0.0.1:8082`, override with `PORT_MAIL`
  * Redis Commander - redis admin interface
    * Default: `127.0.0.1:8083`, override with `PORT_REDISADMIN`

# Commands

## Start development environment
  `docker-compose up -d app`
  This will take several minutes to run the first time, as it downloads each container.
  After the first run, it completes in about 7 seconds.

## Stop development environment
  `docker-compose down`




alias logview="tail -f /var/www/laravel/storage/logs/laravel.log"


# To view all web-path logs on app server:
docker-compose exec app tail -f /var/log/php7.1-fpm.log /var/log/nginx/* /var/www/laravel/storage/logs/*

# Nginx access log
docker-compose exec app tail -f /var/log/nginx/access.log
