##[fitz_common.nim

License: MIT, see LICENSE
]##
{.passL: "-lmupdf -lmupdf-third -lmujs -lgumbo -lopenjp2 -ljbig2dec -ljpeg -lz -lm -lfreetype".}

type
  FitzConst* = enum
    STORE_UNLIMITTED = 0

## @fixme import-from-c fizs/version.h
const FZ_VERSION* = "1.21.1"

