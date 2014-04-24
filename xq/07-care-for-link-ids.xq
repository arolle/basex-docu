(:~
 : makes ids unique over whole (future) docbook master
 : replaces content in each docbook
 : 
 : replaces redirection links with their aim
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

declare namespace xlink = "http://www.w3.org/1999/xlink";

(: assurance for no duplicate link ids :)
let $dup-ids := (
  (: get all duplicate ids of all docbook documents :)
  for $x in C:open($C:DOCBOOKS-PATH)//@xml:id
  let $g := $x/data()
  group by $g
(:  where count($x) >= 1:)
(:  order by count($x) descending:)
  return <e>{attribute count {count($x)}, $x[1]/data()}</e>
)[@count > 1]

for $page in $C:PAGES-RELEVANT
let $c := C:open($page/@docbook)
return 
  (: preset pagetitle to duplicate ids and links :)
  for $id in $c//(@xml:id , @*:linkend)[ . = $dup-ids ]
  return
    replace value of node $id with ($page/@title-slug || $id/data())
,


(: replace redirection links by real link :)
for $red in C:open($C:LS-PAGES)//page[string-length(@redirect) > 0]/@title-slug
for $link in C:open($C:DOCBOOKS-PATH)//*:link[
  (: refers to anchor in page; symbol # is necessary due to similar names :)
  starts-with(@xlink:href, "/wiki/" || $red || "#")
  or @xlink:href = "/wiki/" || $red (: refers to page :)
]
return
  replace value of node $link/@xlink:href
  with
    "/wiki/"
    || $red/parent::node()/@redirect
    || substring-after($link/@xlink:href, "#"),


db:output(
  C:logs(static-base-uri(), ("unified link-ids in relevant docbooks in db ", $C:WIKI-DB, " at path ", $C:DOCBOOKS-PATH))
)
