module namespace C = "basex-docu-conversion-config";

(:~ absolute path to this project :)
declare variable $C:ABS-PATH := file:current-dir();

(: PATHS on HDD :)

(:~ general tmp path :)
declare variable $C:TMP := "tmp/";

(:~ path to export db to :)
declare variable $C:EXPORT-PATH := $C:TMP || "basex-wiki-export/";

(:~ database name :)
declare variable $C:WIKI-DB := "basex-wiki";
(:~ List of Wiki Pages :)
declare variable $C:LS-PAGES := "list-of-wiki-pages.xml";
(:~ List of Wiki Images :)
declare variable $C:LS-IMAGES := "list-of-images.xml";

(:~ master docbook :)
declare variable $C:DOC-MASTER := "master-docbook.xml";
(:~ all-in-one master :)
declare variable $C:MASTER-ALL := "basex-full-documentation.xml";

(:~ Attributes to delete from 'no-render' item in $C:LS-PAGES :)
declare variable $C:NO-RENDER-DEL-ATTR := ("xml", "html", "docbook");

(:~ URI to WIKI :)
declare variable $C:WIKI-BASEURL := "http://docs.basex.org";

(:~ URI to MediaWiki API :)
declare variable $C:BX-API := $C:WIKI-BASEURL || "/api.php?";

(: PATHS in DB :)

(:~ Path to local exports :)
declare variable $C:WIKI-DUMP-PATH := "wikihtml/";

(:~ Path to images of local exports :)
declare variable $C:WIKI-DUMP-IMG := "wikiimg/";
declare variable $C:REL-PATH2IMG := "../" || $C:WIKI-DUMP-IMG;

(:~ Path to converted docbooks in db :)
declare variable $C:DOCBOOKS-PATH := "docbooks/";

(:~ use this wiki-page to declare how to group the items in the final docbook :)
declare variable $C:TOC-NAME := "Table of Contents";

(:~ List of pages to include to docbook :)
declare variable $C:PAGES-RELEVANT := C:open($C:LS-PAGES)//page[
  not(@title = $C:TOC-NAME) (: exclude Table of Contents from operations :)
  and @docbook (: exludes redirects :)
];

(:~
 : logs some text to a logfile
 :)
declare function C:log(
  $id as xs:string,
  $text as xs:string
) as empty-sequence() {
  prof:dump(text { replace($id, "^.*/", "") || ": " || $text })
};

(:~
 : show proc:execute() stuff, in case of error remains silent otherwise
 :)
declare function C:execute(
  $cmd as xs:string,
  $args as xs:string*
) {
  let $res := proc:execute($cmd, $args)
  where $res/code != 0
  return ($cmd || " yields an error " || out:nl(), $res)
};

(:~
 : open document node - abbreviation
 : @param   $path document path in database $C:WIKI-DB
 : @return  corresponding document
 :)
declare function C:open(
  $path as xs:string
) as document-node()* {
  db:open($C:WIKI-DB, $path)
};

(:~
 : finds out which version of BaseX the documentation is for
 :
 : @return  version number
 :)
declare function C:bx-version() as xs:string {
  C:open( $C:WIKI-DUMP-PATH || "Main%20Page.xml")//*:p/*:b
    ! substring-after(., "BaseX ")
};

(:~
 : open documents by name
 : for developing purpose only
 : @param   name
 : @return  document where path contains $name
 :)
declare function C:open-by-name (
  $name as xs:string
) as document-node()* {
  db:list($C:WIKI-DB)[contains(lower-case(.), lower-case($name))] ! C:open(.)
};

(:~
 : generates a string separated by : of certain items
 : located at given path
 : @param   $p path to look at
 : @param   $glob using glob syntax to match files
 : @return  colon separated path with items specified by $glob
 :)
declare function C:to-classpath(
  $p as xs:string,
  $glob as xs:string
) as xs:string {
  string-join(
    file:list($p, false(), $glob) ! ($p || '/' || .)
  , file:path-separator())
};
