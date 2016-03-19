(:~
 : makes ids unique over whole (future) docbook master
 : replaces content in each *.docbook
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

declare namespace xlink = "http://www.w3.org/1999/xlink";

for $page in C:open($C:LS-PAGES)//page[@docbook]
let $article := C:open($page/@docbook)/*:article
where $article (: do replacement once, afterwards article is named chapter :)
return (
  rename node $article as QName("http://docbook.org/ns/docbook", "chapter"),

  for $title in $article/*:info/*:title
  return replace node $title/parent::node() with element title { $title/text() },
  
  (: add link to wiki :)
  insert node element para {
    element link {
      attribute xlink:href { $C:WIKI-BASEURL || "/index.php?title=" || $page/@title-enc },
      "Read this entry online in the BaseX Wiki."
    }
  } after $article/*:info[1],
  
  (: add anchor to each chapter i.e. article :)
  insert node attribute xml:id { "title" || $page/@title-slug } as first into $article
),

(: delete some empty elements :)
delete node C:open($C:DOCBOOKS-PATH)//*:index,

C:log(static-base-uri(), "modified semantics in docbooks")
