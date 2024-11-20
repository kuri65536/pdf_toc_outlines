##[app_extract.nim

License: MIT, see LICENSE
]##
import pdf_common
import pdf_doc
import pdf_links
import pdf_open


proc extract_links*(fname: string, pages: seq[int]
                    ): tuple[pdf: PdfDoc, links: seq[PdfLink]] =
    var pdf = pdf_open.pdf_open("test.pdf")
    if isNil(pdf):
        return (nil, @[])

    var links: seq[PdfLink]
    for page in pdf_doc.pdf_pages(pdf):
        if len(pages) > 0:
            if not pages.contains(page):
                continue
        var link = pdf_links.pdf_link(pdf, page)
        while not isNil(link):
            links.add(link)
            link = pdf_links.pdf_link_next(pdf, link)

    if len(links) < 1:
        pdf_open.pdf_close(pdf)
        return (pdf, @[])
    return (pdf, links)

