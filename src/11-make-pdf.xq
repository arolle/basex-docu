(:
 : convert master docbook using Apache FOP
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

(:
 : For FOP Params (like TOC generator) see
 : http://www.sagehill.net/docbookxsl/TOCcontrol.html#BriefSetToc
 :)
let $param := (
  "article   title",
  "book      toc,title",
  "chapter   title",
  "part      title"
)
let $classpath := C:to-classpath($C:ABS-PATH || "lib/fop/build", "*.jar") ||
                  file:path-separator() ||
                  C:to-classpath($C:ABS-PATH || "lib/fop/lib", "*.jar")
let $pdf := $C:TMP || "BaseX" || C:bx-version() ! fn:replace(.,'\.','') || ".pdf" 
return (
  C:execute("java", (
    (: compare with ./fop/fop :)
    "-Xmx2g",
    "-Djava.awt.headless=true",
    "-classpath", $classpath,
    "org.apache.fop.cli.Main",

    (: all fop options now :)
    "-param", "generate.toc", string-join($param, out:nl()),
    "-param", "highlight.source", "1",
    "-param", "highlight.default.language", "xml",
    "-xml", $C:EXPORT-PATH || $C:DOC-MASTER, 
    "-xsl", "src/docbook.xsl",
    "-pdf", $pdf
  )),

  C:log(static-base-uri(), "converted master pdf to " || $pdf)
)
