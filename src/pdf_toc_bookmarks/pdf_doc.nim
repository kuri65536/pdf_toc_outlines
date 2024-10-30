##[pdf_doc.nim

License: MIT, see LICENSE
]##
{.emit: "#include <mupdf/pdf.h>".}

import pdf_common


proc fz_save_as_pdf(a, b: pointer, filename: cstring): void =
    var tmp: pointer
    {.emit: "`tmp` = pdf_document_from_fz_document(`a`, `b`);".}
    if isNil(tmp):
        # not PDF document.
        return
    {.emit: """pdf_write_options opts = {0};
            pdf_save_document(`a`, `tmp`, `filename`, &opts);
            pdf_drop_document(`a`, `tmp`);
            """.}


proc pdf_save*(pdf: PdfDoc, filename: string): void =
    fz_save_as_pdf(pdf.fitz, pdf.fitz_doc, cstring(filename))

