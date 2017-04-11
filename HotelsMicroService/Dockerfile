# Image de base
FROM debian:jessie

#install tout les paquets nécessaire
RUN apt-get -q update && apt-get -q install -y make libc6-dev clang pkg-config libicu-dev libpython2.7 libxml2-dev wget git libssl-dev uuid-dev libsqlite3-dev libpq-dev libmysqlclient-dev libbson-dev libmongoc-dev libcurl4-openssl-dev 


#download de swift
RUN wget https://swift.org/builds/swift-3.0.2-release/ubuntu1604/swift-3.0.2-RELEASE/swift-3.0.2-RELEASE-ubuntu16.04.tar.gz

# extrait le zip et install
RUN gunzip < $(basename https://swift.org/builds/swift-3.0.2-release/ubuntu1604/swift-3.0.2-RELEASE/swift-3.0.2-RELEASE-ubuntu16.04.tar.gz) | tar -C / -xv --strip-components 1

RUN rm $(basename https://swift.org/builds/swift-3.0.2-release/ubuntu1604/swift-3.0.2-RELEASE/swift-3.0.2-RELEASE-ubuntu16.04.tar.gz)

RUN chmod -R 755 /usr/lib/swift

RUN touch /etc/ld.so.conf.d/swift.conf
RUN echo "/usr/lib/swift/linux" >> /etc/ld.so.conf.d/swift.conf 
RUN ldconfig
RUN swift --version

WORKDIR /usr/src/HotelsMicroService
RUN swift build
CMD .build/debug/HotelsMicroService