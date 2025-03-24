.PHONY: build start stylesheets
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

build:
	${ROOT_DIR}/build/build.sh

start:
	nginx -c ${ROOT_DIR}/nginx.conf -p ${ROOT_DIR}

stylesheets: docs/css/styles.css

docs/css/styles.css: src/sass
	mkdir -p docs/css
	sassc --sourcemap=auto --style expanded src/sass/styles.scss docs/css/styles.css

clean:
	rm -rf docs
