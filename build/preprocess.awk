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
}

NR == 1 && $0 == "---" { in_header = 1; next }
NR == 1 { header() }

in_header == 1 && $0 == "---"    { in_header = 0; header(); next }
in_header == 1 && /^title/       { sub(/^ *title *= */,"",$0);       title = $0;       next }
in_header == 1 && /^description/ { sub(/^ *description *= */,"",$0); description = $0; next }
in_header == 1 && /^keywords/    { sub(/^ *keywords *= */,"",$0);    keywords = $0;    next }

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

{
  if (in_code) {
    print $0 >> tmpfile
  } else {
    print
  }
}

END {
  while ((getline<footerfile) > 0) { print }
  system(sprintf("rm '%s'", tmpfile))
}
