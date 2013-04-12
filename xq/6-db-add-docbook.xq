(:~
 : adds converted docbook-files to database
 : for further XQUF modifications
:)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";
import module namespace  functx = "http://www.functx.com";


(: delete all documents that shall be added :)
for $x in db:list($C:WIKI-DB, $C:DOCBOOKS-PATH)[
  functx:substring-after-last(., "/")
  = file:list($C:TMP-DOCBOOKS-CONV, false(), "*.xml")
]
return db:delete($C:WIKI-DB, $x),

(: add all those documents :)
db:add($C:WIKI-DB, $C:TMP-DOCBOOKS-CONV, $C:DOCBOOKS-PATH),

db:output(
  C:logs(("added converted docbooks from ", $C:TMP-DOCBOOKS-CONV, " on hdd to db ", $C:WIKI-DB, " at path ", $C:DOCBOOKS-PATH))
)
