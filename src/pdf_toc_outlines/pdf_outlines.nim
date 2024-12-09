##[pdf_outlines.nim

License: MIT, see LICENSE
]##
{.emit: "#include <mupdf/fitz.h>".}

import pdf_common


type
  PdfOutlineIter* = ref object of RootObj
    p: pointer


proc pdf_new_outline_iter*(pdf: PdfDoc): PdfOutlineIter =
    let a = pdf.fitz
    let b = pdf.fitz_doc
    var c: pointer
    {.emit: """ fz_outline_iterator* iter = fz_new_outline_iterator(`a`, `b`);
                `c` = iter;
                """.}
    return PdfOutlineIter(p: c)

    
proc pdf_drop_outline_iter*(pdf: PdfDoc, it: PdfOutlineIter): void =
    let a = pdf.fitz
    let c = it.p
    {.emit: """ fz_drop_outline_iterator(`a`, `c`);
               """.}


proc pdf_outline_iter_up*(pdf: PdfDoc, it: PdfOutlineIter): int =
    let a = pdf.fitz
    let c = it.p
    {.emit: """ `result` = fz_outline_iterator_up(`a`, `c`);
                """.}


proc pdf_outline_iter_down*(pdf: PdfDoc, it: PdfOutlineIter): int =
    let a = pdf.fitz
    let c = it.p
    {.emit: """ `result` = fz_outline_iterator_down(`a`, `c`);
                """.}


proc pdf_outline_iter_prev*(pdf: PdfDoc, it: PdfOutlineIter): int =
    let a = pdf.fitz
    let c = it.p
    {.emit: """ `result` = fz_outline_iterator_prev(`a`, `c`);
                """.}


proc pdf_outline_iter_next*(pdf: PdfDoc, it: PdfOutlineIter): int =
    let a = pdf.fitz
    let c = it.p
    {.emit: """ `result` = fz_outline_iterator_next(`a`, `c`);
                """.}


proc pdf_add_outline2*(pdf: PdfDoc, it: PdfOutlineIter,
                       uri, title: string): int =
    let a = pdf.fitz
    let c = it.p
    let c_title = cstring(title)
    let c_uri = cstring(uri)
    {.emit: """ fz_outline_item item_new = {0};
                item_new.title = `c_title`;
                item_new.uri = `c_uri`;
                item_new.is_open = 0;
                `result` = fz_outline_iterator_insert(`a`, `c`, &item_new);
               """.}


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

