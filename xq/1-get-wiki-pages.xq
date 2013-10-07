(:~
 : Load Pages from BaseX MediaWiki into Database
 : at path $C:WIKI-DUMP-PATH.
 : extract redirects immediately
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

(: delete articles that already exist :)
if (empty(db:list($C:WIKI-DB, $C:WIKI-DUMP-PATH)))
then ()
else db:delete($C:WIKI-DB, $C:WIKI-DUMP-PATH),


(: fetch the new wiki articles from web :)
for $page in C:open($C:LS-PAGES)//page

(: request page content :)
let $req := fetch:text(
  $C:BX-API || "action=parse&amp;format=xml&amp;page=" ||
  $page/@title-enc || "&amp;prop=text|images|displaytitle|links|externallinks"
) ! fn:parse-xml(.)

(: parse html :)
let $contents := $req/api/parse/text/text()/string()
  ! html:parse("<_>" || . ||"</_>")/node()/node()

(: check if redirect or real page :)
return if (starts-with(($contents/*/text())[1], "REDIRECT"))
then (
  (: change redirect attributes and so :)
  replace value of node $page/@redirect
    with $contents/*/*/text()[1],
  delete node $page/@*[name() = $C:NO-RENDER-DEL-ATTR]
)
(: add page (no redirection) :)
else db:add(
  $C:WIKI-DB,
  <html><head><title>{$page/@title/data()}</title></head><body>{$contents}</body></html>,
  $page/@xml
),

db:output(
  C:logs(static-base-uri(), ("loaded all wiki pages to ", $C:WIKI-DB, " at path ", $C:WIKI-DUMP-PATH, "; added flag for 'redirect' pages"))
)
