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

    ## - loop for measurements
    const th = 4.0
    var levels: seq[float]
    for i in tmp:
        let x = i.rect.x0
        var n = -1
        for j, x_level in levels:
            echo("level-x: (" & $x_level & "," & $x & ")")
            if abs(x_level - x) < th:
                n = j
                break
        if n == -1:
            levels.add(x)
            levels.sort()

    ## - loop for levelings
    result = @[]
    for i in tmp:
        var cur = -1
        for j, x_level in levels:
            if abs(i.rect.x0 - x_level) < th:
                cur = j
                break
        echo("level-x: " & $cur & " - " & i.title)
        result.add(Link(title: i.title,
                        uri: i.uri,
                        level: cur))


proc level_links*(alg: int, links: seq[PdfLink]): seq[Link] =
    case alg:
    of 2:
        return level_links_by_head(links)
    else:
        return level_links_by_xpos(links)

