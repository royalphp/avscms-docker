# syntax=docker/dockerfile:1

FROM php:5.6-apache AS app_base

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN sed -i "s|http://deb.debian.org/debian|http://archive.debian.org/debian|g" /etc/apt/sources.list && \
    sed -i "/deb http:\/\/security.debian.org\/debian-security stretch\/updates/d" /etc/apt/sources.list && \
    sed -i "/stretch-updates/d" /etc/apt/sources.list && \
    apt-get update && apt-get install -y --no-install-recommends ffmpeg && \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
	install-php-extensions \
		gd \
		mysqli \
	;

COPY --link "docker/php/conf.d/app.ini" "$PHP_INI_DIR/conf.d/"

COPY --link "docker/apache/avscms.conf" "$APACHE_CONFDIR/sites-available/"
RUN a2dissite 000-default.conf && a2ensite avscms.conf

COPY --link "docker/server-entrypoint.sh" "/usr/local/bin/server-entrypoint"
RUN chmod +x "/usr/local/bin/server-entrypoint"

COPY --link --chmod=755 "docker/php/docker-entrypoint.sh" "/usr/local/bin/docker-entrypoint"
ENTRYPOINT ["docker-entrypoint"]
CMD ["apache2-foreground"]


FROM app_base AS app_prod

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY --link "docker/php/conf.d/app.prod.ini" "$PHP_INI_DIR/conf.d/"

USER www-data


FROM app_base AS app_dev

RUN set -eux; \
	install-php-extensions \
		xdebug \
	;

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
COPY --link "docker/php/conf.d/app.dev.ini" "$PHP_INI_DIR/conf.d/"
