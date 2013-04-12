(:~
 : returns all dead links, with its containing page
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";
declare option output:separator "\n";

for $href in C:open($C:DOCBOOKS-PATH)//@linkend
where empty(C:open($C:DOCBOOKS-PATH)//@xml:id[data() = $href])
return <page docbook="{$href/base-uri()}">{$href/data()}</page>
,

(: Output (3)

<page docbook="basex-wiki/docbooks/Databases.xml"/>
<page docbook="basex-wiki/docbooks/Serialization.xml"/>
<page docbook="basex-wiki/docbooks/User%20Management.xml"/>

:)

(: links that become empty :)
for $href in C:open($C:DOCBOOKS-PATH)//@linkend[. = ("")]
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

(: Output (3)

<page docbook="basex-wiki/docbooks/Databases.xml">
  <a href="/wiki/Valid_Names" title="Valid Names" class="mw-redirect">valid names constraints</a>
</page>
<page docbook="basex-wiki/docbooks/Serialization.xml">
  <a href="/wiki/REST#Query_Parameters" title="REST">REST</a>
</page>
<page docbook="basex-wiki/docbooks/User%20Management.xml">
  <a href="/wiki/Valid_Names" title="Valid Names" class="mw-redirect">valid names constraints</a>
</page>

:)
