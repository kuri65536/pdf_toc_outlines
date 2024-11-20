##[app_common.nim

License: MIT, see LICENSE
]##

type
  Link* = ref object of RootObj
    title*: string
    uri*: string
    level*: int

