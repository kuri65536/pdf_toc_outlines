##[app_subst.nim

License: MIT, see LICENSE
]##
import strutils

import pdf_links


proc subst_links*(alg: int, links: seq[PdfLink]): seq[PdfLink] =
    result = @[]
    for i in links:
        i.title = i.title.split(".")[0]
        echo("subst: " & i.title)
        result.add(i)

