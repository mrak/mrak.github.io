#!/bin/sh

COPYRIGHT_YEAR="$(date +%Y)"

for md in $(find src/markdown -type f); do
    target="${md%md}html"
    target="docs${target#src/markdown}"
    mkdir -p $(dirname $target)
    cat src/html/header.html > "$target"
    ./build/markdown.mjs < "$md" >> "$target"
    cat src/html/footer.html >> "$target"
    sed -i -e 's/@COPYRIGHT@/'${COPYRIGHT_YEAR}'/g' "$target"
done

sass src/sass/styles.scss docs/css/styles.css
