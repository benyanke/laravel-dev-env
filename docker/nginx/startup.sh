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

function banner() {
  padCount="10"
  msg="$pad$1$pad"
  charCt="$(echo $msg | wc -c)"

  echo ""
  for i in `seq $padCount`; do printf "#";done
  for i in `seq $charCt`; do printf "#";done
  for i in `seq $padCount`; do printf "#";done
  echo ""
  for i in `seq $padCount`; do printf "#";done
  for i in `seq $charCt`; do printf "#";done
  for i in `seq $padCount`; do printf "#";done
  echo ""
  for i in `seq $padCount`; do printf " ";done
  echo "$@"
  for i in `seq $padCount`; do printf "#";done
  for i in `seq $charCt`; do printf "#";done
  for i in `seq $padCount`; do printf "#";done
  echo ""
  for i in `seq $padCount`; do printf "#";done
  for i in `seq $charCt`; do printf "#";done
  for i in `seq $padCount`; do printf "#";done
  echo ""
  echo ""
}

function msg() {
  padCount="2"
  msg="$pad$1$pad"
  charCt="$(echo $msg | wc -c)"

  echo ""
  for i in `seq $padCount`; do printf "#";done
  for i in `seq $charCt`; do printf "#";done
  for i in `seq $padCount`; do printf "#";done
  echo ""
  for i in `seq $padCount`; do printf " ";done
  echo " $@"
  for i in `seq $padCount`; do printf "#";done
  for i in `seq $charCt`; do printf "#";done
  for i in `seq $padCount`; do printf "#";done
  echo ""
  echo ""

}

banner "Provisioning App Server Container"

# Export env file to this shell for the sake of using during provisioning
export $(egrep -v '^#' $CMD_DIR/.env | xargs)

# Here is an example command which dumps the current env to /tmp/env
env > /tmp/env

##########
# Run commands for bootstrapping dev env
##########

# Get the github public keys
function getGithubValidKeys() {

  fetchFailure="0";

  # Retry on-failure up to 10 times
  for i in {1..10} ; do

    timeout 10 ssh-keyscan github.com > /root/.ssh/known_hosts && break

    echo "Github request failed - waiting a second and trying again. This is attempt $i"
    fetchFailure="1";
    sleep 1;

  done

  # Only display this if there was a failure
  if [[ "$fetchFailure" = "1" ]] ; then
    echo "Github keys fetched successfully."
  fi

}

msg "Getting host keys for github for composer package fetches"
mkdir /root/.ssh 2> /dev/null
getGithubValidKeys || errHandler

export OWN_USER="www-data"
export ARTISAN="/usr/bin/php /var/www/artisan"

# change www-data user to provided UID/GID
usermod  -u "$UID" "$OWN_USER"
groupmod -g "$GID" "$OWN_USER"


# Fix filesystem permissions based on UID/GID provided by ENV
if [ "$RUN_PERMISSION_FIX" = "1" ] ; then
  msg "Running permission fix";
  chown -R $UID:$GID "$CMD_DIR"
else
  msg "Skipping permission fix";
fi

# Composer install packages
if [ "$RUN_COMPOSER" = "1" ] ; then
  msg "Running composer install";
  (cd "$CMD_DIR" ; composer install --optimize-autoloader --no-progress --no-interaction --no-suggest || exit 1) || errHandler
else
  msg "Skipping composer install";
fi


# Run Webpack
if [ "$RUN_WEBPACK" = "1" ] ; then
  msg "Running Laravel Mix";
  (cd "$CMD_DIR" ; echo "Not yet implemented" )
else
  msg "Skipping Laravel Mix";
fi

# Wait for mysql to come up
msg "Waiting for MySQL to come online";
while ! timeout 1 bash -c "cat < /dev/null > /dev/tcp/$DB_HOST/3306 &> /dev/null"; do
    echo "MySQL not online yet. Waiting..."
    sleep 0.5;
done

msg "MySQL online - continuing."

# Run DB Migrations
if [ "$RUN_MIGRATIONS" = "1" ] ; then
  msg "Running DB migrations (destructive)";
  (cd "$CMD_DIR" ; $ARTISAN migrate:fresh || exit 1) || errHandler
  $ARTISAN migrate:status || errHandler
elif [ "$RUN_MIGRATIONS_SAFE" = "1" ] ; then
  msg "Running DB migrations (nondestructive)";
  (cd "$CMD_DIR" ; $ARTISAN migrate || exit 1) || errHandler
  $ARTISAN migrate:status || errHandler
else
  msg "Skipping DB Migrations";
fi

# Run DB Seeder
if [ "$RUN_DB_SEED" = "1" ] ; then
  msg "Running DB seeds";
  (cd "$CMD_DIR" ; $ARTISAN db:seed --force  || exit 1) || errHandler
else
  msg "Skipping DB seeds";
fi


# Run Vendor Publish
if [ "$RUN_VENDOR_PUBLISH" = "1" ] ; then
  msg "Running Vendor Publish";
  (cd "$CMD_DIR" ; $ARTISAN vendor:publish --all  || exit 1) || errHandler
else
  msg "Skipping Vendor Publish";
fi

echo ""
echo "#####################################################"
echo "       Provisioning Complete - starting Nginx/FPM"
echo "#####################################################"
echo ""

# Exiting
exit 0;
