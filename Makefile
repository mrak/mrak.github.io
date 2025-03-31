.PHONY: build markdowns stylesheets blog-index images start clean

build: markdowns stylesheets blog-index images

markdowns:
	build/build.sh markdowns

blog-index:
	build/build.sh blog_index

stylesheets:
	mkdir -p docs/css
	sassc --sourcemap=auto --style expanded src/sass/styles.scss docs/css/styles.css

images:
	mkdir -p docs/img
	cp src/img/* docs/img

start:
	nginx -c nginx.conf -p .

clean:
	rm -rf docs
