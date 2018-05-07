FROM benyanke/php7:7.2

MAINTAINER "Ben Yanke" <ben@benyanke.com>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    supervisor \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/log/supervisor /var/www

COPY laravel-queue-supervisor.conf /etc/supervisor/conf.d/laravel-queue.conf

VOLUME ["/var/log/supervisor", "/var/www"]

CMD ["/usr/bin/supervisord"]
