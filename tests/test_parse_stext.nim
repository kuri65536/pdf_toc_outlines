##[test_parse_stext.nim

License: MIT, see LICENSE
]##
import streams

import ../src/pdf_toc_bookmarks/pdf_links

let text = open("a.txt", fmRead).readAll()
let strm = newStringStream(text)
#et sstr = parse_fzstext_inrect(strm, (0.0, 0.0, 900.0, 900.0))
let sstr = parse_fzstext_inrect(strm, (200.0, 600.0, 600.0, 630.0))
echo(sstr)

