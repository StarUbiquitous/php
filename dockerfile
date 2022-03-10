FROM php:7.2.34-fpm-alpine3.12

RUN set -ex; \
    apk update; \
    apk upgrade; \
    apk add --no-cache nginx supervisor mediainfo 

# Add Build Dependencies
RUN apk update && apk add --no-cache --virtual .build-deps  \
    zlib-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libxml2-dev \
    bzip2-dev \
    zip \
    postgresql-dev \
    postgresql-libs \
    $PHPIZE_DEPS

# Add Production Dependencies
RUN apk add --update --no-cache \
    jpegoptim \
    pngquant \
    optipng \
    nano \
    icu-dev \
    freetype-dev \
    libpq

# Configure & Install Extension
RUN docker-php-ext-configure \
    opcache --enable-opcache &&\
    docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ --with-freetype-dir=/usr/include/ && \
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql &&\
    docker-php-ext-install \
    opcache \
    pdo \
    pgsql \
    pdo_pgsql \
    sockets \
    intl \
    gd \
    xml \
    bz2 \
    pcntl \
    bcmath \
    exif