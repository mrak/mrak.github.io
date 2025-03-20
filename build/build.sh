#!/bin/sh

COPYRIGHT_YEAR="$(date +%Y)"

markdowns() {
  find src/markdown -type f \
  | while read -r md; do
    target="${md%md}html"
    target="docs${target#src/markdown}"
    mkdir -p "$(dirname "$target")"
    ./build/markdown.sh src/html/header.html src/html/footer.html < "$md" > "$target"
    sed -i -e "s/@COPYRIGHT@/${COPYRIGHT_YEAR}/g" "$target"
  done
}

blog_index() {
  mkdir -p docs/blog
  env TITLE="Eric Mrak's blog" envsubst < src/html/header.html > docs/blog/index.html
  find src/markdown/blog -type f | sort -r \
  | while read -r md; do
    DATE="${md##src/markdown/blog/}"
    DATE="${DATE%%/*}"
    sed -n '/---/,/---/{//!p;}' "$md" \
    | {
      TITLE=
      DESCRIPTION=
      while read -r line; do
        case "$line" in
          title*) TITLE="$(expr "$line" : 'title *= *\(.*\)')" ;;
          description*) DESCRIPTION="$(expr "$line" : 'description *= *\(.*\)')" ;;
        esac
      done
      env TITLE="$TITLE" DATE="$DATE" DESCRIPTION="$DESCRIPTION" envsubst < src/html/blog.html >> docs/blog/index.html
    }
  done
  envsubst < src/html/footer.html >> docs/blog/index.html
}

stylesheets() {
  mkdir -p docs/css
  sassc --sourcemap=auto --style expanded src/sass/styles.scss docs/css/styles.css
}

main() {
  rm -r docs
  markdowns
  blog_index
  stylesheets
}

main "$@"
