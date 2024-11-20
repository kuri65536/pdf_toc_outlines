##[app_outlines.nim

License: MIT, see LICENSE
]##
import pdf_common
import pdf_doc
import pdf_open
import pdf_outlines

import app_common


proc outlines_from_links*(pdf: PdfDoc, links: seq[Link]): int =
    var level = 0
    for i in links:
        if i.level > level:
            discard  # level-down
        elif i.level < level:
            discard  # level-up
        else:
            pdf_outlines.pdf_add_outline(pdf, -1, i.uri, i.title)

    if len(links) > 0:
        pdf_doc.pdf_save(pdf, "test-1.pdf")
        
    pdf_open.pdf_close(pdf)
    return 0            
