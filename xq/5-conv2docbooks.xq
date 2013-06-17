(:
 : mount basex-webdav and transform from xhtml to docbook
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

(: convert all non-redirects from xhtml to docbook
 : and place them at $C:TMP-DOCBOOKS-CONV
 :)
let $basepath := $C:EXPORT-PATH || $C:WIKI-DUMP-PATH,
    $docb-export := ($C:EXPORT-PATH || $C:DOCBOOKS-PATH)
      ! (., file:create-dir(.))
return

(

for $name in file:list($basepath, false(), "*.xml")
where
  substring($name, 1, string-length($name)-4) (: name w/o extension :)
  = $C:PAGES-RELEVANT/@title-enc
return
  C:execute("java", (
    (: compare with herold/bin/herold :)
    "-Xmx1024m",
    "-Dconsole.lineWidth=42",
    "-Dherold.home=" || $C:ABS-PATH || "herold",
    "-jar", $C:ABS-PATH || "herold/jars/herold.jar",

    (: herold args :)
    (:"--docbook-encoding", "uft-8", "--html-encoding", "utf-8",:)
    "-i", $basepath || $name, "-o", $docb-export || $name
    )
  ),

C:logs(static-base-uri(), ("converted each page from xhtml (in ", $basepath, ") to docbook, placed those at ", $docb-export))

)
