##[app_merge.nim

License: MIT, see LICENSE
]##
import pdf_links


proc merge_links_row(links: seq[PdfLink]): seq[PdfLink] =
    ##[@todo not implemented.
    ]##
    return links


proc merge_links*(alg: int, links: seq[PdfLink]): seq[PdfLink] =
    case alg:
    of 1:
        return merge_links_row(links)
    else:
        return links

