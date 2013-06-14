(:~
 : list all articles which
 : exist in the db, but won't appear in the PDF/DocBook
 :
 : to be executed after documentation was once generated
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

declare option output:separator "\n";

let $in-output := C:open($C:DOC-MASTER)//*:include/@href/data()
  ! replace(., "%25", "%")
for $x in $C:PAGES-RELEVANT
where not($x/@docbook = $in-output)
return $x/@title/data()