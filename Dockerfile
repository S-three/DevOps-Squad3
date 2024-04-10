FROM ubuntu

MAINTAINER affankhan aff.khan34@gmail.com

RUN apt-get update -y

RUN apt-get install apache2 -y && \
    apt-get clean

COPY ./html/ /var/www/html/

WORKDIR /var/www/html/

CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]

EXPOSE 80
