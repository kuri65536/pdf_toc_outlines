##[options.nim

License: MIT, see LICENSE
]##
import os


type
  Options* = ref object of RootObj
    filename*: string
    n_alg*: int
    n_levels*: int
    n_merge*: int
    n_pages*: seq[int]
    n_quit*: int


proc usage(): void =
    const project_name = "pdf_toc_outlines"
    const prg = project_name
    const pfx = "  "
    echo(prg & ": extract the TOC and modify pdf outlines")
    echo(pfx & "usage: " & prg & " [options] [file]")
    echo(pfx & "options: ")
    echo(pfx & "  --pages or -p [numbers] ... specify TOC pages")
    ## @todo implement


proc options*(args: seq[string]): Options =
    var ret = Options(n_quit: 0,
                      n_alg: 1,
                      n_levels: 1,
                      n_merge: 1,
                      n_pages: @[1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                      )
    if len(args) < 1:
        usage()
        ret.n_quit = 1
        return ret
        
    ret.filename = args[0]
    return ret

