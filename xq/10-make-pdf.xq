(:
 : mount basex-webdav and convert master docbook using Apache FOP
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

(:~ name of service :)
declare variable $WebDAV := "webdav";
(:~ mountpoint of webdav
 : TODO make independant of OS -- at present for MacOS
 :)
declare variable $WebDAV-MOUNTPOINT := "/Volumes/" || $WebDAV || "/";

(: create directories :)
($WebDAV-MOUNTPOINT, $C:TMP-DOCBOOKS-CONV) ! file:create-dir(.),
(: mount webdav :)
proc:execute("mount_webdav", ("http://localhost:8984/webdav", $WebDAV-MOUNTPOINT)),

let $master := $WebDAV-MOUNTPOINT || $C:WIKI-DB || "/" || $C:DOC-MASTER
(:
 : For FOP Params (like TOC generator) see
 : http://www.sagehill.net/docbookxsl/TOCcontrol.html#BriefSetToc
 :)
let $param := ("article   title",
  "book      toc,title",
  "chapter   title",
  "part      title")
return
  proc:system("fop", (
    "-d", "-param", "generate.toc", string-join($param, out:nl()),
    "-xml", $master,
    "-xsl", "docbook.xsl",
    "-pdf", $C:TMP-DOCBOOKS-CONV || $C:DOC-MASTER || ".pdf"
  )),

(: unmount :)
proc:execute("umount", ("-fv", $WebDAV-MOUNTPOINT)),

C:logs(("converted master pdf to ", $C:TMP-DOCBOOKS-CONV, "; used webdav"))
