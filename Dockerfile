FROM alpine:latest

# rtl-sdr
RUN apk add libusb git build-base cmake libusb-dev
RUN git clone git://git.osmocom.org/rtl-sdr.git /tmp/rtl-sdr
RUN mkdir /tmp/rtl-sdr/build
WORKDIR /tmp/rtl-sdr/build
RUN cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON
RUN make
RUN make install

# dump1090
RUN git clone https://github.com/flightaware/dump1090.git /tmp/dump1090
WORKDIR /tmp/dump1090
RUN apk add ncurses-dev
RUN make BLADERF=no
RUN cp dump1090 view1090 /usr/local/bin/
