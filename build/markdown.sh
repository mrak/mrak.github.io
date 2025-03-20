#!/bin/sh

set -eu

TMPCODE="$(mktemp)"
IN_HEADER=''
IN_CODEBLOCK=''
CODEBLOCK_LANG=''
HEADER_TEMPLATE="${1:-/dev/null}"
FOOTER_TEMPLATE="${2:-/dev/null}"
TITLE="Eric Mrak"
DESCRIPTION=
KEYWORDS=

process_line() {
  line="$1"
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
}

preprocess() {
  while IFS= read -r line; do
    if [ -z "$IN_HEADER" ]; then
      if [ "$line" = "---" ]; then
        IN_HEADER=1 && continue
      fi
      break
    fi

    case "$line" in
      "---") break ;;
      title*) TITLE="$(expr "$line" : 'title *= *\(.*\)')" ;;
      description*) DESCRIPTION="$(expr "$line" : 'description *= *\(.*\)')" ;;
      keywords*) KEYWORDS="$(expr "$line" : 'keywords *= *\(.*\)')" ;;
    esac
  done

  env TITLE="$TITLE" DESCRIPTION="$DESCRIPTION" KEYWORDS="$KEYWORDS" envsubst < "$HEADER_TEMPLATE"
  echo
  [ -z "$IN_HEADER" ] && process_line "$line"

  while IFS= read -r line; do
    process_line "$line"
  done

  echo
  envsubst < "$FOOTER_TEMPLATE"
}

preprocess </dev/stdin | pandoc -f gfm -t html

rm "$TMPCODE"
