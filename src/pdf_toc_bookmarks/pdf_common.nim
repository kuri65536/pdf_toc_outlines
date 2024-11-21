##[pdf_common.nim

License: MIT, see LICENSE
]##


type
  PdfDoc* = ref object of RootObj
    fitz*: pointer
    fitz_doc*: pointer

    filename*: string

