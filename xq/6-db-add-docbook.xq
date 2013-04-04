(:~
 : adds converted docbook-files to database
 : for further XQUF modifications
:)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";
declare option db:chop "false";

db:add($C:WIKI-DB, $C:TMP-DOCBOOKS-CONV, $C:DOCBOOKS-PATH),

db:output(
  C:logs(("added converted docbooks from ", $C:TMP-DOCBOOKS-CONV, " on hdd to db ", $C:WIKI-DB, " at path ", $C:DOCBOOKS-PATH))
)