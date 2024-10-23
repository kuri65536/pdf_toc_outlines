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


proc pdf_open*(filename: string): PdfDoc =
    let fz = fz_new_context(nil, nil, FitzConst.STORE_UNLIMITTED)
    if isNil(fz):
        return nil
    if register_handler(fz):
        return nil

    result = PdfDoc(fitz: fz)

