(:
 : Init, and gets all pages from the MediaWikiAPI
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

let $pages := element pages {
  let $doc := fetch:text($C:BX-API
    || "action=query&amp;list=allpages&amp;aplimit=500&amp;format=xml&amp;meta=siteinfo"
  ) ! parse-xml(.)/api/query
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
  fetch:text($C:BX-API || "action=query&amp;list=allimages&amp;format=xml&amp;ailimit=500")
    ! fn:parse-xml(.)//img
}
return
  if (db:exists($C:WIKI-DB))
  then (
    db:replace($C:WIKI-DB, $C:LS-PAGES, $pages),
    db:replace($C:WIKI-DB, $C:LS-IMAGES, $images),
    db:output(
      C:logs(static-base-uri(), ("modified in ", $C:WIKI-DB, " the list of wiki pages at path ", $C:LS-PAGES, " and list of wiki images at path ", $C:LS-IMAGES))
    )
  )
  else (
    db:create(
      $C:WIKI-DB,
      ($images, $pages),
      ($C:LS-IMAGES, $C:LS-PAGES)
    ),
    db:output(
      C:logs(static-base-uri(), ("created db ", $C:WIKI-DB, " with list of wiki pages at path ", $C:LS-PAGES, " and list of wiki images at path ", $C:LS-IMAGES))
    )
  )
