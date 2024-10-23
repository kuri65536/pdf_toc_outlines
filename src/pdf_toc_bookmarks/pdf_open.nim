##[pdf_open.nim

License: MIT, see LICENSE
]##
import fitz_common
import pdf_common


proc fz_new_context_imp(a, b: pointer, typ: FitzConst, ver: cstring
                        ): pointer {.importc.}


proc pdf_open*(filename: string): PdfDoc =
    #et fz = fz_new_context_imp(nil, nil, FitzConst.STORE_UNLIMITTED, FZ_VERSION)
    #et fz = fz_new_context_imp(nil, nil, FitzConst.STORE_UNLIMITTED, "1.21.1")
    let fz = fz_new_context_imp(nil, nil, FitzConst.STORE_UNLIMITTED, cstring("1.21.1"))
    if isNil(fz):
        return nil
    result = PdfDoc(fitz: fz)

