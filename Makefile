.PHONY: build start clean

build: docs

docs: docs/index.html docs/blog/index.html docs/css docs/img

docs/index.html: src/markdown
	build/build.sh markdowns

docs/blog/index.html: src/markdown/blog src/html
	build/build.sh blog_index

start:
	nginx -c nginx.conf -p .

docs/css: src/sass $(shell find src/sass -type f)
	mkdir -p docs/css
	sassc --sourcemap=auto --style expanded src/sass/styles.scss docs/css/styles.css

docs/img: src/img $(shell find src/img -type f)
	mkdir -p docs/img
	cp src/img/* docs/img

clean:
	rm -rf docs
