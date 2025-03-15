#!/bin/sh

TMPCODE="$(mktemp)"
IN_CODEBLOCK=
CODEBLOCK_LANG=

while IFS= read -r line; do
  # code fence sighted
  if expr "$line" : ' *```[^ ]* *' >/dev/null; then
    # end code block, format seen code with chroma
    if [ "$IN_CODEBLOCK" = 1 ]; then
      IN_CODEBLOCK=
      chroma "$TMPCODE" --html --html-only -l "$CODEBLOCK_LANG"
      echo
    # begin code block
    else
      IN_CODEBLOCK=1
      : > "$TMPCODE"
      CODEBLOCK_LANG="$(expr "$line" : ' *```\([^ ]*\) *')"
    fi
    continue
  fi
  # save code for later formatting
  if [ "$IN_CODEBLOCK" = 1 ]; then
    echo "$line" >> "$TMPCODE"
  # save regular line
  else
    echo "$line"
  fi
done | pandoc -f gfm -t html

rm "$TMPCODE"
