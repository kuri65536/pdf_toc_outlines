##[test_option_pages.nim

License: MIT, see LICENSE
]##
import ../src/pdf_toc_outlines/options

block:  ## - test.1 default values
    let opt = options(@["dummy.pdf"])
    assert opt.n_pages == @[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

block:  ## - test.2 short form
    let opt = options(@["-p", "1", "dummy.pdf"])
    assert opt.n_pages == @[1]

block:  ## - test.3 long form
    let opt = options(@["dummy.pdf", "--pages", "1"])
    assert opt.n_pages == @[1]

block:  ## - test.11 splitted pages 2
    let opt = options(@["dummy.pdf", "--pages", "3,2"])
    assert opt.n_pages == @[2, 3]

block:  ## - test.12 splitted pages 3
    let opt = options(@["dummy.pdf", "--pages", "2,3,4"])
    assert opt.n_pages == @[2, 3, 4]

block:  ## - test.13 splitted pages 4
    let opt = options(@["dummy.pdf", "--pages", "10,11,12,13"])
    assert opt.n_pages == @[10, 11, 12, 13]

block:  ## - test.21 ranged values 1
    let opt = options(@["dummy.pdf", "-p", "10-99"])
    var exp: seq[int]
    for i in 10 .. 99:
        exp.add(i)
    assert opt.n_pages == exp

block:  ## - test.22 ranged values 2
    let opt = options(@["dummy.pdf", "-p", "101to102"])
    var exp: seq[int]
    for i in 101 .. 102:
        exp.add(i)
    assert opt.n_pages == exp

block:  ## - test.31 mixed case 1
    let opt = options(@["dummy.pdf", "-p", "5,1to2,9"])
    assert opt.n_pages == @[1, 2, 5, 9]

block:  ## - test.31 mixed case 2
    let opt = options(@["dummy.pdf", "-p", "3-4,6,8to9"])
    assert opt.n_pages == @[3, 4, 6, 8, 9]

