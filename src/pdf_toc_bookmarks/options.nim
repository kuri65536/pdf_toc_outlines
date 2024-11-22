##[options.nim

License: MIT, see LICENSE
]##
import algorithm
import strutils
import tables


type
  Options* = ref object of RootObj
    filename*: string
    outname*: string
    n_alg*: int
    n_levels*: int
    n_merge*: int
    n_pages*: seq[int]
    n_subst*: int
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


func option_pages(self: Options, args: var seq[string]): bool =
    var pages: seq[int]

    proc add(n1, n2: int): void =
        if n1 < 0 and n2 < 0: return
        if n2 < 0:
            pages.add(n1); return
        if n1 < 0:
            pages.add(n2); return
        for i in n1..n2:
            pages.add(i)

    proc parse(s: string): int =
        try:
            return parseInt(s.strip())
        except ValueError:
            return -1

    proc parse_range(s, splitter: string): bool =
        let tmp = s.split(splitter)
        if len(tmp) < 2:
            return false
        if len(tmp) > 2:
            discard  # echo("option:pages: ignored " & $tmp[2 ..^ 1])
        let (n1, n2) = (parse(tmp[0]), parse(tmp[1]))
        add(n1, n2)
        return true

    let s_pages = args[0]
    for i in s_pages.split(','):
        if parse_range(i, "-"):  continue
        if parse_range(i, "to"): continue
        let n = parse(i)
        if n == -1: continue
        pages.add(n)
    if len(pages) < 1:
        discard  # echo("option-pages: can't parse pages: " & s_pages)
        return true
    pages.sort()
    self.n_pages = pages
    args.delete(0)
    return false


proc have_arg(arg: string): fn_opt =
    let fns = {
        (s: "o", l: "output"): option_output,
        (s: "p", l: "pages"):  option_pages,
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

