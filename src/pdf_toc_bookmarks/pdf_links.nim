##[test_links.nim

License: MIT, see LICENSE
]##
{.emit: "#include <mupdf/fitz.h>".}

import pdf_common


type
  PdfLink* = ref object of RootObj
    p_link: pointer
    uri*: string
    title*: string
    x*: float
    n_page: int


proc fz_load_links(a, b: pointer, n_page: int): pointer =
    {.emit: """fz_page* page = fz_load_page(`a`, `b`, `n_page`);
               `result` = fz_load_links(`a`, page);
               """}


proc fz_load_text(a, b: pointer, n_page: int): pointer =
    proc fn(ctx, state, data: pointer, n: uint): void {.cdecl.} =
        let tmp = cast[ptr UncheckedArray[char]](data)
        var s: string
        for i in 0 .. n - 1:
            let ch = tmp[i]
            if ch == '\n' or len(s) > 80:
                echo(s)
                s = ""
            else:
                s = s & ch
        if len(s) > 0:
            echo(s)
    {.emit: """ fz_page* page = fz_load_page(`a`, `b`, `n_page`);
                fz_output* out = fz_new_output(`a`, 1024, NULL, `fn`, NULL, NULL);
                fz_device* dev = fz_new_xmltext_device(`a`, out);
                fz_run_page(`a`, page, dev, fz_identity, NULL);
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
    result.n_page = n_page
    discard fz_load_text(pdf.fitz, pdf.fitz_doc, n_page)


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
    result = PdfLink(n_page: link.n_page,
                     p_link: p,
                     uri: $tmp)

