#!/usr/bin/env bash


TMPPATH=tmp/
mkdir -p $TMPPATH

# Install script
# get all required packages


# Install Docbook XSL Stylesheets
# found later in 'docbook-xsl-ns-1.78.1' folder
OUTDIR=docbook-xsl-ns-1.78.1
wget http://sourceforge.net/projects/docbook/files/docbook-xsl-ns/1.78.1/docbook-xsl-ns-1.78.1.zip/download --output-document="${TMPPATH}${OUTDIR}.zip"
unzip -u $TMPPATH$OUTDIR


# Install XHTML to DocBook converter
# found later in 'herold' folder
OUTDIR=herold
wget http://www.dbdoclet.org/archives/herold-6.1.0-188.tar.gz --output-document="${TMPPATH}${OUTDIR}.tar"
tar -xf "$TMPPATH${OUTDIR}.tar"
rm -rf man # comes from herold


# Install Apache FOP
# found later in 'fop-1.1'
OUTDIR=apachefop
wget http://archive.apache.org/dist/xmlgraphics/fop/binaries/fop-1.1-bin.tar.gz --output-document="${TMPPATH}${OUTDIR}.tar"
tar -xf "${TMPPATH}${OUTDIR}.tar"

