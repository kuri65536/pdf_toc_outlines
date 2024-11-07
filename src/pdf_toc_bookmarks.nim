##[pdf_toc_bookmarks.nim

License: MIT, see LICENSE
]##
import os
import system


type
  Options* = ref object of RootObj
    n_quit: int


proc options(args: seq[string]): Options =
    var ret = Options(
                      )
    return ret


proc main(args: seq[string]): int =
    let opts = options(args)
    if opts.n_quit != 0:
        return opts.n_quit
    ## @todo impl run
    return 0


when isMainModule:
    var args: seq[string] = @[]
    for i in 1..os.paramCount():
        args.add(os.paramStr(i))
    system.quit(main(args))

