#!/bin/bash

# This runs on container startup.
# Ensure it returns exit code 0, otherwise the container will not continue to startup.

# Here is an example command which dumps the current env to /tmp/env
env > /tmp/env

##########
# Run commands for bootstrapping dev env
##########

# change www-data user to provided UID/GID
usermod  -u $UID www-data
groupmod -g $GID www-data

# Fix filesystem permissions based on UID/GID provided by ENV
if [ "$RUN_PERMISSION_FIX" = "1" ] ; then
  echo "Running permission fix";
  # chown -R $UID:$GID "$CMD_DIR"
  find "$CMD_DIR" -user "$UID" -exec chown -h foo {} \;
  find "$CMD_DIR" -group "$GID" -exec chgrp -h foo {} \;
else
  echo "Skipping permission fix";
fi

# Composer install packages
if [ "$RUN_COMPOSER" = "1" ] ; then
  echo "Running composer install";
  (cd $CMD_DIR ; composer install --no-interaction )
else
  echo "Skipping composer install;
fi

# Run Webpack
if [ "$RUN_WEBPACK" = "1" ] ; then
  echo "Running Laravel Mix";
  (cd $CMD_DIR ; echo "Not yet implemented" )
else
  echo "Skipping Laravel Mix";
fi

# Run DB Migrations
if [ "$RUN_MIGRATIONS" = "1" ] ; then
  echo "Running DB Migrations";
  (cd $CMD_DIR ; artisan migrate )
else
  echo "Skipping DB Migrations";
fi

# Run DB Seeder
if [ "$RUN_DB_SEED" = "1" ] ; then
  echo "Running DB seeds";
  (cd $CMD_DIR ; artisan db:seed --force )
else
  echo "Skipping DB seeds";
fi


# Run Vendor Publish
if [ "$RUN_VENDOR_PUBLISH" = "1" ] ; then
  echo "Running Vendor Publish";
  (cd $CMD_DIR ; artisan vendor:publish --all )
else
  echo "Skipping Vendor Publish";
fi



# Exiting
echo "Startup complete!"
exit 0;
