##[pdf_outlines.nim

License: MIT, see LICENSE
]##
{.emit: "#include <mupdf/fitz.h>".}

import pdf_common


proc fz_add_outline_to_last*(a, b: pointer, uri, title: cstring): void =
    var n = 0
    {.emit: """ fz_outline_iterator* iter = fz_new_outline_iterator(`a`, `b`);
                while (1) {
                    `n` += 1;
                    int result = fz_outline_iterator_next(`a`, iter);
                    if (result < 0) {break;}
                }
                fz_outline_item item_new = {0};
                item_new.title = `title`;
                item_new.uri = `uri`;
                item_new.is_open = 0;
                fz_outline_iterator_insert(`a`, iter, &item_new);
                fz_drop_outline_iterator(`a`, iter);
               """.}
    echo("fz_add_outline_to_last: " & $n)


proc pdf_add_outline_to_last*(pdf: PdfDoc, uri, title: string): void =
    fz_add_outline_to_last(pdf.fitz, pdf.fitz_doc,
                           cstring(uri), cstring(title))


proc pdf_add_outline*(pdf: PdfDoc, n_pos: int, uri, title: string): void =
    if n_pos == -1:
        pdf_add_outline_to_last(pdf, uri, title)
        return
    assert false, ""

