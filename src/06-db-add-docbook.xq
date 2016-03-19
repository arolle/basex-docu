(:~
 : adds converted docbook-files to database
 : for further XQUF modifications
:)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

(: delete old documents :)
db:delete($C:WIKI-DB, $C:DOCBOOKS-PATH),

(: add all docbook documents to the database :)
db:add($C:WIKI-DB, $C:EXPORT-PATH || $C:DOCBOOKS-PATH, $C:DOCBOOKS-PATH, map { 'chop': false() }),

C:log(static-base-uri(),
  "added converted docbooks from " || $C:EXPORT-PATH || $C:DOCBOOKS-PATH || " to database"
)
