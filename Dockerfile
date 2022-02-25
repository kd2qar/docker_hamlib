FROM debian:stretch-slim
LABEL maintainer="Mark Vincett <markvincett@gmail.com>"

#EXPOSE 631
#COPY ./etc/ /etc/
#COPY ./root/ /root/
#COPY ./apt_cleanup.sh /
#COPY ./dockerstart.sh /

COPY . .

WORKDIR /root
#RUN pwd && ls -alh && ls -alh /root/
RUN apt-get update; 
RUN apt-get -y install --no-install-recommends git build-essential autoconf automake libtool git texinfo cmake;
RUN apt-get -y install --no-install-recommends libsamplerate0-dev libsamplerate0  libportaudio2 libjack0 portaudio19-dev libfltk1.3 libfltk1.3-dev libpulse-dev pavucontrol
#RUN apt-get -y install aptitude; aptitude search libpng
RUN apt-get -y install --no-install-recommends libpng-dev swig
RUN apt-get -y install python3 python3-dev
ENV  PYTHON /usr/bin/python3

RUN git clone git://git.code.sf.net/p/hamlib/code hamlib

RUN apt-get -y install libxml2-dev libperl-dev tcl-dev libgd2-dev libusb-dev libreadline-dev texlive pkg-config
WORKDIR /root/hamlib
RUN ./bootstrap
#RUN ./configure --help

RUN ./configure --with-python-binding
#RUN pwd
#RUN ls -alh
#RUN cat Makefile
RUN make
RUN make install

#RUN apt-get -y  install --no-install-recommends cloudprint && \
#     /bin/bash /apt_cleanup.sh &&\
#     rm -f /apt_cleanup.shi;
# PREREQS
#RUN apt-get update; 
#RUN apt-get -y install vim locate wget;

#RUN apt-get -y install libc6-i386 
#RUN apt-get -y install libc6;
#RUN mkdir /var/spool/lpd || true;
#RUN ln -s /etc/init.d/cupsys /etc/init.d/lpd || true;
#RUN cd drivers/ && \
#     dpkg -i --force-all  dcp7065dnlpr-2.1.0-1.i386.deb && \
#     dpkg -i --force-all cupswrapperDCP7065DN-2.0.4-2.i386.deb ; 
#RUN  dpkg -l | grep  Brother;
#RUN cp /root/cupsd.conf /etc/cups/

#COPY ./etc/cups/ /etc/cups/

#RUN fail;

#COPY ./authfile.json /var/lib/cloudprintd/
#WORKDIR /root
#RUN ls -alh
#RUN ls -alh /usr/bin/python
#VOLUME ["/root"]

CMD ["/bin/bash"] 

