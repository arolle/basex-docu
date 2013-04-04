module namespace _ = "basex-docu-conversion-config";

(:~ database name :)
declare variable $_:WIKI-DB := "basex-wiki";
(:~ List of Wiki Pages :)
declare variable $_:LS-PAGES := "list-of-wiki-pages.xml";

(:~ master docbook :)
declare variable $_:DOC-MASTER := "master-docbook.xml";


(:~ Attributes to delete from 'no-render' item in $_:LS-PAGES :)
declare variable $_:NO-RENDER-DEL-ATTR := ("xml", "html", "docbook");

(:~ URI to WIKI :)
declare variable $_:WIKI-BASEURL := "http://docs.basex.org";

(:~ URI to MediaWiki API :)
declare variable $_:BX-API := $_:WIKI-BASEURL || "/api.php?";

(:~ Path to local exports :)
declare variable $_:WIKI-DUMP-PATH := "wikihtml/";

(:~ Path to images of local exports :)
declare variable $_:WIKI-DUMP-IMG := "wikiimg/";
declare variable $_:REL-PATH2IMG := "../" || $_:WIKI-DUMP-IMG;

(:~ Path to converted docbooks in db :)
declare variable $_:DOCBOOKS-PATH := "docbooks/";

(:~ Path to converted docbooks on hdd
 : note: has to end with a /
 : also defined in shellscript!
 :)
declare variable $_:TMP-DOCBOOKS-CONV := "/tmp/bx-docbooks/";

(:~ use this wiki-page to declare how to group the items in the final docbook :)
declare variable $_:TOC-NAME := "Table of Contents";

(:~ List of pages to include to docbook :)
declare variable $_:PAGES-RELEVANT := _:open($_:LS-PAGES)//page[
    not(@title = $_:TOC-NAME) (: exclude Table of Contents from operations :)
    (:and not(@title =
          ("Main Page", "Shortcuts", "Storage Layout")
        ):)
];


(:~
 : logs some text to a logfile
 :)
declare function _:log($text as xs:string) {
  file:append( $_:WIKI-DB || ".log", current-date() || out:tab() ||current-time() || out:tab() || $text || out:nl())
};
declare function _:logs($texts as item()*) {
  _:log( string-join( $texts ! string() ) )
};



(:~
 : open document node - abbreviation
 : @param   $path document path in database $_:WIKI-DB
 : @return  corresponding document
 :)
declare
function _:open (
  $path as xs:string
) as document-node()* {
  db:open($_:WIKI-DB, $path)
};


(:
TODO
- Implement authentication to API (neccessaryif more than 500 articles available)
  using first request to "?action=login&lgname=user&lgpassword=password"


:)