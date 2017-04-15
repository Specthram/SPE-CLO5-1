# Image de base
FROM ubuntu:16.04

RUN apt-get -q update && apt-get -q install -y make libc6-dev clang curl libedit-dev python2.7 python2.7-dev libicu-dev libssl-dev libxml2 git libcurl4-openssl-dev pkg-config wget uuid-dev openssl libstdc++6 libtinfo-dev

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