(:~
 : Create an all-in-one Docbook
 : Image references will absolute, cf $WebDAV-MOUNTPOINT
 :)

import module namespace C = "basex-docu-conversion-config" at "config.xqm";

if (db:exists($C:WIKI-DB, $C:MASTER-ALL))
then db:delete($C:WIKI-DB, $C:MASTER-ALL)
else (),

(: convert from already existing master :)
let $master :=
  copy $c := C:open($C:DOC-MASTER)
  modify (
    for $x in $c//*:include
    let $path := $x/@href ! replace(., "%25", "%")
    return
      replace node $x
      with C:open($path)
  )
  return $c

return
  db:add($C:WIKI-DB, $master, $C:MASTER-ALL),

db:output(
  C:logs(("generated all-in-one in DB ", $C:WIKI-DB, " master at ", $C:MASTER-ALL))
)
