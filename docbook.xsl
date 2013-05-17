<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>
<xsl:include href="docbook-xsl-ns-1.78.1/fo/docbook.xsl"/>
<!-- make links blue -->
    <xsl:attribute-set name="xref.properties">
        <xsl:attribute name="color">blue</xsl:attribute>
    </xsl:attribute-set>
</xsl:stylesheet>
