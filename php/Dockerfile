FROM php:8.3-apache-bookworm

LABEL maintainer="Jakub Bouček <pan@jakubboucek.cz>"
LABEL org.label-schema.name="PHP 8.3 (Apache module)"
LABEL org.label-schema.vcs-url="https://github.com/jakubboucek/docker-lamp-devstack"
LABEL author="Michael Harwood"

# Workdir during installation
WORKDIR /tmp

# Use local mirrors to install Debian updates
COPY sources.list-bookworm /etc/apt/sources.list

# Prevent interactive block
ARG DEBIAN_FRONTEND=noninteractive

# OS binaries install && update critical binaries
RUN set -eux; \
    apt-get update; \
    apt-get install --no-install-recommends -y \
        ca-certificates \
        git \
        libavif-dev \
        libbz2-dev \
        libfreetype6-dev \
        libgmp-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libssl-dev \
        libmemcached-dev \
        libpng-dev \
        libsodium-dev \
        libwebp-dev \
        libxslt-dev \
        libzip-dev \
        zlib1g-dev \
        vim \
        openssl \
        tzdata \
        unzip \
        zip; \
    docker-php-ext-install -j$(nproc) \
        bcmath \
        bz2 \
        calendar \
        exif \
        gd \
        gettext \
        gmp \
        intl \
        mysqli \
        opcache \
        pcntl \
        sockets \
        sodium \
        sysvmsg \
        sysvsem \
        sysvshm \
        xsl \
        zip; \
    a2enmod \
        rewrite; \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/cache/* /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/*;

# Configure Apache & PHP
# 32767 = E_ALL
ENV PHP_ERROR_REPORTING 32767
ENV PHP_DISPLAY_ERRORS 1
ENV PHP_DISPLAY_STARTUP_ERRORS 1
ENV PHP_ERROR_LOG ""
ENV PHP_LOG_ERRORS 0
ENV PHP_MAX_EXECUTION_TIME 30
ENV PHP_MEMORY_LIMIT 2G
ENV PHP_SESSION_SAVE_PATH ""
ENV TZ UTC
COPY core.ini /usr/local/etc/php/conf.d/core.ini

# Configure OPcache
ENV PHP_OPCACHE_BLACKLIST_FILENAME ""
ENV PHP_OPCACHE_ENABLE 1
ENV PHP_OPCACHE_ENABLE_CLI 0
ENV PHP_OPCACHE_MEMORY_CONSUPTION 128
ENV PHP_OPCACHE_PRELOAD ""
ENV PHP_OPCACHE_PRELOAD_USER ""
ENV PHP_OPCACHE_REVALIDATE_FREQ 2
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS 1
COPY opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY opcache-7.4.ini /usr/local/etc/php/conf.d/opcache-7.4.ini

# Install Mecached extension
RUN set -eux; \
    pecl install memcached; \
    pecl clear-cache; \
    docker-php-ext-enable memcached; \
    rm -rf /tmp/* /var/tmp/*;

# -- I'm not sure that the following is necessary, since we're using the defaults --#
# Set Apache document root 
ENV APACHE_DOCUMENT_ROOT /var/www/html

# Expose Apache listening port
ENV PORT 80

# Setup Devstack (install Composer, setup DocumentRoot and Port)
RUN set -eux; \
    sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf; \
    sed -ri -e 's!:80>!:${PORT}>!g' /etc/apache2/sites-available/*.conf; \
    sed -ri -e 's!Listen 80!Listen ${PORT}!g' /etc/apache2/ports.conf; \
    rm -rf /tmp/*;

RUN echo 'alias ll="ls -l"' >> ~/.bashrc

# Workdir after installation
WORKDIR /var/www/html

# docker build -t lamp-myphp .
