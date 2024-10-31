##[test_open.nim

License: MIT, see LICENSE
]##
import ../src/pdf_toc_bookmarks/pdf_open
import ../src/pdf_toc_bookmarks/pdf_doc

var pdf = pdf_open.pdf_open("test.pdf")
assert not isNil(pdf)

for i in pdf_doc.pdf_pages(pdf):
    echo(i)

pdf_open.pdf_close(pdf)

