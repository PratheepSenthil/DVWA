FROM php:8.1-apache

#LABEL org.opencontainers.image.source="https://github.com/digininja/DVWA"
LABEL org.opencontainers.image.description="DVWA custom build for DevSecOps testing"
LABEL org.opencontainers.image.licenses="gpl-3.0"

WORKDIR /var/www/html

RUN apt-get update \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get install -y \
    zlib1g-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    mariadb-client \
    git \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && docker-php-ext-configure gd --with-jpeg --with-freetype \
 && docker-php-ext-install gd mysqli pdo pdo_mysql \
 && a2enmod rewrite

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

COPY . /var/www/html/
COPY config/config.inc.php.dist config/config.inc.php

RUN chown -R www-data:www-data /var/www/html

RUN cd /var/www/html/vulnerabilities/api \
 && composer install

EXPOSE 80
