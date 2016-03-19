<?xml version='1.0'?>
<!--
  Customization layer
  for Docbook XSLT
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  version='1.0'>
<!-- load docbook stylesheet -->
<xsl:include href="../lib/docbook/fo/docbook.xsl"/>
<!-- make links red -->
<xsl:attribute-set name="xref.properties">
  <xsl:attribute name="color">#DD1F26</xsl:attribute>
</xsl:attribute-set>
      
<xsl:param name="l10n.gentext.language">en</xsl:param>
<xsl:param name="page.height">29.7cm</xsl:param>
<xsl:param name="page.width">21cm</xsl:param>
<!--xsl:param name="paper.type">A4</xsl:param-->
<xsl:param name="body.start.indent">0pt</xsl:param>

<!-- hide link address after external links -->
<xsl:param name="ulink.show" select="0" />


<!-- change fontsize for headings -->
<xsl:attribute-set name="section.title.level1.properties">
  <xsl:attribute name="font-size">
    <xsl:value-of select="$body.font.master * 1.5"/>
    <xsl:text>pt</xsl:text>
  </xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="section.title.level2.properties">
  <xsl:attribute name="font-size">
    <xsl:value-of select="$body.font.master * 1.3"/>
    <xsl:text>pt</xsl:text>
  </xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="section.title.level3.properties">
  <xsl:attribute name="font-size">
    <xsl:value-of select="$body.font.master * 1.2"/>
    <xsl:text>pt</xsl:text>
  </xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="section.title.level4.properties">
  <xsl:attribute name="font-size">
    <xsl:value-of select="$body.font.master"/>
    <xsl:text>pt</xsl:text>
  </xsl:attribute>
</xsl:attribute-set>

<!-- some background colour for programlistings -->
<xsl:attribute-set name="monospace.verbatim.properties" use-attribute-sets="verbatim.properties">
  <xsl:attribute name="font-family">
      <xsl:value-of select="$monospace.font.family"/>
  </xsl:attribute>
  <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 0.9"/>
      <xsl:text>pt</xsl:text>
  </xsl:attribute>
  <xsl:attribute name="background-color">#F0F0F0</xsl:attribute>
  <xsl:attribute name="wrap-option">wrap</xsl:attribute>
  <xsl:attribute name="hyphenation-character">&#x25BA;</xsl:attribute>
</xsl:attribute-set>

</xsl:stylesheet>
