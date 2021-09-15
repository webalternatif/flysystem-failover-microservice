#!/bin/bash

if [ -n "$@" ]; then
  exec "$@"
fi

if [ -z "$STORAGES" ]; then
    echo "You must set the STORAGES environment variable."
    exit 1
fi

# Clear and warmup cache
su -s /bin/sh www-data -c 'php bin/console cache:clear --no-warmup'
su -s /bin/sh www-data -c 'php bin/console cache:warmup'

# Remove supervisor configuration file to disable scan
if [ "$DISABLE_SCAN" = "true" ] || [ "$DISABLE_SCAN" = "1" ]; then
  rm /etc/supervisor.d/scanner.ini
fi

supervisord -n
