FROM debian:stretch
MAINTAINER mrxra


# ========== apache
RUN apt-get update && apt-get install -y --no-install-recommends \
		apache2 \
	&& rm -rf /var/lib/apt/lists/*

# php requires preforking apache
RUN a2dismod mpm_event && a2enmod mpm_prefork

RUN rm -rf /var/www/html \
	&& mkdir -p /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www/html \
	&& chown -R www-data:www-data /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www/html

# ...checked during php compilation
RUN mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf.orig
COPY apache2.conf /etc/apache2/apache2.conf

RUN apt-get update && apt-get install -y --no-install-recommends \
		python-certbot-apache \
	&& rm -rf /var/lib/apt/lists/*
#	&& certbot --apache


# ========== php
# sample dockerfile compiling php from source...
# https://github.com/docker-library/php
RUN apt-get update && apt-get install -y --no-install-recommends \
		gcc \
		g++ \
		autoconf \
		pkg-config \
		make \
		re2c \
		libtool \
		bison \
		flex \

		ca-certificates \
		curl \
		libxml2 \
	&& rm -r /var/lib/apt/lists/*


ENV PHP_VERSION 7.0.10

ENV PREFIX /usr/local
ENV PHP_CFG $PREFIX/etc/php
ENV PHP_SRC $PREFIX/src/php

# http://php.net/manual/en/install.unix.php
RUN set -xe && apt-get update && apt-get install -y --no-install-recommends \
		apache2-dev \
		libcurl4-openssl-dev \
		libssl-dev \
		libxml2-dev \
		xz-utils \
	&& rm -rf /var/lib/apt/lists/* \

	# --- download php tar.xz
	&& mkdir -p $PHP_SRC \
	&& mkdir -p $PHP_CFG/conf.d \
	&& curl -fSL "http://php.net/get/php-$PHP_VERSION.tar.xz/from/this/mirror" \
		| tar -xJC $PHP_SRC --strip-components=1 -f - \
	&& cd $PHP_SRC \
	# --- ./configure --help (for supported options...)
	&& ./configure \
		--prefix="$PREFIX" \
		--with-config-file-path="$PHP_CFG" \
		--with-config-file-scan-dir="$PHP_CFG/conf.d" \
		--with-apxs2 \
		--disable-cgi \
		# mysql native driver
		--enable-mysqlnd \
		--enable-mbstring \
		--with-curl \
		--with-openssl \
		--with-zlib \
	&& make -j"$(nproc)" && make install && make clean

# ========== nextcloud
# install required/recommended php modules and their respective dependencies
# https://doc.owncloud.org/server/9.0/admin_manual/installation/source_installation.html#prerequisites
# http://php.net/manual/en/install.pecl.phpize.php#install.pecl.phpize
# list extensions...
# find /usr/local/src/php/ext -mindepth 2 -maxdepth 2 -type f -name 'config.m4' | cut -d/ -f6 | sort
ENV PHP_EXT "$PHP_SRC/ext/"

# --- module gd
RUN set -xe && apt-get update && apt-get install -y --no-install-recommends \
		libjpeg-dev \
		libpng-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& cd $PHP_EXT/gd \
	&& phpize \
	&& ./configure \
	&& make -j"$(nproc)" && make install && make clean \
	&& echo "extension=gd.so" > "$PHP_CFG/conf.d/gd.ini"
# --- module exif
RUN cd $PHP_EXT/exif \
	&& phpize \
	&& ./configure \
	&& make -j"$(nproc)" && make install && make clean \
	&& echo "extension=exif.so" > "$PHP_CFG/conf.d/exif.ini"
# --- module zip
RUN set -xe && apt-get update && apt-get install -y --no-install-recommends \
		libzip-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& cd $PHP_EXT/zip \
	&& phpize \
	&& ./configure \
	&& make -j"$(nproc)" && make install && make clean \
	&& echo "extension=zip.so" > "$PHP_CFG/conf.d/zip.ini"
# --- module bz2
RUN set -xe && apt-get update && apt-get install -y --no-install-recommends \
		libbz2-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& cd $PHP_EXT/bz2 \
	&& phpize \
	&& ./configure \
	&& make -j"$(nproc)" && make install && make clean \
	&& echo "extension=bz2.so" > "$PHP_CFG/conf.d/bz2.ini"
# --- module pdo_mysql
RUN cd $PHP_EXT/pdo_mysql \
	&& phpize \
	&& ./configure \
	&& make -j"$(nproc)" && make install && make clean \
	&& echo "extension=pdo_mysql.so" > "$PHP_CFG/conf.d/pdo_mysql.ini"
# --- module fileinfo
RUN cd $PHP_EXT/fileinfo \
	&& phpize \
	&& ./configure \
	&& make -j"$(nproc)" && make install && make clean \
	&& echo "extension=fileinfo.so" > "$PHP_CFG/conf.d/fileinfo.ini"
# --- module opcache
RUN cd $PHP_EXT/opcache \
	&& phpize \
	&& ./configure \
	&& make -j"$(nproc)" && make install && make clean \
	&& echo "zend_extension=opcache.so" > "$PHP_CFG/conf.d/opcache.ini"
# --- module pcntl
RUN cd $PHP_EXT/pcntl \
	&& phpize \
	&& ./configure \
	&& make -j"$(nproc)" && make install && make clean \
	&& echo "extension=pcntl.so" > "$PHP_CFG/conf.d/pcntl.ini"
# --- module libmcrypt-dev
RUN set -xe && apt-get update && apt-get install -y --no-install-recommends \
		libmcrypt-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& cd $PHP_EXT/mcrypt \
	&& phpize \
	&& ./configure \
	&& make -j"$(nproc)" && make install && make clean \
	&& echo "extension=mcrypt.so" > "$PHP_CFG/conf.d/mcrypt.ini"
# --- module intl
RUN set -xe && apt-get update && apt-get install -y --no-install-recommends \
		libicu-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& cd $PHP_EXT/intl \
	&& phpize \
	&& ./configure \
	&& make -j"$(nproc)" && make install && make clean \
	&& echo "extension=intl.so" > "$PHP_CFG/conf.d/intl.ini"
# --- module imagick
RUN set -xe && apt-get update && apt-get install -y --no-install-recommends \
		imagemagick \
		libmagickwand-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& pecl install imagick \
	&& echo "extension=imagick.so" > "$PHP_CFG/conf.d/imagick.ini"


ENV NC_VERSION 9.0.53
ENV NC_HOME /var/www/html/nextcloud 
ENV NC_DATA /nextcloud

RUN mkdir -p ${NC_HOME} \
	&&	curl -fSL "https://download.nextcloud.com/server/releases/nextcloud-${NC_VERSION}.tar.bz2" \
		| tar -xjC ${NC_HOME} --strip-components 1 -f - \
    # linking config and data directories to volume
    && mkdir -p ${NC_DATA}/config && rm -rf ${NC_HOME}/config && ln -sf ${NC_DATA}/config ${NC_HOME}/config \
	&& mkdir -p ${NC_DATA}/data && rm -rf ${NC_HOME}/data && ln -sf ${NC_DATA}/data ${NC_HOME}/data \
	&& chown -R www-data:www-data ${NC_HOME} ${NC_DATA}


WORKDIR ${NC_HOME}
VOLUME ${NC_DATA}
EXPOSE 80

# remove any left over pid files...otherwise container might not startup...
CMD rm -f /var/run/apache2/apache2.pid && apache2ctl -D FOREGROUND

