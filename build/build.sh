#!/bin/sh

COPYRIGHT_YEAR="$(date +%Y)"

markdown() {
  md="$1"
  target="${md%md}html"
  target="docs${target#src/markdown}"
  mkdir -p "$(dirname "$target")"
  ./build/preprocess_markdown.awk src/html/header.html src/html/footer.html "$md" \
    | pandoc -f gfm -t html \
    > "$target"
  sed -i -e "s/@COPYRIGHT@/${COPYRIGHT_YEAR}/g" "$target"
}

markdowns() {
  find src/markdown -type f \
  | while read -r md; do markdown "$md" & done
}

blog_index() {
  mkdir -p docs/blog
  env TITLE="Eric Mrak's blog" envsubst < src/html/header.html > docs/blog/index.html
  find src/markdown/blog -type f | sort -r | xargs ./build/blog_index.awk
  envsubst < src/html/footer.html >> docs/blog/index.html
}

stylesheets() {
  mkdir -p docs/css
  sassc --sourcemap=auto --style expanded src/sass/styles.scss docs/css/styles.css
}

main() {
  rm -rf docs
  markdowns
  blog_index
  stylesheets
}

main "$@"
