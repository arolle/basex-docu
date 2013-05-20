import module namespace C = "basex-docu-conversion-config" at "xq/config.xqm";

declare option output:separator "\n";


(: all sources and their path/name where they shall end up :)
let $deps := (
  map{
    "url" := "http://sourceforge.net/projects/docbook/files/docbook-xsl-ns/1.78.1/docbook-xsl-ns-1.78.1.zip/download",
    "name" := "docbook-xsl"
  },
  map{
    "url" := "http://archive.apache.org/dist/xmlgraphics/fop/binaries/fop-1.1-bin.zip",
    "name" := "fop"
  },
  map{
    "url" := "http://www.dbdoclet.org/archives/herold-6_1_0-188.zip",
    "name" := "herold"
  }
)


for $m in $deps[3]
let $name := $C:TMP || $m("name") || ".archive",
    (:~ load archive; use existing, if any :)
    $is-loaded := file:exists($name),
    $archive := if ($is-loaded)
      then file:read-binary($name)
      else fetch:binary($m("url")) ! (., file:write-binary($name,.)),
    $items := archive:entries($archive)
return (
  "", $name,
  distinct-values($items ! file:dir-name(.))[position() = 1 to 10]
)

