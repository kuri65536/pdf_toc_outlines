##[app_outlines.nim

License: MIT, see LICENSE
]##
import os
import strutils

import pdf_common
import pdf_doc
import pdf_open
import pdf_outlines

import app_common


proc make_newname*(src, org: string): string =
    var tmp = if len(src) > 0: src
              else:            org

    var wrk = tmp
    for i in 1 .. 999:
        if not os.fileExists(wrk):
            return wrk
        wrk = tmp.replace(".pdf", "-" & $i & ".pdf")
    return ""



proc outlines_from_links*(pdf: PdfDoc, links: seq[Link], fname_out: string
                          ): int =
    var level = 0
    for i in links:
        if i.level > level:
            discard  # level-down
        elif i.level < level:
            discard  # level-up
        else:
            pdf_outlines.pdf_add_outline(pdf, -1, i.uri, i.title)

    if len(links) > 0:
        let fout = make_newname(fname_out, pdf.filename)
        if len(fout) < 1:
            return 41
        pdf_doc.pdf_save(pdf, fout)
        echo("PDF to saved to " & fout)

    pdf_open.pdf_close(pdf)
    return 0

