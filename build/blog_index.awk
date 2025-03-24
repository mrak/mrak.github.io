#!/usr/bin/env -S awk -f

function entry(title, href, date, description) {
  system(sprintf("env TITLE='%s' HREF='%s' DATE='%s' DESCRIPTION='%s' envsubst < src/html/blog.html >> docs/blog/index.html", title, href, date, description))
  nextfile
}

BEGIN { FS = "" }

FNR == 1 {
  FS = ""
  in_header = 0
  title = ""
  description = ""
  date = FILENAME
  href = FILENAME
  gsub("^src/markdown/blog/|/[^/]*$", "", date)
  gsub("^src/markdown|\\.md$", "", href)
}

FNR == 1 && $0 == "---" { in_header = 1; FS = " *= *"; next }
FNR == 1 { entry(title href date description) }

in_header == 1 && $0 == "---"         { in_header = 0; FS = ""; entry(title, href, date, description) }
in_header == 1 && $1 == "title"       { title = $2;       next }
in_header == 1 && $1 == "description" { description = $2; next }
