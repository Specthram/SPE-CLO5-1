FROM clos5wift

#Install du micro service
COPY /hotelService /usr/src/HotelsMicroService
WORKDIR /usr/src/HotelsMicroService
RUN swift build
CMD .build/debug/HotelsMicroService
