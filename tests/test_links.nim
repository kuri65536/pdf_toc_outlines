##[test_links.nim

License: MIT, see LICENSE
]##
import ../src/pdf_toc_outlines/pdf_open
import ../src/pdf_toc_outlines/pdf_doc
import ../src/pdf_toc_outlines/pdf_links

var pdf = pdf_open.pdf_open("test.pdf")
assert not isNil(pdf)

for page in pdf_doc.pdf_pages(pdf):
    echo("search " & $page & "...")
    var link = pdf_links.pdf_link(pdf, page)
    while not isNil(link):
        echo("found link: " & link.title & " -> " & link.uri)
        link = pdf_links.pdf_link_next(pdf, link)

pdf_open.pdf_close(pdf)

