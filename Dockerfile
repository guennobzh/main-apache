FROM debian:stable
MAINTAINER Guenno < guenno@tybihan.net >

RUN apt-get update && apt-get install -y\
	apt-utils\
	apache2\ 
	php\
	php-mysql


ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR

RUN a2enmod rewrite
RUN a2enmod expires
RUN a2enmod headers
RUN a2enmod cgi
RUN a2enmod remoteip

ADD 000-default.conf /etc/apache2/sites-enabled

RUN cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak
RUN sed 's/LogFormat "%h %l %u %t \\"%r\\" %>s %O \\"%{Referer}i\\" \\"%{User-Agent}i\\"" combined/LogFormat "%a %l %u %t \\"%r\\" %>s %b \\"%{Referer}i\\" \\"%{User-Agent}i\\"" combined/g' /etc/apache2/apache2.conf.bak > /etc/apache2/apache2.conf

EXPOSE 80

CMD /usr/sbin/apache2ctl -D FOREGROUND
