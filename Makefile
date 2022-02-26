
VERSION ?= 0.1.0
CACHE ?= --no-cache=1
CACHE ?= ""
FULLVERSION ?= ${VERSION}

archs = i386
archs = x64

TAG=kd2qar/hamlib
NAME=hamlib

all:: build

build:
	#cp -P ../apt_cleanup.sh .
	#$(foreach arch,$(archs), \
#		docker build --rm --tag=$(NAME):${VERSION}-${arch} ${CACHE} .; \
#	)
	docker build --pull --force-rm --tag=${TAG}  .

shell:
	docker run --interactive --rm --tty  $(TAG) /bin/bash
test:
	docker run --privileged -it --rm -v /dev/bus/usb:/dev/bus/usb  $(NAME)  
#run:
#	docker run --privileged -d --restart=always -v /dev/bus/usb:/dev/bus/usb  ${NAME} --name hamlib
