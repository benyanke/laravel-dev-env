# Laravel Development Environment

This is a Laravel Development Environment built on Docker. It strives to be a
full service development environment, allowing quick and easy local development.

## Services
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

### Start/Stop Development Environment
  This creates the container called 'app' (the application server) in the
  `docker-compose.yml` file, as well as all the containers listed in the `app`
  section's `depends_on` clause.

    `docker-compose up -d app`

  The main app/httpd container will not begin serving web requests immediately,
  as it first must install composer and NPM packages, etc. This will begin to
  respond to web requests 10-30 seconds after the container comes up

  Additionally, this can be run without the `-d` command, which will run int
  front-facing mode, bound to the current terminal, and displaying system logs.
  This can be useful for debugging, but not the desired behavior.

  This will take several minutes to run the first time, as it downloads each
  container. After the first run, it completes in about 7 seconds.

  To stop, run:

    `docker-compose down`

  This will stop and delete all the environment's containers.
  NOTE: This removes all transient state of the containers, such as the database.

### Temporary Start/Stop
  The stack can be paused and unpaused with the following commands:

    `docker-compose pause`  
    `docker-compose unpause`  

### Additional Useful Commands
  #### Run a command in a container:

    `docker-compose exec [container name] [command]`

  #### Enter main app server with a bash shell

    `docker-compose exec app /bin/bash`

  ##### View nginx access logs

    `docker-compose exec app tail -f /var/log/nginx/access.log`

  ##### Artisan

  _can also start bash, as above, then run from the container's shell_

    `docker-compose exec app php /var/www/artisan`

  #### View a container's primary log

  View container 'syslogs'. Additionally, omit container name to view all
  container's logs

    `docker-compose logs -f [container name]`


  When in doubt, run bash in a container and start looking around. For most
  intents and purposes, a container can be thought of like a VM, containing it's
  own userspace, filesystem (except shared mounted directories) and running
  processes.

## Additional Notes
  If you are experiencing odd issues, rebuilding the environment with new
  containers can typically be helpful.
  `docker-compose down; docker-compose up -d app`
