(:~
 : Create an all-in-one Docbook
 : Image references will absolute, cf $WebDAV-MOUNTPOINT
 :)

import module namespace C = "basex-docu-conversion-config" at "config.xqm";

(:~ mountpoint of webdav
 : given as external variable, if not defined differently
 :)
declare variable $WebDAV-MOUNTPOINT as xs:string external := "/Volumes/webdav/";


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
      with ( (: correct image pathes :)
        copy $c := C:open($path)
        modify (
          for $x in $c//@fileref[starts-with(., $C:REL-PATH2IMG)]
          let $path := substring-after($x, $C:REL-PATH2IMG)
          return
            replace value of node $x
            with $WebDAV-MOUNTPOINT || $C:WIKI-DB || $C:DS || $C:WIKI-DUMP-IMG || $path
        )
        return $c
      )
  )
  return $c

return
  db:add($C:WIKI-DB, $master, $C:MASTER-ALL),

db:output(
  C:logs(("generated all-in-one in DB ", $C:WIKI-DB, " master at ", $C:MASTER-ALL))
)
