##[pdf_open.nim

License: MIT, see LICENSE
]##
{.emit: "#include <mupdf/fitz.h>".}

import fitz_common
import pdf_common


proc fz_new_context(a, b: pointer, typ: FitzConst): pointer =
    {.emit: "`result` = fz_new_context(`a`, `b`, `typ`);".}


proc register_handler(fz: pointer): bool =
    var f = false;
    {.emit: """fz_try(`fz`) {
            fz_register_document_handlers(`fz`);
        } fz_catch(`fz`) {
            `f` = true;
            // fz_report_error(`fz`);
            fz_drop_context(`fz`);
        }
    """.}
    return f


proc open_document(fz: pointer, filename: cstring): pointer =
    var f = false;
    var doc: pointer = nil
    {.emit: """fz_try(`fz`) {
            `doc` = fz_open_document(`fz`, `filename`);
        } fz_catch(`fz`) {
            `f` = true;
            // fz_report_error(`fz`);
            fz_drop_context(`fz`);
        }
    """.}
    if f:
        return nil
    return doc


proc close_document(fz, doc: pointer): void =
    {.emit: """fz_drop_document(`fz`, `doc`);
               fz_drop_context(`fz`);
     """.}


proc pdf_open*(filename: string): PdfDoc =
    let fz = fz_new_context(nil, nil, FitzConst.STORE_UNLIMITTED)
    if isNil(fz):
        return nil
    if register_handler(fz):
        return nil
    let doc = open_document(fz, cstring(filename))
    if isNil(doc):
        return nil

    result = PdfDoc(fitz: fz,
                    fitz_doc: doc,
                    )


proc pdf_close*(pdf: PdfDoc): void =
    close_document(pdf.fitz, pdf.fitz_doc)

