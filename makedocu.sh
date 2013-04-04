#!/usr/bin/env bash

# time:
# real	5m16.498s
# user	6m6.035s
# sys	0m31.988s

if [ $# -lt 1 ]; then
  cat << EOF
  Usage: `basename $0` <WebDAV-MountPoint>
    <WebDAV-MountPoint>	specify mountpoint of webdav service; may exist
EOF
  exit 1
else
  # will overwrite $WebDAV-MOUNTPOINT in #5 and #10
  WebDAV=`echo $1`
fi

BX_DOCU=`dirname $0` # dir location of this file

cat << EOF

generate basex documentation
  WebDAV path:   ${WebDAV}
  logfile:       `cd $BX_DOCU && pwd`/basex-wiki.log

EOF

# start WebDAV service
basexhttp&

# dirty hack: wait till launch of server
reachable=0;
while [ $reachable -eq 0 ]; do
  curl -s http://localhost:8984/webdav  
  if [ "$?" -eq 0 ];
  then
    reachable=1
  fi
done

basex 'db:drop("basex-wiki")' # remove old local wiki entries, if any
basex xq/0-get-pages-list.xq
basex xq/1-get-wiki-pages.xq
basex xq/2-modify-page-content.xq
basex xq/3-extract-images.xq
basex xq/4-toc-to-docbook-master.xq
basex -b"\$WebDAV-MOUNTPOINT=$WebDAV" xq/5-webdav2docbooks.xq
#basex 'db:delete("basex-wiki","docbooks")'
basex xq/6-db-add-docbook.xq
basex xq/7-care-for-link-ids.xq
basex xq/8-care-for-linkends.xq
basex xq/9-modify-docbooks.xq
basex -b"\$WebDAV-MOUNTPOINT=$WebDAV" xq/10-make-pdf.xq
basexhttpstop
