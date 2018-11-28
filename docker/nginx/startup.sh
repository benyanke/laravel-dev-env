#!/bin/bash
# This runs on container startup.
# Ensure it returns exit code 0, otherwise the container will not continue to startup.

# Error handler to use like 'cmd || errHandler'
function errHandler() {
  echo ""
  echo "COMMAND FAILURE - EXITING!!"
  echo ""
  exit 1;
}


echo ""
echo "#####################################################"
echo "       Provisioning App Server Container             "
echo "#####################################################"
echo ""

# Export env file to this shell for the sake of using during provisioning
export $(egrep -v '^#' $CMD_DIR/.env | xargs)

# Here is an example command which dumps the current env to /tmp/env
env > /tmp/env

##########
# Run commands for bootstrapping dev env
##########

# Get the github public keys
# TODO : Refactor this travesty of key handling
function getGithubValidKeys() {
  curl https://help.github.com/articles/github-s-ssh-key-fingerprints/ 2> /dev/null | egrep -o '([0-9a-f]{2}:){15}[0-9a-f]{2}'
}

mkdir /root/.ssh 2> /dev/null
getGithubValidKeys > /root/.ssh/known_hosts || errHandler

export OWN_USER="www-data"
export ARTISAN="/usr/bin/php /var/www/artisan"

# change www-data user to provided UID/GID
usermod  -u "$UID" "$OWN_USER"
groupmod -g "$GID" "$OWN_USER"


# Fix filesystem permissions based on UID/GID provided by ENV
if [ "$RUN_PERMISSION_FIX" = "1" ] ; then
  echo "Running permission fix";
  chown -R $UID:$GID "$CMD_DIR"
else
  echo "Skipping permission fix";
fi

# Composer install packages
if [ "$RUN_COMPOSER" = "1" ] ; then
  echo "Running composer install";
  (cd "$CMD_DIR" ; composer install --optimize-autoloader --no-progress --no-interaction --no-suggest || exit 1) || errHandler
else
  echo "Skipping composer install";
fi


# Run Webpack
if [ "$RUN_WEBPACK" = "1" ] ; then
  echo "Running Laravel Mix";
  (cd "$CMD_DIR" ; echo "Not yet implemented" )
else
  echo "Skipping Laravel Mix";
fi

# Wait for mysql to come up
while ! timeout 1 bash -c "cat < /dev/null > /dev/tcp/$DB_HOST/3306 &> /dev/null"; do
    echo "MySQL not online yet. Waiting..."
    sleep 0.5;
done

echo ""
echo "MySQL online - continuing."
echo ""

# Run DB Migrations
if [ "$RUN_MIGRATIONS" = "1" ] ; then
  echo "Running DB migrations (destructive)";
  (cd "$CMD_DIR" ; $ARTISAN migrate:fresh || exit 1) || errHandler
  $ARTISAN migrate:status || errHandler
elif [ "$RUN_MIGRATIONS_SAFE" = "1" ] ; then
  echo "Running DB migrations (nondestructive)";
  (cd "$CMD_DIR" ; $ARTISAN migrate || exit 1) || errHandler
  $ARTISAN migrate:status || errHandler
else
  echo "Skipping DB Migrations";
fi

# Run DB Seeder
if [ "$RUN_DB_SEED" = "1" ] ; then
  echo "Running DB seeds";
  (cd "$CMD_DIR" ; $ARTISAN db:seed --force  || exit 1) || errHandler
else
  echo "Skipping DB seeds";
fi


# Run Vendor Publish
if [ "$RUN_VENDOR_PUBLISH" = "1" ] ; then
  echo "Running Vendor Publish";
  (cd "$CMD_DIR" ; $ARTISAN vendor:publish --all  || exit 1) || errHandler
else
  echo "Skipping Vendor Publish";
fi

echo ""
echo "#####################################################"
echo "       Provisioning Complete - starting Nginx/FPM"
echo "#####################################################"
echo ""

# Exiting
exit 0;
