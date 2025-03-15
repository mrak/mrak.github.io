#!/bin/sh

set -eu

TMPCODE="$(mktemp)" IN_CODEBLOCK='' CODEBLOCK_LANG=''

while IFS= read -r line; do
  if [ "$IN_CODEBLOCK" = 1 ]; then
    if expr "$line" : ' *```[^ ]* *' >/dev/null; then
      IN_CODEBLOCK=
      chroma "$TMPCODE" --html --html-only -l "$CODEBLOCK_LANG"
      echo
    else
      echo "$line" >> "$TMPCODE"
    fi
  else
    if CODEBLOCK_LANG="$(expr "$line" : ' *```\([^ ]*\) *')"; then
      IN_CODEBLOCK=1
      : > "$TMPCODE"
    else
      echo "$line"
    fi
  fi
done | pandoc -f gfm -t html

rm "$TMPCODE"
