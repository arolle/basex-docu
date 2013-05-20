<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>
<xsl:include href="docbook-xsl-ns-1.78.1/fo/docbook.xsl"/>
<!-- make links blue -->
    <xsl:attribute-set name="xref.properties">
        <xsl:attribute name="color">#DD1F26</xsl:attribute>
      </xsl:attribute-set>
      
<xsl:param name="l10n.gentext.language">en</xsl:param>
<xsl:param name="page.height">29.7cm</xsl:param>
<xsl:param name="page.width">21cm</xsl:param>
<!--xsl:param name="paper.type">A4</xsl:param-->
<xsl:param name="body.start.indent">0pt</xsl:param>

<xsl:attribute-set name="formal.title.properties">
  <xsl:attribute name="font-size">
    <xsl:value-of select="$body.font.master * 1.2" />
    <xsl:text>pt</xsl:text>
  </xsl:attribute>
</xsl:attribute-set>
</xsl:stylesheet>
