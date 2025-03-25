#!/bin/sh

markdown() (
  md="$1"
  target="${md%md}html"
  target="docs${target#src/markdown}"
  mkdir -p "$(dirname "$target")"
  ./build/preprocess_markdown.awk src/html/header.html src/html/footer.html "$md" \
    | pandoc -f gfm -t html \
    > "$target"
)

markdowns() {
  find src/markdown -type f | while read -r md; do markdown "$md" & done
}

blog_index() {
  mkdir -p docs/blog
  env TITLE="Eric Mrak's blog" envsubst < src/html/header.html > docs/blog/index.html
  find src/markdown/blog -type f | sort -r | xargs ./build/blog_index.awk
  envsubst < src/html/footer.html >> docs/blog/index.html
}

main() {
  case "$1" in
    markdowns) markdowns ;;
    blog_index) blog_index ;;
  esac
}

main "$@"
