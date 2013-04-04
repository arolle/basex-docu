#!/usr/bin/env bash

# time:
# real	5m16.498s
# user	6m6.035s
# sys	0m31.988s

echo
echo "generate basex documentation"
echo 

basexhttp &
basex 'db:drop("basex-wiki")'
basex xq/0-get-pages-list.xq
basex xq/1-get-wiki-pages.xq
basex xq/2-modify-page-content.xq
basex xq/3-extract-images.xq
basex xq/4-toc-to-docbook-master.xq
basex xq/5-webdav2docbooks.xq
basex 'db:delete("basex-wiki","docbooks")'
basex xq/6-db-add-docbook.xq
basex xq/7-care-for-link-ids.xq
basex xq/8-care-for-linkends.xq
basex xq/9-modify-docbooks.xq
basex xq/10-make-pdf.xq
basexhttpstop
