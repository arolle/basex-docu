(:~
 : downloads all linked images to $C:WIKI-DUMP-IMG
 : and modify img/@src
 :)

import module namespace C = "basex-docu-conversion-config" at "config.xqm";
import module namespace  functx = "http://www.functx.com" ;

(:~ get all image sources :)

for $extimg in C:open($C:LS-IMAGES)//img
for $img in C:open($C:WIKI-DUMP-PATH)//img/@src[
  ends-with(., "-" || $extimg/@name)
  or ends-with(., "/" || $extimg/@name)
]
let $name := $extimg/@name
return (
  if (db:exists($C:WIKI-DB, $C:WIKI-DUMP-IMG || $name))
  then ()
  else db:store($C:WIKI-DB, $C:WIKI-DUMP-IMG || $name, fetch:binary($extimg/@url)),

  (: set new @href for img/parent::a :)
  let $c := $img/parent::img/parent::a[not(starts-with(@href, $C:WIKI-BASEURL))]/@href
  return if ($c)
  then replace value of node $c with $C:WIKI-BASEURL || $c/data()
  else (),

  (: set new @src for img :)
  let $c := $img[not(starts-with(., $C:REL-PATH2IMG))]
  return if ($c)
  then replace value of node $c with $C:REL-PATH2IMG || $name
  else ()
),

(: add logo :)
let $logo-src := $C:WIKI-DUMP-IMG|| "basex.svg"
return
  if (db:exists($C:WIKI-DB, $logo-src))
  then ()
  else db:add($C:WIKI-DB, "basex.svg", $logo-src),

db:output(
  C:log("loaded images; connected xhtml/img@src with image locations")
)
