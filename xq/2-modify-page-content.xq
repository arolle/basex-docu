(:~
 : modify xhtml
 : do some conversions/replacements
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

let $doc := db:open($C:WIKI-DB)
return (
(:  (: change relative edit link, if not yet changed :)
  for $a in $doc//*:span[@class = "editsection"]/*:a[not(starts-with(@href, $C:WIKI-BASEURL))]
  return
    replace value of node $a/@href with ($C:WIKI-BASEURL || $a/@href/data()), :)
  (: remove edit links :)
  delete node $doc//*:span[@class = "editsection" (:and count(parent::*//*:a) > 1:)],
            
  (: no hr, no br equivalent in docbook
   : remove empty code or dl tags
   :)
  delete node ($doc//br, $doc//hr, $doc//(code, dl)[string-length(.) = 0]),
  (: no empty dd nodes accepted in docbook :)
  delete node $doc//dd[count(*) = 0],
  
  (: delete table of contents :)
  delete node $doc//table[@id = "toc"],
  (: delete magifying lense -- put on images:)  
  delete node $doc//div[@class = "magnify"]
),

db:output(
  C:log("modified html of all wiki pages")
)
