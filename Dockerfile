# La versione sul server e' Debian 10
FROM php:5.6-apache
#MAINTAINER porchn <pichai.chin@gmail.com>

ENV TZ=Europe/Paris
# Set Server timezone.
RUN echo $TZ > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata \
    && echo date.timezone = $TZ > /usr/local/etc/php/conf.d/docker-php-ext-timezone.ini

RUN mkdir -p /etc/apache2/ssl

# Defaul config php.ini
COPY ./config/php.ini /usr/local/etc/php/

# RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y update \
    && apt-get install -y --no-install-recommends \
    pdftk \
    libmemcached11 \
    libmemcachedutil2 \
    libmemcached-dev \
    libz-dev \
    build-essential \
    apache2-utils \
    libmagickwand-dev \
    imagemagick \
    libcurl4-openssl-dev \
    libssl-dev \
    libc-client2007e-dev \
    libkrb5-dev \
    libmcrypt-dev \
    unixodbc-dev \
    libav-tools \
    ffmpeg \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*


# Config Extension 
RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/lib \
    && docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
    && docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr

# Install Extension mysqli mysql mbstring opcache pdo_mysql gd mcrypt zip imap bcmath soap pdo
# Old command

RUN docker-php-ext-install mysqli mysql mbstring opcache pdo_mysql gd mcrypt zip imap soap pdo pdo_odbc

RUN apt-get update \
  && apt-get install -y mysql-server mysql-client default-libmysqlclient-dev --no-install-recommends \
  && docker-php-ext-install pdo pdo_mysql \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN apt-get update \
    && apt-get install -y vim

# Enable Apache mod_rewrite
RUN a2enmod rewrite ssl headers

# Memcache
RUN pecl install memcached-2.2.0 \
    && docker-php-ext-enable memcached

# Imagick
RUN pecl install imagick \
    && docker-php-ext-enable imagick

# Additional dependences
RUN pear install http_request2
    
RUN chown -R www-data:www-data /var/www

# start mysqld
RUN service mysql start 

# Create Volume
VOLUME ['/etc/apache2/sites-enabled','/var/www','/var/log/apache2']

ENV EDITOR=vim

EXPOSE 80
EXPOSE 443
EXPOSE 3306
