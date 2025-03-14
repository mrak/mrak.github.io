.PHONY: build start
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

build:
	${ROOT_DIR}/build/build.sh

start:
	nginx -c ${ROOT_DIR}/nginx.conf -p ${ROOT_DIR}
