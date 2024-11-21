##[app_levels.nim

License: MIT, see LICENSE
]##
import algorithm

import pdf_links

import app_common


proc level_links_by_head(links: seq[PdfLink]): seq[Link] =
    ##[
    ]##
    ## - score by heading string
    var tmp: seq[tuple[lvl: int, p: PdfLink]]
    for i in links:
        ## @todo implement.
        let lvl = len(i.title)
        tmp.add((lvl, i))

    ## - sort by heading string
    proc cmp_key(a, b: tuple[lvl: int, p: PdfLink]): int =
        return system.cmp(a.lvl, b.lvl)
    tmp.sort(cmp_key)

    ## - convert to link
    var (level, score) = (-1, -1)
    result = @[]
    for (lvl, i) in tmp:
        if lvl > score:
            level += 1
        elif lvl < score:
            level -= 1
        score = lvl
        result.add(Link(
            title: i.title,
            uri: i.uri,
            level: level,
        ))


proc level_links_by_xpos(links: seq[PdfLink]): seq[Link] =
    ##[leveling 1. x position
    ]##

    ## - sort page and y
    var tmp = links
    tmp.sort(proc(a, b: PdfLink): int =
                let page = system.cmp(a.n_page, b.n_page)
                if page != 0: return page
                return system.cmp(a.rect.y0, b.rect.y0)
                )

    ## - loop
    const th = 4
    var (level, px) = (-1, -9999.9)
    result = @[]
    for i in tmp:
        if i.x - px > th:
            level += 1
        elif i.x - px < -th:
            level -= 1
        px = i.x
        result.add(Link(
            title: i.title,
            uri: i.uri,
            level: level,
        ))


proc level_links*(alg: int, links: seq[PdfLink]): seq[Link] =
    case alg:
    of 2:
        return level_links_by_head(links)
    else:
        return level_links_by_xpos(links)

