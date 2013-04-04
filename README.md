Convert BaseX Wiki to PDF
=========================

Install the dependencies.

Then run `./makedocu.sh` to convert BaseX documentation from web to pdf. The Conversion is done in 11 steps, as described in `meta/wiki2doc.pdf`.

To convert other projects as BaseX adjust variables in `config.xqm`.

Files in Project
----------------

    basex-docu
    ├── .basex                              BaseX config
    ├── README.md                           this file
    ├── WEB-INF                             WebDAV service instructions
    ├── basex.svg                           BaseX Logo
    ├── basex-wiki.log                      log file (ignored in git)
    ├── data                                database folder
    ├── docbook-xsl-ns                      docbook stylesheets, see Dependencies
    ├── docbook.xsl                         includes styles, some customisations
    ├── makedocu.sh                         file to make the documentation
    ├── meta
    │   ├── master-docbook.xml.pdf          pdf sample
    │   ├── wiki2docbook.key                program workflow raw
    │   └── wiki2docbook.pdf                program workflow
    ├── repo                                used modules (only functx at present)
    └── xq
        ├── 0-get-pages-list.xq
        ├── 1-get-wiki-pages.xq
        ├── 10-make-pdf.xq
        ├── 2-modify-page-content.xq
        ├── 3-extract-images.xq
        ├── 4-toc-to-docbook-master.xq
        ├── 5-webdav2docbooks.xq
        ├── 6-db-add-docbook.xq
        ├── 7-care-for-link-ids.xq
        ├── 8-care-for-linkends.xq
        ├── 9-modify-docbooks.xq
        ├── config.xqm                      project configuration
        └── links-to-nowhere.xq             see TODO


Dependencies
------------

* Step 5: [herold](http://www.dbdoclet.org/) is used for conversion of xhtml to XML DocBook,
	e.g. http://www.dbdoclet.org/archives/herold-src-6.1.0-188.zip
* Step 10: [Apache FOP](http://xmlgraphics.apache.org/fop/) is used to generate pdf from XML DocBook,
	see http://archive.apache.org/dist/xmlgraphics/fop/binaries/
* [Stylesheets](http://sourceforge.net/projects/docbook/files/docbook-xsl-ns/1.78.1/) or latest version
	save this as `docbook-xsl-ns` folder


References
----------

* FOP parameters (like TOC generator) at http://www.sagehill.net/docbookxsl/TOCcontrol.html#BriefSetToc
* XSL Stylesheets for Conversion
    http://snapshots.docbook.org/ (referred from http://wiki.docbook.org/DocBookXslStylesheets )
    http://sourceforge.net/projects/docbook/files/OldFiles/
* [Quick Start Guide](http://xmlgraphics.apache.org/fop/quickstartguide.html)


TODO
----

- make step 10 OS independant
- abstract step 5 and 10 in xq; not using BaseX proc module
- fix 'null' problem, i.e.
    db:open("basex-wiki","docbooks")//*[contains(.,"&lt;null")]
- fix those `xq/links-to-nowhere.xq`
- add some colours
- break longlonglong lines 
- break br-tags -- deleted at present
- table widths -- cells have same width at present as colwidth is deleted in 9
- special chars, i.e. ⌘ is replaced by #

