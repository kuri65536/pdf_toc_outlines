##[options.nim

License: MIT, see LICENSE
]##
import tables


type
  Options* = ref object of RootObj
    filename*: string
    outname*: string
    n_alg*: int
    n_levels*: int
    n_merge*: int
    n_pages*: seq[int]
    n_quit*: int

  fn_opt = proc(self: Options, args: var seq[string]): bool {.noSideEffect, gcsafe.}


proc usage(): void =
    const project_name = "pdf_toc_outlines"
    const prg = project_name
    const pfx = "  "
    echo(prg & ": extract the TOC and modify pdf outlines")
    echo(pfx & "usage: " & prg & " [options] [file]")
    echo(pfx & "options: ")
    echo(pfx & "  --output or -o [file]   ... specify the output file name")
    echo(pfx & "  --pages or -p [numbers] ... specify TOC pages")
    ## @todo implement


func option_output(self: Options, args: var seq[string]): bool =
    ## @todo implement the error checks
    ## - check the directory exists.
    ## - check it writable.
    self.outname = args[0]
    args.delete(0)
    return false


proc have_arg(arg: string): fn_opt =
    let fns = {
        (s: "o", l: "output"): option_output,
    }.toTable()

    #cho("options:have_arg: " & arg)
    for i in fns.keys():
        if arg == ("-" & i.s) or arg == ("--" & i.l):
            return fns[i]
    return nil


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

    var (tmp, files) = (args, @[""])
    while len(tmp) > 0:
        let arg = tmp[0]
        tmp.delete(0)
        let fn = have_arg(arg)
        if isNil(fn):
            files.add(arg)
        else:
            if fn(ret, tmp):  # abort
                return ret
    ret.filename = files[1]
    return ret

