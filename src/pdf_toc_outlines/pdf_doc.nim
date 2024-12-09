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


proc fz_pages(a, b: pointer): int =
    var n_pages = 0
    {.emit: """int n_chapters = fz_count_chapters(`a`, `b`);
               for (int i = 0; i < n_chapters; i++) {
                    int n = fz_count_chapter_pages(`a`, `b`, i);
                    `n_pages` += n;
               }
            """.}
    return n_pages


proc pdf_save*(pdf: PdfDoc, filename: string): void =
    fz_save_as_pdf(pdf.fitz, pdf.fitz_doc, cstring(filename))


iterator pdf_pages*(pdf: PdfDoc): int =
    let n = fz_pages(pdf.fitz, pdf.fitz_doc)
    for i in 0..n - 1:
        yield i

