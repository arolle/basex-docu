(:
 : mount basex-webdav and transform from xhtml to docbook
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

(:~ name of service :)
declare variable $WebDAV := "webdav";
(: mountpoint of webdav :)
declare variable $WebDAV-MOUNTPOINT := "/Volumes/" || $WebDAV || "/";

(: create directories :)
($WebDAV-MOUNTPOINT, $C:TMP-DOCBOOKS-CONV) ! file:create-dir(.),
(: mount webdav :)
proc:execute("mount_webdav", ("http://localhost:8984/webdav", $WebDAV-MOUNTPOINT)),

(: convert each xhtml to docbook and place it to $C:TMP-DOCBOOKS-CONV :)
let $basepath := ($WebDAV-MOUNTPOINT || $C:WIKI-DB || "/" || $C:WIKI-DUMP-PATH)
for $name in file:list($basepath, false(), "*.xml")
return
  proc:system("herold",
    ((:"--docbook-encoding", "uft-8", "--html-encoding", "utf-8",:)
    "-i", $basepath || $name, "-o", $C:TMP-DOCBOOKS-CONV || $name)
  ),

(: unmount :)
proc:execute("umount", ("-fv", $WebDAV-MOUNTPOINT)),

C:logs(("converted each page from xhtml to docbook, placed those at ", $C:TMP-DOCBOOKS-CONV))
