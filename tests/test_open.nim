##[test_open.nim

License: MIT, see LICENSE
]##
import ../src/pdf_toc_outlines/pdf_open

var pdf = pdf_open.pdf_open("test.pdf")
assert not isNil(pdf)

pdf_open.pdf_close(pdf)

