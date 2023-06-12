FROM ubuntu

MAINTAINER iamsaikishore saikishorepro28@gmail.com

RUN apt-get update -y

RUN apt-get install apache2 -y && \
    apt-get clean

COPY index.html /var/www/html/

COPY css /var/www/html/css/

WORKDIR /var/www/html/

CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]

EXPOSE 80
