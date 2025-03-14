#!/bin/sh

COPYRIGHT_YEAR="$(date +%Y)"

find src/markdown -type f \
| while read -r md; do
    target="${md%md}html"
    target="docs${target#src/markdown}"
    mkdir -p "$(dirname "$target")"
    cat src/html/header.html > "$target"
    ./build/markdown.sh < "$md" >> "$target"
    cat src/html/footer.html >> "$target"
    sed -i -e "s/@COPYRIGHT@/${COPYRIGHT_YEAR}/g" "$target"
done

sassc --sourcemap=auto --style expanded src/sass/styles.scss docs/css/styles.css
