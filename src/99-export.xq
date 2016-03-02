(:~
 : Exports the current database.
 : from the Table of Contents
 : whose place is defined in $C:TOC-NAME
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

let $path := $C:TMP || 'basex-wiki-export/'
return (
  if(file:exists($path)) then file:delete($path, true()) else (),
  db:export('basex-wiki', 'tmp/basex-wiki-export/'),

  C:log(static-base-uri(), "exported database to " || $path)
)
