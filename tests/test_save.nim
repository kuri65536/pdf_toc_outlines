##[test_save.nim

License: MIT, see LICENSE
]##
import ../src/pdf_toc_outlines/pdf_open
import ../src/pdf_toc_outlines/pdf_doc

var pdf = pdf_open.pdf_open("test.pdf")
assert not isNil(pdf)

pdf_doc.pdf_save(pdf, "test2.pdf")

pdf_open.pdf_close(pdf)

