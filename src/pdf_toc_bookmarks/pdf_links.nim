##[test_links.nim

License: MIT, see LICENSE
]##
{.emit: "#include <mupdf/fitz.h>".}

import pdf_common


type
  PdfLink* = ref object of RootObj
    p_link: pointer
    uri*: string


proc fz_load_links(a, b: pointer, n_page: int): pointer =
    {.emit: """fz_page* page = fz_load_page(`a`, `b`, `n_page`);
               `result` = fz_load_links(`a`, page);
               """}


proc pdf_link*(pdf: PdfDoc, n_page: int): PdfLink =
    result = PdfLink()
    let link = fz_load_links(pdf.fitz, pdf.fitz_doc, n_page)
    if isNil(link):
        return nil
    result.p_link = link
    var tmp: cstring
    {.emit: """fz_link* l = (fz_link*)`link`;
               `tmp` = l->uri;
               """}
    result.uri = $tmp


proc pdf_link_next*(link: PdfLink): PdfLink =
    var p = link.p_link
    if isNil(p):
        return nil
    {.emit: """fz_link* l = (fz_link*)`p`;
               `p` = l->next;
               """}
    if isNil(p):
        return nil

    var tmp: cstring
    {.emit: """fz_link* l2 = (fz_link*)`p`;
               `tmp` = l2->uri;
               """}
    result = PdfLink(p_link: p,
                     uri: $tmp)

