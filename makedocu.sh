#!/usr/bin/env bash

# time:
# real	5m16.498s
# user	6m6.035s
# sys	0m31.988s

if [[ $1 = "-h" || $1 = "-help" ]]; then
  cat << EOF
  Usage: `basename $0` [<Debug> [<No-PDF-generation>]]

    <Debug>
      optional parameter to specify a mode.
      higher the integer debug value means more previously
      generated xhtml and docbook is used.
      0   no debug -- default
      1   uses local xhtml sources of wiki-pages instead of
          loading from wiki. requires run once before in mode '0'.
      2   use existing *.docbook from temp path.
          requires run before in 0 or 1 mode (in this session).
      3   generate pdf directly from db.
          requires run before in 0, 1 or 2 mode.

    <No-PDF-generation>
      only if <Debug> was specified, optional
      1   no pdf generated -- default
      0   pdf gets generated

EOF
  exit 1
fi

# Debug mode, default 0
DEBUG="${2:-0}"
DEBUG=`( [ "$DEBUG" -gt -1 ] && echo "$DEBUG") || echo 0` # assure int
# PDF generation?
DEF=`( [ "$DEBUG" -gt 0 ] && echo 0) || echo 1` # default
PDFGEN="${3:-$DEF}"
PDFGEN=`( [ "$PDFGEN" -gt -1 ] && echo "$PDFGEN" ) || echo "$DEF"`



BX_DOCU=`dirname $0` # dir location of this file

cat << EOF

generate basex documentation
  logfile:         `cd $BX_DOCU && pwd`/basex-wiki.log
  debug mode:      $DEBUG
  pdf generation:  $PDFGEN

EOF


if [ $DEBUG -lt 1 ]; then
  basex xq/0-get-pages-list.xq
  basex xq/1-get-wiki-pages.xq
  basex xq/2-modify-page-content.xq
  basex xq/3-extract-images.xq
  basex xq/4-toc-to-docbook-master.xq
fi
if [ $DEBUG -lt 2 ]; then
  basex xq/export.bxs # export db
  basex xq/5-conv*.xq # convert export
fi
if [ $DEBUG -lt 3 ]; then
  basex xq/6-db-add-docbook.xq
  basex xq/7-care-for-link-ids.xq
  basex xq/8-care-for-linkends.xq
  basex xq/9-modify-docbooks.xq
  basex xq/10-generate-all-in-one-docbook.xq
fi
if [ $PDFGEN -eq 1 ]; then
  basex xq/export.bxs # export db
  basex xq/11-make-pdf.xq
fi

