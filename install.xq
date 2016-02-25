(:~
 : Installs all dependencies
 : loads and extracts zip files
 : @author arolle
 : @see http://github.com/arolle/basex-docu
 :)
import module namespace C = "basex-docu-conversion-config" at "xq/config.xqm";

file:create-dir($C:TMP),

(: all sources and their path/name where they shall end up :)
let $deps := (
  map {
    "url" : "http://downloads.sourceforge.net/project/docbook/docbook-xsl-doc/1.79.1/docbook-xsl-doc-1.79.1.zip?r=&amp;ts=1456326295&amp;use_mirror=netix",
    "name" : "docbook-xsl"
  },
  map {
    "url" : "http://archive.apache.org/dist/xmlgraphics/fop/binaries/fop-1.1-bin.zip",
    "name" : "fop"
  },
  map { (: original url: http://www.dbdoclet.org/archives/herold-6_1_0-188.zip :)
    "url" : "http://files.basex.org/etc/herold-6.1.0-188.zip",
    "name" : "herold"
  }
)

(: load and extract each dependency, if not yet done so :)
for $dep in $deps
let $trg-dir := $dep("name") || '/'
where not(file:exists($trg-dir))
return
  let $name := $C:TMP || $dep("name") || ".zip" (: save archive locally :)
  let $archive  := (
    if(file:exists($name)) then () else
    file:write-binary($name, fetch:binary($dep("url"))),
    stream:materialize(file:read-binary($name))
  )
  let $entries  := archive:entries($archive)
  let $contents := archive:extract-binary($archive)
  return (
    for $entry at $p in $entries
    let $path := replace($entry, '^.*?/', $trg-dir)
    return (
      file:create-dir(replace($path, "/[^/]*$", "")),
      file:write-binary($path, $contents[$p])
    ),
    C:logs(static-base-uri(), ("extracted ", $name, " to ", $dep("name"), '/'))
  )
