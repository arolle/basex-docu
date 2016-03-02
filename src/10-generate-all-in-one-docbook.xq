(:~
 : Create an all-in-one Docbook
 : Image references will absolute
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

(: delete old master :)
db:delete($C:WIKI-DB, $C:MASTER-ALL),

(: copy already existing master :)
db:add($C:WIKI-DB, C:open($C:DOC-MASTER), $C:MASTER-ALL),

(: replace xi:includes with referenced documents :)
for $x in C:open($C:MASTER-ALL)/*:book/(*:include,  *:part/*:include)
let $path := $x/@href ! replace(., "%25", "%")
return replace node $x with C:open($path),

C:log(static-base-uri(),
  "generated all-in-one in DB " || $C:WIKI-DB || " master at " || $C:MASTER-ALL
)
