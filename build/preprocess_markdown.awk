#!/usr/bin/env -S awk -f

function header() {
  system(sprintf("env TITLE='%s' DESCRIPTION='%s' KEYWORDS='%s' envsubst < '%s'", title, description, keywords, headerfile))
  print ""
}

BEGIN {
  title = "Eric Mrak"
  headerfile = ARGV[1]
  footerfile = ARGV[2]
  delete ARGV[1]
  delete ARGV[2]
  "mktemp" | getline tmpfile
  FS = ""
}

NR == 1 && $0 == "---" { in_header = 1; FS = ":  *"; next }
NR == 1 { header() }

in_header == 1 && $0 == "---"         { in_header = 0; FS = ""; header(); next }
in_header == 1 && $1 == "title"       { title = $2;       next }
in_header == 1 && $1 == "description" { description = $2; next }
in_header == 1 && $1 == "keywords"    { keywords = $2;    next }

/^ *```/ {
  if (in_code) {
    in_code=0
    system("chroma '"tmpfile"' --html --html-only -l '"lang"'")
    print ""
  } else {
    in_code=1
    sub(/^ *```/,"",$0)
    system("cat /dev/null > "tmpfile)
    lang = $0
  }

  next
}

{ if (in_code) { print $0 >> tmpfile } else print }

END {
  "date +%Y" | getline copyright
  while ((getline<footerfile) > 0) {
    sub(/\${YEAR}/,copyright)
    print
  }
  system(sprintf("rm '%s'", tmpfile))
}
