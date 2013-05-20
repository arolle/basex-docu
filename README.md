Convert BaseX Wiki to DocBook and PDF
=====================================

Install the dependencies running  `./install.sh`. Adjust varables in
`xq/config.xqm` if desired, e.g. change temp directory.

Then run `./makedocu.sh` to convert BaseX documentation from web to DocBook and
PDF. The same can be achieved by running the BaseX command script `makedocu.bxs`.
The conversion is done in 12 steps, as described in `meta/wiki2doc.pdf`. A
wiki article named `Table of Contents` defines the ordering of the pages
(see `xq/config.xqm`).

If the software was run once, another run will update files. That is, images
are kept and content of wiki pages gets replaced from web. 

For the external Java processes there is memory of 1024 MB assigned. Change these
(if necessary) in step 5 and 11.



Files in Project
----------------

    basex-docu
    ├── .basex                              BaseX config
    ├── basex.svg                           BaseX Logo
    ├── basex-wiki.log                      log file (ignored in git)
    ├── data                                database folder (ignored in git)
    ├── docbook-xsl-ns-1.78.1               docbook stylesheets, see Dependencies
    ├── docbook.xsl                         includes styles, some customisations
    ├── fop-1.1                             see dependencies
    ├── herold                              see dependencies
    ├── install.sh                          installs dependencies
    ├── makedocu.bxs                        basex command script to generate the documentation
    ├── makedocu.sh                         file to make the documentation
    ├── meta
    │   ├── master-docbook.xml.pdf          pdf sample
    │   ├── wiki2docbook.key                program workflow raw
    │   └── wiki2docbook.pdf                program workflow
    ├── README.md                           this file
    ├── repo                                used modules (only functx at present)
    ├── tmp                                 temp directory (ignored in git)
    └── xq
        ├── 0-get-pages-list.xq
        ├── 1-get-wiki-pages.xq
        ├── 2-modify-page-content.xq
        ├── 3-extract-images.xq
        ├── 4-toc-to-docbook-master.xq
        ├── 5-conv2docbooks.xq
        ├── 6-db-add-docbook.xq
        ├── 7-care-for-link-ids.xq
        ├── 8-care-for-linkends.xq
        ├── 9-modify-docbooks.xq
        ├── 10-generate-all-in-one-docbook.xq
        ├── 11-make-pdf.xq
        ├── config.xqm                      project configuration
        ├── export.bxs                      exports database to tmp
        └── links-to-nowhere.xq             for analysis: check for deadlinks in docbook


Dependencies
------------
All dependencies (except BaseX) can be installed using the install
script `./install.sh`.

* BaseX with commands `basex` in `$PATH`
* Step 5: [herold](http://www.dbdoclet.org/) is used for conversion of xhtml to XML DocBook,
	e.g. http://www.dbdoclet.org/archives/herold-src-6.1.0-188.zip ;
  tied to 5-conv2docbooks.xq
* Step 11: [Apache FOP](http://xmlgraphics.apache.org/fop/) is used to generate pdf from XML DocBook,
	see http://archive.apache.org/dist/xmlgraphics/fop/binaries/ ;
  tied to 11-make-pdf.xq
* [Docbook Stylesheets (v1.78)](http://sourceforge.net/projects/docbook/files/docbook-xsl-ns/1.78.1/) or latest version;
  tied to docbook.xsl


References
----------

* FOP parameters (like TOC generator) at http://www.sagehill.net/docbookxsl/TOCcontrol.html#BriefSetToc
* XSL Stylesheets for Conversion
    http://snapshots.docbook.org/ (referred from http://wiki.docbook.org/DocBookXslStylesheets )
* [Apache FOP - Quick Start Guide](http://xmlgraphics.apache.org/fop/quickstartguide.html)


TODO
----


- syntax highlighting
- incremental updating (i.e. only load changed articles on second run)
- abstract step 5 and 11 in xq; not using BaseX proc module
- styling
  - add some colour
  - smaller font-size
- break longlonglong lines 
- break br-tags -- deleted at present
- table widths -- cells have same width at present as colwidth is deleted in 9
- special chars, i.e. ⌘ is replaced by #
- implement authentication to API (neccessary if more than 500 articles available)

