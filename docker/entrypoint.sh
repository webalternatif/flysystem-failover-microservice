#!/bin/bash

# Delete and create the www-data user with given USER_ID:GROUP_ID if provider (and different than 0)
if [ "${USER_ID:-0}" -ne 0 ] && [ "${GROUP_ID:-0}" -ne 0 ]; then
  deluser --remove-home www-data
  if getent group www-data; then
    delgroup www-data
  fi
  addgroup -g ${GROUP_ID} www-data 2>/dev/null
  adduser -u ${USER_ID} -D -H -G $(getent group ${GROUP_ID} | cut -d: -f1) www-data
  install -d -m 0755 -o www-data -g ${GROUP_ID} /home/www-data
  chown -c -f -h -R ${USER_ID}:${GROUP_ID} /home/www-data
fi

# Generate a new APP_SECRET
grep .env.local -qs -e '^APP_SECRET='
if [ $? -gt 0 ]; then
  echo APP_SECRET=$(pwgen -s1 40) >> .env.local
fi

if [ -n "$(echo $@)" ]; then
  exec "$@"
fi

if [ -z "$STORAGES" ]; then
  echo "You must set the STORAGES environment variable."
  exit 1
fi

# Clear and warmup cache
bin/exec bin/console cache:clear --no-warmup
bin/exec bin/console cache:warmup

# Remove supervisor configuration file to disable scan
if [ "$DISABLE_SCAN" = "true" ] || [ "$DISABLE_SCAN" = "1" ]; then
  rm /etc/supervisor.d/scanner.ini
fi

supervisord -n
