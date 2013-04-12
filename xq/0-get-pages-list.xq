(:
 : Init, and gets all pages from the MediaWikiAPI
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";
declare option db:chop "false";

let $pages := element pages {
  let $doc := doc($C:BX-API || "action=query&amp;list=allpages&amp;aplimit=500&amp;format=xml&amp;meta=siteinfo")/api/query
  return $doc/allpages/p/@title/data()
  ! element page {
    . ! (
      attribute {"title-enc"} {fn:encode-for-uri(.)}, (: uri encoded title :)
      attribute {"title"} {.}, (: title plain :)
      attribute {"redirect"} {""}, (: set later for pages that redirect :)
      attribute {"title-slug"} {fn:encode-for-uri(replace(., ' ', '_'))}, (: title with underscores :)
      attribute {"xml"} {$C:WIKI-DUMP-PATH || fn:encode-for-uri(.) || '.xml'}, (: uri encoded title :)
      attribute {"docbook"} {$C:DOCBOOKS-PATH || fn:encode-for-uri(.) || '.xml'} (: uri encoded title :)
    )
  }
}
let $images := element images {
  doc($C:BX-API || "action=query&amp;list=allimages&amp;format=xml&amp;ailimit=500")//img
}
return db:create(
  $C:WIKI-DB,
  ($images, $pages),
  ($C:LS-IMAGES, $C:LS-PAGES)
),

db:output(
  C:logs(("created db ", $C:WIKI-DB, " with list of wiki pages at path ", $C:LS-PAGES, " and list of wiki images at path ", $C:LS-IMAGES))
)

(: TODO extract meta data

sitename
articlepath
script


<general mainpage="Main Page" base="http://docs.basex.org/wiki/Main_Page" sitename="BaseX Documentation" generator="MediaWiki 1.16.0" phpversion="5.3.19" phpsapi="cgi-fcgi" dbtype="mysql" dbversion="5.5.28-log" case="first-letter" rights="Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0)" lang="en" fallback8bitEncoding="windows-1252" writeapi="" timezone="UTC" timeoffset="0" articlepath="/wiki/$1" scriptpath="" script="/index.php" variantarticlepath="" server="http://docs.basex.org" wikiid="db249056_271" time="2013-03-15T15:25:52Z"/>    
:)
