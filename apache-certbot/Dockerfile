FROM debian:stretch
MAINTAINER mrxra

RUN apt-get update && apt-get install -y --no-install-recommends \
		apache2 \
		python-certbot-apache \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

EXPOSE 80
EXPOSE 443

VOLUME /etc/letsencrypt

CMD rm -f /var/run/apache2/apache2.pid && apache2ctl -D FOREGROUND

