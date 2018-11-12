FROM php:7-fpm-alpine
MAINTAINER Andre Metzen <metzen@conceptho.com>

# PHP Extensions
# json, zlib, xml, pdo, phar, curl, openssl, dom, intl, ctype, pdo_mysql, mysqli, opcache, memcached, redis, gd, iconv
# mcrypt, mbstring, session

# Pecl Extensions
# memcached redis

ENV TERM=xterm

RUN apk add --update \
        libxml2-dev \
        openssl-dev \
        freetype freetype-dev \
        libjpeg-turbo libjpeg-turbo-dev \
        libpng libpng-dev \
        libmcrypt-dev \
        curl-dev \
        icu-dev \
        bash \
        git \
        ca-certificates \
        nodejs \
        nano \
        openssl

RUN docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ && \
    NPROC=$(getconf _NPROCESSORS_ONLN) && \
    docker-php-ext-install -j${NPROC} gd && \
    apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

RUN docker-php-ext-install \
        json xml pdo phar  \
        curl dom intl ctype \
        pdo_mysql mysqli \
        opcache iconv \
        session mbstring zip && \
    pecl channel-update pecl.php.net && \
    pecl install redis-3.1.2 && \
    pecl install memcached-3.0.3 && \
    curl -O -sS https://getcomposer.org/installer && php installer --version=1.7.1 && mv composer.phar /usr/bin/composer

RUN update-ca-certificates

COPY php.ini /usr/local/etc/php/
