## HAMLIB
#
#  build hamlib images for use as FROM sources for other containers
#
#
TAG=kd2qar/hamlib
TAG4=kd2qar/hamlib4
TAG3=kd2qar/hamlib3
NAME=hamlib


all:: build

# build two images one for hamlib 4 and one for hamlib 3
# breaking changes in hamlib 4 necessitate the availability of both images
#
build:
	docker build --pull --force-rm --build-arg BRANCH=master --tag=${TAG4} --tag=${TAG} .
	docker build --pull --force-rm --build-arg BRANCH=Hamlib-3.3 --tag=${TAG3} . 

shell:
	docker run --interactive --rm --tty  $(TAG4) /bin/bash
shell3:
	docker run --interactive --rm --tty ${TAG3} /bin/bash
test:
	docker run --privileged -it --rm -v /dev/bus/usb:/dev/bus/usb  $(TAG4)  

#run:
#	docker run --privileged -d --restart=always -v /dev/bus/usb:/dev/bus/usb  ${NAME} --name hamlib
