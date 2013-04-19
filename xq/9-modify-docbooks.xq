(:~
 : makes ids unique over whole (future) docbook master
 : replaces content in each *.docbook
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

declare namespace xlink = "http://www.w3.org/1999/xlink";

for $page in C:open($C:LS-PAGES)//page[@docbook]
let $c := C:open($page/@docbook)/*:article
where $c (: do replacement once, afterwards article is named chapter :)
return (
  rename node $c as QName("http://docbook.org/ns/docbook", "chapter"),

  for $x in $c/*:info/*:title
  return
    replace node $x/parent::node()
    with element title { $x/text() },
  
  (: add link to wiki :)
  insert node element para {
    element link {
      attribute xlink:href {$C:WIKI-BASEURL || "/index.php?title=" ||  $page/@title-enc },
      "Read this entry online in the BaseX Wiki"
    }
  } after $c/*:info[1],
  
  (: add anchor to each chapter i.e. article :)
  insert node attribute xml:id { "title" || $page/@title-slug }
  as first into $c
),

delete node C:open($C:DOCBOOKS-PATH)//*:colspec/@*:colwidth[
  ends-with(., "*")
  (:and xs:integer(substring(., 1, string-length(.)-1)) gt 9 (: not delete values below 10 :):)
],

(: rename 100% to 80* :)
for $x in C:open($C:DOCBOOKS-PATH)//*:colspec/@*:colwidth[. = "100%"]
return
  replace value of node $x with "80*",


(: delete some empty elements :)
delete node C:open($C:DOCBOOKS-PATH)//*:index,

db:output(
  C:log("modified semantics in docbooks")
)
