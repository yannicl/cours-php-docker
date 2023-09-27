FROM php:8.2.10-fpm

COPY create-users.sh /opt/create-users.sh
RUN /opt/create-users.sh

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

RUN docker-php-ext-install pdo_mysql


