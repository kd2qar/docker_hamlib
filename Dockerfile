FROM debian:bullseye-slim as build
LABEL maintainer="Mark Vincett <markvincett@gmail.com>"

ARG BRANCH=master

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
WORKDIR /root/hamlib
RUN git checkout ${BRANCH}

WORKDIR /root/hamlib/build
RUN ../bootstrap
RUN ../configure --help >/root/configure.txt
RUN ../configure --with-python-binding --prefix=/tmp/built
RUN make clean
RUN make
RUN make install

FROM debian:bullseye-slim

LABEL maintainer="Mark Vincett <kd2qar@gmail.com>"

COPY dot.bashrc /root/.bashrc

ENV DEBIAN_FRONTEND="noninteractive" TZ="America/New_York"

RUN apt-get update && apt-get -y upgrade;\
    apt-get install -y  libusb-1.0-0 libnova-0.16-0 libgd3 zlib1g libltdl7 libreadline8;\
### Cleanup
        apt-get autoremove --purge -y || true && \
        apt-get clean || true && \
        apt-get autoclean; \
## Clean up the apt debris
rm -rf /var/lib/apt/lists/* || true && \
        rm -rf /tmp/* /var/tmp/ || true && \
        rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true ;  

#COPY --from=build /tmp/built /root/built

COPY --from=build /tmp/built/lib       /usr/local/lib
COPY --from=build /tmp/built/bin       /usr/local/bin
COPY --from=build /tmp/built/include   /usr/local/include
COPY --from=build /tmp/built/share     /usr/local/share
RUN ldconfig

#RUN du -hs /usr/local/lib
#RUN du -hs /usr/local/share/


#COPY --from=build /root/configure.txt /root/configure.txt

## COPY THE HAMLIB BINARIES TO THE INSTALL LOCATIONS
#RUN mv /root/built/lib/* /usr/local/lib/ &&\
#    mv /root/built/bin/* /usr/local/bin/ && \
#    mv /root/built/include/* /usr/local/include/ && \
#    mv /root/built/share/* /usr/local/share/ && \
#    rm -rf  /root/built && \
#     ldconfig

#RUN ls -alh /usr/local/lib
WORKDIR /root/

CMD ["/bin/bash"] 

