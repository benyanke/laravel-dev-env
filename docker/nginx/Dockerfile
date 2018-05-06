FROM vcarreira/nginx-php7-fpm:latest

MAINTAINER "Vitor Carreira" <vitor.carreira@gmail.com>

# Install composer
WORKDIR /tmp
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN mkdir -p /var/www

WORKDIR /var/www

VOLUME /var/www

RUN composer self-update

ENTRYPOINT ["composer"]
CMD ["--help"]

