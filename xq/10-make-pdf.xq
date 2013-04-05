(:
 : mount basex-webdav and convert master docbook using Apache FOP
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

(:~ mountpoint of webdav
 : given as external variable, if not defined differently
 :)
declare variable $WebDAV-MOUNTPOINT as xs:string external := "/Volumes/webdav/";

(: create directories :)
($WebDAV-MOUNTPOINT, $C:TMP-DOCBOOKS-CONV) ! file:create-dir(.),
(: mount webdav :)
C:execute("mount_webdav", ("http://localhost:8984/webdav", $WebDAV-MOUNTPOINT)),

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
  C:execute("fop", (
    "-param", "generate.toc", string-join($param, out:nl()),
    "-xml", $master,
    "-xsl", "docbook.xsl",
    "-pdf", $C:TMP-DOCBOOKS-CONV || $C:DOC-MASTER || ".pdf"
  )),

(: unmount :)
C:execute("umount", ("-fv", $WebDAV-MOUNTPOINT)),

(: delete mountpoint dir, if any :)
try{
  $WebDAV-MOUNTPOINT ! file:delete(.)
} catch * {()},

C:logs(("converted master pdf to ", $C:TMP-DOCBOOKS-CONV, "; used webdav"))
