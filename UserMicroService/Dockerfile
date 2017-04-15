# Image de base
FROM clos5wift

#Install du micro service
COPY /userService /usr/src/UserMicroService
WORKDIR /usr/src/UserMicroService
RUN swift build
CMD .build/debug/UserMicroService
