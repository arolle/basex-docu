(:~
 : returns all dead links, with its containing page
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";
declare option output:separator "\n";

(: list all anchors without an aim :)
let $linkends :=
  for $href in C:open($C:DOCBOOKS-PATH)//@linkend
  where empty(C:open($C:DOCBOOKS-PATH)//@xml:id[data() = $href])
  return $href

return
(: list more details just processed links :)
for $href in C:open($C:DOCBOOKS-PATH)//@linkend[. = $linkends]
let $grp := $href/parent::*/text() || $href/base-uri()
group by $grp
let $p := $href[1]/parent::*
return <page docbook="{distinct-values($href/base-uri())}">{
  C:open(
    C:open($C:LS-PAGES)//page[
      $C:WIKI-DB || "/" || @docbook = $href[1]/base-uri()
    ]/@xml
  )//*:a[. = $p/text()]
}</page>

