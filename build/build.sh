#!/bin/sh

COPYRIGHT_YEAR="$(date +%Y)"

find src/markdown -type f \
| while read -r md; do
    target="${md%md}html"
    target="docs${target#src/markdown}"
    mkdir -p "$(dirname "$target")"
    ./build/markdown.sh src/html/header.html src/html/footer.html < "$md" > "$target"
    sed -i -e "s/@COPYRIGHT@/${COPYRIGHT_YEAR}/g" "$target"
done

sassc --sourcemap=auto --style expanded src/sass/styles.scss docs/css/styles.css
