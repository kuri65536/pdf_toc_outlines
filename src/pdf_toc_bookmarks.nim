##[pdf_toc_bookmarks.nim

License: MIT, see LICENSE
]##
import os
import system

import pdf_toc_bookmarks/app_extract
import pdf_toc_bookmarks/app_levels
import pdf_toc_bookmarks/app_merge
import pdf_toc_bookmarks/app_outlines
import pdf_toc_bookmarks/app_subst
import pdf_toc_bookmarks/options


proc main(args: seq[string]): int =
    let opts = options(args)
    if opts.n_quit != 0:
        return opts.n_quit
    let (pdf, links) = extract_links(opts.filename, opts.n_pages)
    if isNil(pdf):
        return 11
    if len(links) < 1:
        return 12

    let links2 = subst_links(opts.n_subst, links)
    if len(links2) < 1:
        return 21

    let links3 = merge_links(opts.n_merge, links2)
    if len(links2) < 1:
        return 21

    let links4 = level_links(opts.n_levels, links3)
    if len(links3) < 1:
        return 31

    let err = outlines_from_links(pdf, links4, opts.outname)
    return err


when isMainModule:
    var args: seq[string] = @[]
    for i in 1..os.paramCount():
        args.add(os.paramStr(i))
    system.quit(main(args))

