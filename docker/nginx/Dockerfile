FROM vcarreira/nginx-php7-fpm:latest

MAINTAINER "Ben Yanke" <ben@benyanke.com>

# Set to '1' to run these commands from running on container start
ENV RUN_PERMISSION_FIX 0
ENV RUN_COMPOSER 0
ENV RUN_WEBPACK 0
ENV RUN_MIGRATIONS 0
ENV RUN_DB_SEED 0
ENV RUN_VENDOR_PUBLISH 0

# Not yet implemented yet

ENV UID 1000
ENV GID 1000

# Install composer
WORKDIR /tmp
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN mkdir -p /var/www

WORKDIR /var/www

VOLUME /var/www

RUN composer self-update

COPY startup.sh /tmp/startup.sh

# ENTRYPOINT ["composer"]
# CMD ["--help"]

# CMD "/tmp/startup.sh && /usr/bin/supervisord"
CMD "/usr/bin/supervisord"

