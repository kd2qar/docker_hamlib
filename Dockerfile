FROM debian:bullseye-slim as build
LABEL maintainer="Mark Vincett <markvincett@gmail.com>"

WORKDIR /root

#RUN pwd && ls -alh && ls -alh /root/

RUN apt-get update && apt-get -y upgrade; 
ENV DEBIAN_FRONTEND="noninteractive" TZ="America/New_York"
RUN apt-get -y install aptitude;
RUN apt-get -y install --no-install-recommends git build-essential autoconf automake libtool texinfo cmake;
RUN apt-get -y install --no-install-recommends libsamplerate0-dev libsamplerate0  libportaudio2 libjack0 portaudio19-dev libfltk1.3 libfltk1.3-dev libpulse-dev pavucontrol

#RUN apt-get -y install aptitude; aptitude search libpng

RUN apt-get -y install --no-install-recommends libpng-dev swig
RUN aptitude search libgd*-dev
RUN apt-get -y install libgd-dev
RUN apt-get -y install libxml2-dev libperl-dev tcl-dev libusb-dev libreadline-dev texlive pkg-config
RUN apt-get -y install libusb-1.0-0 libusb-1.0-0-dev libnova-0.16-0 
RUN apt-get -y install python3 python3-dev python3-all-dev
RUN apt-get -y install dh-lua dh-python dpkg-dev libgd-dev libltdl3-dev libperl-dev swig tcl-dev texinfo zlib1g-dev

RUN apt-get -y install vim vim-common

COPY dot.bashrc /root/.bashrc

ENV  PYTHON /usr/bin/python3

RUN git clone git://git.code.sf.net/p/hamlib/code hamlib

WORKDIR /root/hamlib/build
RUN ../bootstrap
RUN ../configure --help >/root/configure.txt
RUN ../configure --with-python-binding --prefix=/tmp/built
RUN make clean
RUN make
RUN make install
#RUN pwd
#RUN ls -alh
#RUN cat Makefile

#RUN  dpkg-buildpackage -d -us -uc;
#RUN make install

#RUN aptitude search libgd && fail
#RUN aptitude search libreadline && fail

FROM debian:bullseye-slim as install
#FROM build as install

COPY dot.bashrc /root/.bashrc


RUN apt-get update && apt-get -y upgrade;
ENV DEBIAN_FRONTEND="noninteractive" TZ="America/New_York"
RUN apt-get install -y make;
RUN apt-get install -y  libusb-1.0-0 libnova-0.16-0 libgd3 zlib1g libltdl7
RUN apt-get install -y libreadline8

RUN mkdir /tmp/ramdisk
#RUN chmod 777 /tmp/ramdisk
#RUN mount -t tmpfs -o size=1024m myramdisk /tmp/ramdisk
#RUN ls /tmp/
#RUN mount -t tmpfs -o size=2m ff /tmp/ramdisk

#COPY --from=build /root/hamlib /tmp/ramdisk/hamlib
#COPY --from=build /root/hamlib/*.tar.gz /root/
COPY --from=build /tmp/built /root/built
COPY --from=build /root/configure.txt /root/configure.txt
RUN mv /root/built/lib/* /usr/local/lib/
RUN mv /root/built/bin/* /usr/local/bin/
RUN mv /root/built/include/* /usr/local/include/
RUN mv /root/built/share/* /usr/local/share/
RUN ldconfig
#RUN ls -alh /usr/local/lib
#WORKDIR /tmp/ramdisk/hamlib
#RUN make install && rm -rf *
WORKDIR /root/
#RUN make install


CMD ["/bin/bash"] 

