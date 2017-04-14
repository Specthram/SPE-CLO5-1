# Image de base
FROM debian:jessie

#ajout dépendences basiques
RUN apt-get update -qq
RUN apt-get install -y wget curl phpunit sendmail

#Ajout des sources pour php7
RUN echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list
RUN wget -O- https://www.dotdeb.org/dotdeb.gpg | apt-key add -

#ajout des sources de java 8
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

#ajout des sources pour cassandra
RUN echo "deb http://debian.datastax.com/community stable main" | tee -a /etc/apt/sources.list.d/cassandra.sources.list
RUN curl -L https://debian.datastax.com/debian/repo_key | apt-key add -

#mise a jour du dépot
RUN apt-get update -qq

#installation de java 8, php7, cassandra et composer
RUN apt-get install -y oracle-java8-installer
RUN apt-get install -y oracle-java8-set-default
RUN apt-get install -y php7.0 php7.0-fpm php7.0-mysql php7.0-curl php7.0-json php7.0-gd php7.0-mcrypt php7.0-msgpack php7.0-memcached php7.0-intl php7.0-sqlite3 php7.0-gmp php7.0-geoip php7.0-mbstring php7.0-xml php7.0-zip
RUN apt-get install -y dsc30 cassandra-tools
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN php -v
RUN cassandra -v
RUN composer -v

WORKDIR /usr/src/BookingMicroService
RUN nohup php -S 0.0.0.0:8085 &
CMD .build/debug/BookingMicroService