(:~
 : downloads all linked images to $C:WIKI-DUMP-IMG
 : and modify img/@src
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

(:~ get all image sources :)

for $extimg in C:open($C:LS-IMAGES)//img
for $img-src in C:open($C:WIKI-DUMP-PATH)//img/@src[
  ends-with(., "-" || $extimg/@name) or
  ends-with(., "/" || $extimg/@name)
]
let $name := $extimg/@name
return (
  (: download new images :)
  let $path := $C:WIKI-DUMP-IMG || $name
  where not(db:exists($C:WIKI-DB, $path))
  return db:store($C:WIKI-DB, $path, fetch:binary($extimg/@url)),

  (: set new @href for img/parent::a :)
  for $href in $img-src/parent::img/parent::a[not(starts-with(@href, $C:WIKI-BASEURL))]/@href
  return replace value of node $href with $C:WIKI-BASEURL || $href/data(),

  (: set new @src for img :)
  for $src in $img-src[not(starts-with(., $C:REL-PATH2IMG))]
  return replace value of node $src with $C:REL-PATH2IMG || $name
),

(: add logo :)
db:replace($C:WIKI-DB, $C:WIKI-DUMP-IMG || "basex.svg", "basex.svg"),

C:log(static-base-uri(), "loaded images; connected xhtml/img@src with image locations")
