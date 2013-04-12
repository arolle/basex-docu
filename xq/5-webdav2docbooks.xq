(:
 : mount basex-webdav and transform from xhtml to docbook
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

(: convert all non-redirects from xhtml to docbook
 : and place them at $C:TMP-DOCBOOKS-CONV
 :)
let $basepath := ($WebDAV-MOUNTPOINT || $C:WIKI-DB || "/" || $C:WIKI-DUMP-PATH)
for $name in file:list($basepath, false(), "*.xml")
where
  substring($name, 1, string-length($name)-4) (: name w/o extension :)
  = $C:PAGES-RELEVANT/@title-enc
return
  C:execute("herold",
    ((:"--docbook-encoding", "uft-8", "--html-encoding", "utf-8",:)
    "-i", $basepath || $name, "-o", $C:TMP-DOCBOOKS-CONV || $name)
  ),

(: unmount :)
C:execute("umount", ("-fv", $WebDAV-MOUNTPOINT)),

(: delete mountpoint dir, if any :)
try{
  $WebDAV-MOUNTPOINT ! file:delete(.)
} catch * {()},

C:logs(("converted each page from xhtml to docbook, placed those at ", $C:TMP-DOCBOOKS-CONV, "; used webdav"))
