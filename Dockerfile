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

# re-create the image without all of the build tools/artefacts
FROM alpine:latest
RUN apk add --no-cache libusb ncurses-libs
COPY --from=0 /usr/local/bin/* /usr/local/bin/
COPY --from=0 /etc/udev/rules.d/rtl-sdr.rules /etc/udev/rules.d/rtl-sdr.rules
COPY --from=0 /usr/local/lib/librtlsdr* /usr/local/lib/

# Just expose the BEAST output port
CMD dump1090 --net --quiet --fix
EXPOSE 30005
