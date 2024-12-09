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
    let it = pdf_new_outline_iter(pdf)
    var level = 0
    for i in links:
        if level > i.level:
            while level > i.level:
                let ret = pdf_outlines.pdf_outline_iter_up(pdf, it)
                echo("outline:up:   " & $ret & "->" & i.title)
                level -= 1
            let ret = pdf_outlines.pdf_outline_iter_next(pdf, it)
            echo("outline:next: " & $ret & "->" & i.title)
        elif level < i.level:
            let ret = pdf_outlines.pdf_outline_iter_prev(pdf, it)
            echo("outline:prev: " & $ret & "->" & i.title)
            while level < i.level:
                let ret = pdf_outlines.pdf_outline_iter_down(pdf, it)
                echo("outline:down: " & $ret & "->" & i.title)
                level += 1
        let ret = pdf_outlines.pdf_add_outline2(pdf, it, i.uri, i.title)
        echo("outline:add:  " & $ret & " <- " & i.title)
    pdf_outlines.pdf_drop_outline_iter(pdf, it)

    if len(links) > 0:
        let fout = make_newname(fname_out, pdf.filename)
        if len(fout) < 1:
            return 41
        pdf_doc.pdf_save(pdf, fout)
        echo("PDF to saved to " & fout)

    pdf_open.pdf_close(pdf)
    return 0

