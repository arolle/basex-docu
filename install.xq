(:~
 : Installs all dependencies
 : loads and extracts zip files
 : @author arolle
 : @see http://github.com/arolle/basex-docu
 :)
import module namespace C = "basex-docu-conversion-config" at "src/config.xqm";

file:create-dir($C:TMP),

(: all sources and their path/name where they shall end up :)
let $deps := (
  map {
    "url" : "http://files.basex.org/etc/basex-docu/docbook-xsl-ns-1.79.1.zip",
    "name" : "docbook"
  },
  map {
    "url" : "http://files.basex.org/etc/basex-docu/fop-2.1-bin.zip",
    "name" : "fop"
  },
  map {
    "url" : "http://files.basex.org/etc/basex-docu/herold-6.1.0-188.zip",
    "name" : "herold"
  }
)

(: load and extract each dependency, if not yet done so :)
for $dep in $deps
let $trg-dir := 'lib/' || $dep("name") || '/'
where not(file:exists($trg-dir))

let $zip-file := $C:TMP || $dep("name") || ".zip" (: save archive locally :)
let $archive  := (
  if(file:exists($zip-file)) then () else (
    file:write-binary($zip-file, fetch:binary($dep("url"))),
    C:log(static-base-uri(), "downloaded: " || $zip-file)
  ),
  stream:materialize(file:read-binary($zip-file))
)
let $entries  := archive:entries($archive)
let $contents := archive:extract-binary($archive)
return (
  for-each-pair($entries, $contents, function($entry, $content) {
    let $path := replace($entry, '^.*?/', $trg-dir)
    return (
      file:create-dir(file:parent($path)),
      file:write-binary($path, $content)
    )
  }),
  C:log(static-base-uri(), "extracted " || $zip-file || " to " || $trg-dir)
)
