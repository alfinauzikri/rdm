FROM php:7.2-apache

LABEL org.opencontainers.image.title="Rapor Digital Madrasah (RDM) Docker Image"
LABEL org.opencontainers.image.description="Dockerized runtime environment for Rapor Digital Madrasah (RDM) with Apache, PHP 7.2, MySQL 5.7, and ionCube Loader."
LABEL org.opencontainers.image.authors="Alfin Auzikri <github.com/alfinauzikri>"

ENV TZ=Asia/Jakarta

RUN sed -i 's|deb.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
    sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
    sed -i '/buster-updates/d' /etc/apt/sources.list && \
    apt-get -o Acquire::Check-Valid-Until=false update

# Install system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    libcurl4-openssl-dev \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libxml2-dev \
    libonig-dev \
    && docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install \
        bcmath \
        exif \
        gd \
        mbstring \
        mysqli \
        opcache \
        pdo \
        pdo_mysql \
        soap \
        sockets \
        zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod \
    rewrite \
    headers \
    expires

# Configure Apache
COPY docker/apache.conf /etc/apache2/conf-available/rdm.conf
RUN a2enconf rdm

# Install ionCube Loader
RUN cd /tmp && \
    curl -fsSL https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz -o ioncube.tar.gz && \
    tar -xzf ioncube.tar.gz && \
    cp ioncube/ioncube_loader_lin_7.2.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/ && \
    echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20170718/ioncube_loader_lin_7.2.so" > /usr/local/etc/php/conf.d/00-ioncube.ini && \
    rm -rf /tmp/*

# PHP Configuration
COPY docker/php.ini /usr/local/etc/php/php.ini

# Bootstrap Entrypoint
COPY docker/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["apache2-foreground"]