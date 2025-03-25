.PHONY: build start clean

build: docs/css docs/blog/index.html
	build/build.sh markdowns

docs/blog/index.html: src/markdown/blog
	build/build.sh blog_index

start:
	nginx -c nginx.conf -p .

docs/css: src/sass
	mkdir -p docs/css
	sassc --sourcemap=auto --style expanded src/sass/styles.scss docs/css/styles.css

clean:
	rm -rf docs
