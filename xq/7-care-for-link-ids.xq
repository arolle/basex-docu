(:~
 : makes ids unique over whole (future) docbook master
 : replaces content in each *.docbook
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

declare namespace xlink = "http://www.w3.org/1999/xlink";
declare option db:chop "false";

let $dup-ids := (
  (: get all duplicate ids of all docbook documents :)
  for $x in db:open($C:WIKI-DB, $C:DOCBOOKS-PATH)//@xml:id
  let $g := $x/data()
  where count($x) >= 1
  group by $g
  order by count($x) descending
  return <e>{attribute count {count($x)}, $x[1]/data()}</e>
)[@count > 1]

for $page in $C:PAGES-RELEVANT[@docbook]
let $c := C:open($page/@docbook)

(: assurance for no duplicate link ids :)
return (
    (: preset pagetitle to duplicate ids :)
    for $id in $c//@xml:id[ . = $dup-ids ]
    return
      (replace value of node $id with ($page/@title || $id/data())),
    
    (: adjust link aim for links to duplicate ids :)
    for $x in $c//*:link/@*:linkend[ . = $dup-ids ]
    return
      replace value of node $x with ($page/@title || $x/data())
), (: end operation on $dups-ids :)


(: replace redirection links by real link :)
for $red in $C:PAGES-RELEVANT[string-length(@redirect) > 0]/@title-slug
for $link in db:open($C:WIKI-DB, $C:DOCBOOKS-PATH)//*:link[
  starts-with(@xlink:href, "/wiki/" || $red || "#") (: refers to subsection of page :)
  or @xlink:href = "/wiki/" || $red (: refers to page :)
]
(: $hash contains anything after # in url; 6 = string-length("/wiki/") :)
let $hash := substring($link/@xlink:href, 6 + string-length($red))
return
  (replace value of node $link/@xlink:href
  with $red/parent::node()/@redirect || $hash),


(: delete some empty elements :)
delete node db:open($C:WIKI-DB, $C:DOCBOOKS-PATH)//*:index,

db:output(
  C:logs(("unified link-ids in relevant docbooks in db ", $C:WIKI-DB, " at path ", $C:DOCBOOKS-PATH))
)