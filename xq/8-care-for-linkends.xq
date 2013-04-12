(:~
 : adjusted aims for links for any 
 : link in any docbook
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

declare namespace xlink = "http://www.w3.org/1999/xlink";


for $page in $C:PAGES-RELEVANT
let $c := C:open($page/@docbook)

(: care about reference links :)
for $link in $c//*:link[starts-with(@xlink:href, "/wiki/")]
let $new-ref := substring-after($link/@xlink:href, "/wiki/")
let $token := tokenize($new-ref, "#"),
    $hash := $token[2], (: url hash :)
    (: search for a id that fits to this links aim :)
    $link-src := $C:PAGES-RELEVANT[
      (:TODO what if referenced to redirection :)
      @title-slug = $token[1]
    ]/@docbook
return if (not(empty($link-src)))
then
  if (contains($new-ref,"#")) (: link is anchor :)
  then
    let $linkid := C:open($link-src)//@xml:id[
        . = string-join($token) (: subsection of a page with non-unique id (thus id is preset by @title-slug) :)
        or . = replace($token[2],':','-') (: remove special chars as in "db:create" :)
      ][1] (: order is by relevance - thus take first :)
    return (
      rename node $link/@xlink:href as QName("http://docbook.org/ns/docbook", "linkend"),
      replace value of node $link/@xlink:href with $linkid
    )
  else
  (
    rename node $link/@xlink:href as QName("http://docbook.org/ns/docbook", "linkend"),
    (: prepend string if links to a different article :)
    replace value of node $link/@xlink:href
    with ($C:PAGES-RELEVANT[$new-ref = @title or $new-ref = @title-slug] ! "title") || $new-ref
  )
else (: no link in document found :)
  replace value of node $link/@xlink:href
  with $C:WIKI-BASEURL || $link/@xlink:href
,

db:output(
  C:log("adjusted aims for links in relevant docbooks")
)
