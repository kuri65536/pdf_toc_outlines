##[test_links.nim

License: MIT, see LICENSE
]##
{.emit: "#include <mupdf/fitz.h>".}

import streams
import strutils
import parsexml
import tables
import unicode

import pdf_common


type
  rect_tup = tuple[x0, y0, x1, y1: float]

  PdfLink* = ref object of RootObj
    pdf_page: pointer
    #[
    n_page: int
    ]#
    p_dev: pointer
    p_link: pointer
    p_outs: pointer
    p_page: pointer
    uri*: string
    title*: string
    x*: float
    rect: rect_tup

  pdf_text = tuple[x, y: float, pt: float, text: string]

var strm {.threadvar.}: StringStream


proc contains(self: rect_tup, x, y: float): bool =
    if x < self.x0: return false
    if y < self.y0: return false
    if x > self.x1: return false
    if y > self.y1: return false
    return true


proc parse_span_ctm(src: Table[string, string]): array[6, float] =
    const fallback = [1.0, 0.0, 0.0, 1.0, 0.0, 0.0]
    #onst key = "ctm"
    const key = "trm"
    if not src.contains(key):
        return fallback
    let s_ctm = src[key]
    let a_ctm = s_ctm.split(' ')
    for idx, i in a_ctm:
        let f = try:
              parseFloat(strutils.strip(i))
          except ValueError:
              return fallback
        result[idx] = f


proc fz_trans_pt(src: tuple[x, y: float], mat: array[6, float]
                 ): tuple[x, y: float] =
    let (a, b, c, d, e, f) = (mat[0], mat[1], mat[2],
                              mat[3], mat[4], mat[5])
    echo("trans:max: " & $mat)
    echo("trans:src: " & $src)
    var (x, y) = (src.x, src.y)
    {.emit: """ fz_matrix mat = fz_make_matrix(`a`, `b`, `c`, `e`, `d`, `f`);
                fz_point cur = fz_make_point(`x`, `y`);
                fz_point pt = fz_transform_vector(cur, mat);
                `x` = pt.x;
                `y` = pt.y;
                """.}
    echo("trans:ret: " & $x & "," & $y)
    return (x, y)


proc fz_load_links(a, b: pointer, n_page: int): tuple[link, page: pointer] =
    var l, p: pointer
    {.emit: """fz_page* page = fz_load_page(`a`, `b`, `n_page`);
                `l` = fz_load_links(`a`, page);
                `p` = page;
               """}
    return (l, p)


proc sort_text(src: seq[pdf_text]): string =

    proc insert2(t: var seq[tuple[y: float, strs: seq[pdf_text]]],
                 n: int, s: pdf_text) =
        let (y, tmp) = t[n]
        var (m, tmp2) = (-1, tmp)
        for m, i in tmp:
            if i.x > s.x:
                break
        if m < 0:
            tmp2.add(s)
        else:
            tmp2.insert(s, m)
        t[n] = (y, tmp2)

    proc insert(t: var seq[tuple[y: float, strs: seq[pdf_text]]],
                s: pdf_text) =
        var n = -1
        for m, k in t:
            if s.y < k.y:
                n = m; break
        if n < 0:
            t.add((s.y, @[s]))
        else:
            insert2(t, n, s)

    const same_y = 1e-4
    var rows: seq[tuple[y: float, strs: seq[pdf_text]]]
    for i in src:
        var n = -1
        for j, (y0, tmp2) in rows:
            let dy = system.abs(i.y - y0)
            if dy < same_y:
                n = j
                break
        if n < 0:
            insert(rows, i)
            continue
        insert2(rows, n, i)

    result = ""
    for row in rows:
        for s in row.strs:
            result &= s.text
    return result


proc xml_parse_attr(x: var XmlParser, tag: string
                    ): tuple[f: bool, attrs: Table[string, string]] =
    var ret = initTable[string, string]()
    while true:
        next(x)
        case x.kind
        of xmlAttribute:
            let (key, val) = (x.attrKey, x.attrValue)
            #cho("attr: new key-val -> (" & key & ", " & val & ")")
            ret[key] = val
        of xmlElementClose:
            return (true, ret)
        of xmlEof:
            return (false, ret)
        else:
            echo("attr: waste?")
            discard
    return (false, ret)


proc xml_parse(x: var XmlParser, rect: rect_tup): seq[pdf_text]


proc xml_parse_element_char(cur: seq[pdf_text],
                            attrs: Table[string, string], rect: rect_tup
                            ): seq[pdf_text] =
    #cho("element-char: " & $attrs)
    let ch = block:
        let s_num = attrs.getOrDefault("ucs", "")
        let num = parseInt(s_num)
        Rune(num).toUTF8()
    if len(ch) < 1:
        return cur
    let x = parseFloat(attrs["x"])
    let y = parseFloat(attrs["y"])

    #cho("found text: " & ch)
    #cho("found in rect: attrs: " & $attrs)
    var tmp = cur
    tmp.add((x, y, 11.0, ch))
    return tmp


proc xml_parse_element_tag(tag: string, cur: seq[pdf_text],
                           attrs: Table[string, string], rect: rect_tup
                           ): seq[pdf_text] =
    if tag == "char":
        return xml_parse_element_char(cur, attrs, rect)

    elif tag == "span":
        #cho("element-span: rect:" & $rect)
        #cho("element-span: attrs:" & $attrs)
        let ctm = parse_span_ctm(attrs)
        var (tmp, x, y) = ("", 9999.0, 9999.0)
        for i in cur:
            (x, y) = (min(x, i.x), min(y, i.y))
            let (x0, y0) = fz_trans_pt((x, y), ctm)
            if not rect.contains(x0, y0):
                continue
            tmp &= i.text
        if len(tmp) < 1:
            return @[]

        let tmp2 = (x, y, 11.0, tmp)
        return @[tmp2]

    else:
        #cho("unproceed tag(" & tag & "): " & $attrs)
        discard
    return cur


proc xml_parse_element(x: var XmlParser, tag: string, rect: rect_tup,
                       attrs = initTable[string, string]()): seq[pdf_text] =
    #cho("enter " & tag & ":" & $attrs)
    result = @[]
    while true:
        next(x)
        case x.kind
        of xmlElementEnd:
            if x.elementName != tag:
                # error
                discard
            break
        of xmlEof:
            break
        of xmlElementStart:
            let ret = xml_parse_element(x, x.elementName, rect)
            result.add(ret)
        of xmlElementOpen:
            let tag = x.elementName
            let (f, attr) = xml_parse_attr(x, tag)
            if f:
                let ret = xml_parse_element(x, tag, rect, attr)
                result.add(ret)
        #[ no raw text in pdf as stext
        of xmlCharData, xmlWhitespace:
            text &= x.charData
        ]#
        else:
            discard
    result = xml_parse_element_tag(tag, result, attrs, rect)


proc xml_parse(x: var XmlParser, rect: rect_tup): seq[pdf_text] =
    result = @[]
    while true:
        x.next()
        case x.kind:
        of xmlEof:
            break
        of xmlElementStart:
            let ret = xml_parse_element(x, x.elementName, rect)
            result.add(ret)
        of xmlElementOpen:
            let tag = x.elementName
            let (f, attr) = xml_parse_attr(x, tag)
            if f:
                let ret = xml_parse_element(x, tag, rect, attr)
                result.add(ret)
        else:
            discard


proc parse_fzstext_inrect*(strm: Stream, rect: rect_tup): seq[pdf_text] =
    var x: XmlParser
    open(x, strm, "", {})
    let nodes = xml_parse(x, rect)
    close(x)
    return nodes


proc fz_load_text(a, b: pointer, src: PdfLink): string =
    if not isNil(strm):
        # need to lock...
        discard
    strm = newStringStream()

    proc fn(ctx, state, data: pointer, n: uint): void {.cdecl.} =
        let tmp = cast[ptr UncheckedArray[char]](data)
        for i in 0 .. n - 1:
            strm.write(tmp[i])

    let p_page = src.pdf_page
    {.emit: """ fz_page* page = (fz_page*)`p_page`;
                fz_output* out = fz_new_output(`a`, 1024, NULL, `fn`, NULL, NULL);
                fz_device* dev = fz_new_xmltext_device(`a`, out);
                fz_run_page(`a`, page, dev, fz_identity, NULL);
                fz_drop_device(`a`, dev);
                fz_drop_output(`a`, out);
               """}

    strm.flush()
    strm.setPosition(0)
    #[
    echo(strm.readAll())
    strm.setPosition(0)
    ]#
    let nodes = parse_fzstext_inrect(strm, src.rect)
    close(strm)
    strm = nil

    return sort_text(nodes)


proc pdf_link_pointer*(src: pointer, page: pointer): PdfLink =
    var tmp: cstring
    var x0, y0, x1, y1: cfloat
    {.emit: """fz_link* l = (fz_link*)`src`;
               `tmp` = l->uri;
               `x0` = l->rect.x0;
               `y0` = l->rect.y0;
               `x1` = l->rect.x1;
               `y1` = l->rect.y1;
               """}
    result = PdfLink(
        p_link: src,
        pdf_page: page,
        uri: $tmp,
        rect: (float(x0), float(y0), float(x1), float(y1)),
    )
    #cho($result.rect)



proc pdf_link*(pdf: PdfDoc, n_page: int): PdfLink =
    let (link, page) = fz_load_links(pdf.fitz, pdf.fitz_doc, n_page)
    #cho("pdf_link: " & $n_page & " ... " & $isNil(link))
    if isNil(link):
        return nil
    result = pdf_link_pointer(link, page)
    result.title = fz_load_text(pdf.fitz, pdf.fitz_doc, result)


proc pdf_link_next*(pdf: PdfDoc, link: PdfLink): PdfLink =
    var p = link.p_link
    if isNil(p):
        return nil
    {.emit: """fz_link* l = (fz_link*)`p`;
               `p` = l->next;
               """}
    if isNil(p):
        return nil
    result = pdf_link_pointer(p, link.pdf_page)
    result.title = fz_load_text(pdf.fitz, pdf.fitz_doc, result)

