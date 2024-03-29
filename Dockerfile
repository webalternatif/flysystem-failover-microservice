FROM php:8.0.12-cli-alpine

RUN apk add --no-cache \
  # Required packages
  postgresql-dev pwgen supervisor \
  # Convenient packages
  bash nano

# Install supervisor-stdout
RUN apk add --no-cache git py3-pip && \
  pip install git+https://github.com/coderanger/supervisor-stdout && \
  apk del git py3-pip

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql pdo_pgsql

# Link default php.ini config file
RUN ln -s "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Install composer
RUN set -eux; \
  curl --silent --fail --location --retry 3 --output /tmp/installer.php --url https://raw.githubusercontent.com/composer/getcomposer.org/cb19f2aa3aeaa2006c0cd69a7ef011eb31463067/web/installer; \
  php -r " \
    \$signature = '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5'; \
    \$hash = hash('sha384', file_get_contents('/tmp/installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
      unlink('/tmp/installer.php'); \
      echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
      exit(1); \
    }"; \
  php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=2.1.6; \
  composer --ansi --version --no-interaction; \
  rm -f /tmp/installer.php; \
  find /tmp -type d -exec chmod -v 1777 {} +

# Create and set the working directory
RUN mkdir -p /opt/app
WORKDIR /opt/app

# Install dependencies
COPY ./composer.json /opt/app/composer.json
COPY ./composer.lock /opt/app/composer.lock
COPY ./symfony.lock  /opt/app/symfony.lock
RUN composer install --prefer-dist --no-scripts --no-dev --no-autoloader && \
  rm -rf ~/.composer

# Copy supervisor configuration
COPY ./docker/supervisor/ /etc/supervisor.d

# Copy entrypoint
COPY ./docker/entrypoint.sh /entrypoint.sh

# Create scripts in /usr/local/bin to easily run Symfony commands
COPY ./docker/create-scripts.sh /create-scripts.sh
RUN /create-scripts.sh list-messages process-messages sync && \
  rm /create-scripts.sh

# Copy codebase
COPY ./bin/    bin
COPY ./config/ config
COPY ./public/ public
COPY ./src/    src
COPY ./.env    .env

# Finish composer
RUN composer dump-autoload --no-scripts --no-dev --optimize

ENV APP_ENV=prod \
    DISABLE_SCAN=false \
    NB_WORKERS=1 \
    NB_MSG_PER_WORKER=10 \
    SCAN_INTERVAL=300

ENTRYPOINT ["/entrypoint.sh"]
