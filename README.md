# Convert BaseX Wiki to DocBook and PDF

An install script puts the required dependencies in place. Execute
`basex install.xq` to download and extract what is necessary.
For customization consult `xq/config.xqm` if desired. E.g. the temporary
directory or the table of contents shall be changed.

Conversion of BaseX documentation from the wiki on the web to a DocBook and PDF
document is invoked by `basex makedocu.bxs`.

The conversion is done in 12 steps, as described in `meta/wiki2doc.pdf`.
Only articles linked from `Table of Contents` named page appear in the
output in the same order (see `xq/config.xqm`).

If the software was run once, another invocation will update all files. Images
are kept and contents of pages update.

Step 5 and 11 make use of external programs. Those have 1024 MB memory assigned.


## Files in Project

    basex-docu
    ├── .basex                              BaseX config
    ├── basex.svg                           BaseX Logo
    ├── basex-wiki.log                      log file (ignored in git)
    ├── data                                database folder (ignored in git)
    ├── docbook-xsl                         docbook stylesheets, see Dependencies
    ├── docbook.xsl                         includes styles, some customisations
    ├── fop                                 see dependencies
    ├── herold                              see dependencies
    ├── install.xq                          installs all dependencies
    ├── makedocu.bxs                        basex command script to generate the documentation
    ├── meta
    │   ├── master-docbook.xml.pdf          pdf sample
    │   ├── wiki2docbook.key                program workflow raw
    │   └── wiki2docbook.pdf                program workflow
    ├── README.md                           this file
    ├── tmp                                 temp directory (ignored in git)
    └── xq
        ├── 00-get-pages-list.xq
        ├── 01-get-wiki-pages.xq
        ├── 02-modify-page-content.xq
        ├── 03-extract-images.xq
        ├── 04-toc-to-docbook-master.xq
        ├── 05-conv2docbooks.xq
        ├── 06-db-add-docbook.xq
        ├── 07-care-for-link-ids.xq
        ├── 08-care-for-linkends.xq
        ├── 09-modify-docbooks.xq
        ├── 10-generate-all-in-one-docbook.xq
        ├── 11-make-pdf.xq
        ├── config.xqm                      project configuration
        ├── export.bxs                      exports database to tmp
        ├── links-to-nowhere.xq             for analysis: check for deadlinks in docbook
        └── list-missing-articles.xq        for analysis: existing articles that won't appear in the docbook


## Dependencies
All dependencies (except BaseX) can be installed using the XQuery install
script `install.xq`.

* Step 5: [herold](http://www.dbdoclet.org/) is used for conversion of xhtml to XML DocBook,
  e.g. http://www.dbdoclet.org/archives/herold-src-6.1.0-188.zip ;
  tied to 5-conv2docbooks.xq
* Step 11: [Apache FOP](http://xmlgraphics.apache.org/fop/) is used to generate pdf from XML DocBook,
  see http://archive.apache.org/dist/xmlgraphics/fop/binaries/ ;
  tied to 11-make-pdf.xq
* [Docbook Stylesheets (v1.78)](http://sourceforge.net/projects/docbook/files/docbook-xsl-ns/1.78.1/) or latest version;
  tied to docbook.xsl


## References

* FOP parameters (like TOC generator) at http://www.sagehill.net/docbookxsl/TOCcontrol.html#BriefSetToc
* XSL Stylesheets for Conversion
    http://snapshots.docbook.org/ (referred from http://wiki.docbook.org/DocBookXslStylesheets )
* [Apache FOP - Quick Start Guide](http://xmlgraphics.apache.org/fop/quickstartguide.html)


## TODO

- docbook.xsl: alignment in table of contents of final pdf
- syntax highlighting
- incremental updating using metadata (i.e. only load changed articles on second run)
- styling
  - add some colour
- break longlonglong lines
- break br-tags -- deleted at present
- special chars, i.e. ⌘ is replaced by #
- implement authentication to API (neccessary if more than 500 articles available)
