(:~
 : list all articles which
 : exist in the db, but won't appear in the PDF/DocBook
 :
 : to be executed after documentation was once generated
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

'',
'Articles missing in PDF',
'=======================',

let $in-output := C:open($C:DOC-MASTER)//*:include/@href/data()
  ! replace(., "%25", "%")
return $C:PAGES-RELEVANT[not(@docbook = $in-output)]/@title/data(),

'', ''
