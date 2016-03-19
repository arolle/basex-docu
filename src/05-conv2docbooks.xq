(:
 : mount basex-webdav and transform from xhtml to docbook
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

(: convert all non-redirects from xhtml to docbook and output them to $C:TMP-DOCBOOKS-CONV :)
let $basepath := $C:EXPORT-PATH || $C:WIKI-DUMP-PATH
let $docb-export :=
  let $path := $C:EXPORT-PATH || $C:DOCBOOKS-PATH
  return (file:create-dir($path), $path)

return (
  for $name in file:list($basepath, false(), "*.xml")
  (: compare name w/o extension :)
  where substring($name, 1, string-length($name) - 4) = $C:PAGES-RELEVANT/@title-enc
  return C:execute("java", (
    (: compare with herold/bin/herold :)
    "-Xmx1024m",
    "-Dconsole.lineWidth=42",
    "-Dherold.home=" || $C:ABS-PATH || "lib/herold",
    "-jar", $C:ABS-PATH || "lib/herold/jars/herold.jar",

    (: herold args :)
    (:"--docbook-encoding", "uft-8", "--html-encoding", "utf-8",:)
    "-i", $basepath || $name, "-o", $docb-export || $name
    )
  ),
  
  C:log(static-base-uri(),
    "converted files in " || $basepath || " to docbook, written to " || $docb-export
  )
)
