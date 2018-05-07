echo "# This file is not committed, it is system-specific data" > local.env
echo "UID=`id -u $USER`" >> local.env
echo "GID=`id -g $USER`" >> local.env
