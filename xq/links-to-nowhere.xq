(:~
 : returns all dead links, with its containing page
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";
declare option output:separator "\n";

for $href in C:open($C:DOCBOOKS-PATH)//@linkend
where empty(C:open($C:DOCBOOKS-PATH)//@xml:id[data() = $href])
return <page docbook="{$href/base-uri()}">{$href/data()}</page>

(: Output

<page docbook="basex-wiki/docbooks/Commands.xml"/>
<page docbook="basex-wiki/docbooks/Commands.xml"/>
<page docbook="basex-wiki/docbooks/Database%20Server.xml"/>
<page docbook="basex-wiki/docbooks/Higher-Order%20Functions%20Module.xml">hof-iterate</page>
<page docbook="basex-wiki/docbooks/Higher-Order%20Functions.xml"/>
<page docbook="basex-wiki/docbooks/Indexes.xml"/>
<page docbook="basex-wiki/docbooks/Math%20Module.xml">math-uuid</page>
<page docbook="basex-wiki/docbooks/Options.xml">global_options</page>
<page docbook="basex-wiki/docbooks/Options.xml"/>
<page docbook="basex-wiki/docbooks/Options.xml"/>
<page docbook="basex-wiki/docbooks/Options.xml"/>
<page docbook="basex-wiki/docbooks/Options.xml"/>
<page docbook="basex-wiki/docbooks/Options.xml"/>
<page docbook="basex-wiki/docbooks/Options.xml"/>
<page docbook="basex-wiki/docbooks/Options.xml"/>
<page docbook="basex-wiki/docbooks/Options.xml"/>
<page docbook="basex-wiki/docbooks/Options.xml"/>
<page docbook="basex-wiki/docbooks/Options.xml"/>
<page docbook="basex-wiki/docbooks/Options.xml"/>
<page docbook="basex-wiki/docbooks/Options.xml"/>
<page docbook="basex-wiki/docbooks/Options.xml"/>
<page docbook="basex-wiki/docbooks/Options.xml"/>
<page docbook="basex-wiki/docbooks/Options.xml"/>
<page docbook="basex-wiki/docbooks/Options.xml"/>
<page docbook="basex-wiki/docbooks/Options.xml"/>
<page docbook="basex-wiki/docbooks/REST.xml"/>
<page docbook="basex-wiki/docbooks/RESTXQ.xml"/>
<page docbook="basex-wiki/docbooks/RESTXQ.xml"/>
<page docbook="basex-wiki/docbooks/RESTXQ.xml">Query_Strings</page>
<page docbook="basex-wiki/docbooks/RESTXQ.xml">Query_Strings</page>
<page docbook="basex-wiki/docbooks/RESTXQ.xml">Query_Strings</page>
<page docbook="basex-wiki/docbooks/RESTXQ.xml"/>
<page docbook="basex-wiki/docbooks/Serialization.xml"/>
<page docbook="basex-wiki/docbooks/Serialization.xml"/>
<page docbook="basex-wiki/docbooks/Serialization.xml"/>
<page docbook="basex-wiki/docbooks/Serialization.xml"/>
<page docbook="basex-wiki/docbooks/Server%20Protocol%3A%20Types.xml"/>
<page docbook="basex-wiki/docbooks/Session%20Module.xml">BXSE0003</page>
<page docbook="basex-wiki/docbooks/Sessions%20Module.xml">BXSE0003</page>
<page docbook="basex-wiki/docbooks/Standalone%20Mode.xml"/>
<page docbook="basex-wiki/docbooks/Standalone%20Mode.xml"/>
<page docbook="basex-wiki/docbooks/Startup.xml"/>
<page docbook="basex-wiki/docbooks/Startup.xml"/>
<page docbook="basex-wiki/docbooks/Startup.xml"/>
<page docbook="basex-wiki/docbooks/Startup.xml"/>
<page docbook="basex-wiki/docbooks/Startup.xml"/>
<page docbook="basex-wiki/docbooks/Startup.xml"/>
<page docbook="basex-wiki/docbooks/Web%20Application.xml"/>
<page docbook="basex-wiki/docbooks/WebDAV.xml"/>
<page docbook="basex-wiki/docbooks/XQuery%20Update.xml"/>
<page docbook="basex-wiki/docbooks/XQuery%20Update.xml"/>

:)