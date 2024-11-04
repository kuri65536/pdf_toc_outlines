##[test_outlines.nim

License: MIT, see LICENSE
]##
import ../src/pdf_toc_bookmarks/pdf_open
import ../src/pdf_toc_bookmarks/pdf_doc
import ../src/pdf_toc_bookmarks/pdf_links
import ../src/pdf_toc_bookmarks/pdf_outlines


var pdf = pdf_open.pdf_open("test.pdf")
assert not isNil(pdf)

var n = 0
var links = @[("", "")]
for page in pdf_doc.pdf_pages(pdf):
    echo("search " & $page & "...")
    var link = pdf_links.pdf_link(pdf, page)
    while not isNil(link):
        ## @todo impl extract title from links.
        n += 1
        links.add((link.uri, $n))
        link = pdf_links.pdf_link_next(link)

for (uri, title) in links[1 ..^ 1]:
    n += 1
    echo("add outline: " & $title & "..." & uri)
    pdf_outlines.pdf_add_outline(pdf, -1, uri, title)

pdf_doc.pdf_save(pdf, "test-1.pdf")
pdf_open.pdf_close(pdf)

