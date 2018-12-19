FROM php:7-fpm-alpine
MAINTAINER Andre Metzen <metzen@conceptho.com>

ENV TERM=xterm

RUN apk add --update \
        libxml2-dev \
        libressl libressl-dev \
        freetype freetype-dev \
        libjpeg-turbo libjpeg-turbo-dev \
        libpng libpng-dev \
        libmcrypt-dev \
        libzip-dev \
        curl-dev \
        icu-dev \
        bash \
        git \
        ca-certificates \
        nodejs \
        autoconf \
        nano && \
        apk add --virtual build-dependencies build-base gcc wget

RUN docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ && \
    NPROC=$(getconf _NPROCESSORS_ONLN) && \
    docker-php-ext-install -j${NPROC} gd && \
    apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

RUN docker-php-ext-install \
    json \
    xml \
    pdo \
    phar \
    curl \
    dom \
    intl \
    ctype \
    intl \
    pdo_mysql \
    mysqli \
    opcache \
    iconv \
    session \
    mysqli \
    zip && \
    pecl channel-update pecl.php.net && \
    pecl install redis-4.2.0 && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/bin/composer

COPY php.ini /usr/local/etc/php/