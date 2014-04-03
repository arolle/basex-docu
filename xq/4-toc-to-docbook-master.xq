(:~
 : generate THE BOOK
 : from the Table of Contents
 : whose place is defined in $C:TOC-NAME
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

declare namespace xi = "http://www.w3.org/2001/XInclude";

(: delete if exists :)
if (db:exists($C:WIKI-DB, $C:DOC-MASTER))
then db:delete($C:WIKI-DB, $C:DOC-MASTER)
else (),

(: add new docbook-master :)
let $toc := C:open($C:LS-PAGES)//page[@title = $C:TOC-NAME]
return (
db:add($C:WIKI-DB,
 document {
    <?xml-model href="http://docbook.org/xml/5.0/rng/docbookxi.rng" schematypens="http://relaxng.org/ns/structure/1.0"?>,
    <?xml-model href="http://docbook.org/xml/5.0/rng/docbook.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>,
    <book xmlns="http://docbook.org/ns/docbook"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        xmlns:xlink="http://www.w3.org/1999/xlink" version="5.0" lang="en">
      <info>
        <title>BaseX Documentation</title>
        <subtitle>
          <para>Version {
            C:bx-version()
          }</para>
          <para><inlinemediaobject>
            <imageobject>
              <imagedata fileref="{$C:WIKI-DUMP-IMG}basex.svg" align="center" scalefit="1" width="16cm"/>
            </imageobject>
          </inlinemediaobject></para>
        </subtitle>
        <author>
            <orgname>BaseX</orgname>
            <address>
                <city>Konstanz</city>
                <country>Germany</country>
            </address>
            <email>basex-talk@mailman.uni-konstanz.de</email>
        </author>
        <legalnotice><para>Content is available under <link xlink:href="http://creativecommons.org/licenses/by-sa/3.0/">Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0)</link>.</para></legalnotice>
        <pubdate>{
          substring-before(current-date() ! string(.), '+')
        }</pubdate>
      </info>
      {
        (: transform all includes :)
        let $body := (C:open( $toc/@xml )//*:body)[1]
        for $x in $body//*:h3
        let $items := $x/following-sibling::*[1][name() = "ul"]/*:li/*:a[starts-with(@*:href, "/wiki/")]
        let $link := $x//*:a[starts-with(@*:href, "/wiki/")]
        let $res := $C:PAGES-RELEVANT[
          @title = ( $link, $items )/@*:title
        ] 
        ! element xi:include {
          attribute href { @docbook ! replace(., "%", "%25") }, (: from docbook master to includes :)
          <xi:fallback>
            <para>Broken include of article "{ @title/data() }"</para>
          </xi:fallback>
        }
        return
          if ($items) then element part {
            <title>{
              ($link/text(), $x//*:span[@class = "mw-headline"]/text())[1]
            }</title>,
            $res
          }
          else $res

      }</book>
    }, (: end document node :)
    $C:DOC-MASTER
  ), (: end db:add() :)

  db:output(
    C:logs(static-base-uri(), ("wrote docbook to ", $C:DOC-MASTER, " in db ", $C:WIKI-DB))
  )
) (: end else :)
