
(:~
 : Load Pages from BaseX MediaWiki into Database
 : at path $C:WIKI-DUMP-PATH.
 : extract redirects immediately
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

(: delete articles that already exist :)
db:delete($C:WIKI-DB, $C:WIKI-DUMP-PATH),

(: fetch the new wiki articles from web :)
for $page at $p in C:open($C:LS-PAGES)//page

(: request page content :)
let $req := fetch:xml(
  $C:BX-API || "action=parse&amp;format=xml&amp;page=" ||
  $page/@title-enc || "&amp;prop=text|images|displaytitle|links|externallinks"
)

(: parse html :)
let $contents :=
  for $text in $req/api/parse/text/text()
  return html:parse("<_>" || $text ||"</_>")/node()/node()

(: check if redirect or real page :)
return if (starts-with(($contents/*/text())[1], "REDIRECT")) then (
  (: change redirect attributes and so :)
  replace value of node $page/@redirect with $contents/*/*/text()[1],
  delete node $page/@*[name() = $C:NO-RENDER-DEL-ATTR]
) else (
  (: add page (no redirection) :)
  db:add(
    $C:WIKI-DB,
    <html>
      <head><title>{ $page/@title/data() }</title></head>
      <body>{ $contents }</body>
    </html>,
    $page/@xml
  )
), 

C:log(static-base-uri(),
  "loaded all wiki pages to " || $C:WIKI-DB || " at path " || $C:WIKI-DUMP-PATH ||
  "; added flag for 'redirect' pages"
)
