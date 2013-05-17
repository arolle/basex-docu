module namespace _ = "basex-docu-conversion-config";

(:~ absolute path to this project :)
declare variable $_:ABS-PATH := (static-base-uri() ! file:dir-name(.) ! file:dir-name(.)) || $_:DS;

(: PATHES on HDD :)
(:~ general tmp path :)
declare variable $_:TMP := "tmp" || $_:DS;

(:~ path to export db to :)
declare variable $_:EXPORT-PATH := $_:TMP || "basex-wiki-export" || $_:DS;


(:~ abbreviation for slash, or whatever dir separator :)
declare variable $_:DS := file:dir-separator();



(:~ database name :)
declare variable $_:WIKI-DB := "basex-wiki";
(:~ List of Wiki Pages :)
declare variable $_:LS-PAGES := "list-of-wiki-pages.xml";
(:~ List of Wiki Images :)
declare variable $_:LS-IMAGES := "list-of-images.xml";

(:~ master docbook :)
declare variable $_:DOC-MASTER := "master-docbook.xml";
(:~ all-in-one master :)
declare variable $_:MASTER-ALL := "basex-full-documentation.xml";

(:~ Attributes to delete from 'no-render' item in $_:LS-PAGES :)
declare variable $_:NO-RENDER-DEL-ATTR := ("xml", "html", "docbook");

(:~ URI to WIKI :)
declare variable $_:WIKI-BASEURL := "http://docs.basex.org";

(:~ URI to MediaWiki API :)
declare variable $_:BX-API := $_:WIKI-BASEURL || "/api.php?";



(: PATHES in DB :)
(:~ Path to local exports :)
declare variable $_:WIKI-DUMP-PATH := "wikihtml" || $_:DS;

(:~ Path to images of local exports :)
declare variable $_:WIKI-DUMP-IMG := "wikiimg" || $_:DS;
declare variable $_:REL-PATH2IMG := ".." || $_:DS || $_:WIKI-DUMP-IMG;

(:~ Path to converted docbooks in db :)
declare variable $_:DOCBOOKS-PATH := "docbooks" || $_:DS;



(:~ use this wiki-page to declare how to group the items in the final docbook :)
declare variable $_:TOC-NAME := "Table of Contents";

(:~ List of pages to include to docbook :)
declare variable $_:PAGES-RELEVANT := _:open($_:LS-PAGES)//page[
  not(@title = $_:TOC-NAME) (: exclude Table of Contents from operations :)
  and @docbook (: exludes redirects :)
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
 : show proc:execute() stuff, in case of error remains silent otherwise
 :)
declare function _:execute(
  $cmd as xs:string,
  $args as xs:string*
) {
  let $res := proc:execute($cmd, $args)
  return
    if ($res/code = 0)
    then ()
    else ($cmd || " yields an error " || out:nl(), $res)
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


(:~
 : open documents by name
 : for developing purpose only
 : @param   name
 : @return  document where path contains $name
 :)
declare function _:open-by-name (
  $name as xs:string
) as document-node()* {
  db:list($_:WIKI-DB)[contains(., $name)] ! _:open(.)
};


(:~
 : generates a string separated by : of certain items
 : located at given path
 : @param   $p path to look at
 : @param   $glob using glob syntax to match files
 : @return  colon separated path with items specified by $glob
 :)
declare function _:to-PATH(
  $p as xs:string,
  $glob as xs:string
) as xs:string {
  string-join(
    file:list($p, false(), $glob) ! ($p || $_:DS || .)
  , file:path-separator())
};
