(:~
 : adds converted docbook-files to database
 : for further XQUF modifications
:)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";


(: delete all documents that shall be added :)
for $x in db:list($C:WIKI-DB, $C:DOCBOOKS-PATH)[
  tokenize(., "/")[last()]
  = file:list($C:EXPORT-PATH || $C:DOCBOOKS-PATH, false(), "*.xml")
]
return db:delete($C:WIKI-DB, $x),

(: add all those documents :)
db:add($C:WIKI-DB, $C:EXPORT-PATH || $C:DOCBOOKS-PATH, $C:DOCBOOKS-PATH),

db:output(
  C:logs(static-base-uri(),
    ("added converted docbooks from ", $C:EXPORT-PATH, $C:DOCBOOKS-PATH,
    " on hdd to db ", $C:WIKI-DB, " at path ", $C:DOCBOOKS-PATH)
  )
)
