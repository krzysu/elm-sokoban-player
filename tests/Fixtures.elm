module Fixtures exposing (..)

import Types exposing (Block, EncodedLevel, Level, ViewLevel)


basicEncodedLevel1 : EncodedLevel
basicEncodedLevel1 =
    "5AHABDFAH5A"


basicStringLevel1 : String
basicStringLevel1 =
    """
#####
#@$.#
#####
"""


basicLevel1 : Level
basicLevel1 =
    { width = 5
    , height = 3
    , map =
        [ [ '#', '#', '#', '#', '#' ]
        , [ '#', '@', '$', '.', '#' ]
        , [ '#', '#', '#', '#', '#' ]
        ]
    , id = "5AHABDFAH5A"
    }


basicViewLevel1 : ViewLevel
basicViewLevel1 =
    { player = Block 1 1
    , walls =
        [ Block 0 0
        , Block 1 0
        , Block 2 0
        , Block 3 0
        , Block 4 0
        , Block 0 1
        , Block 4 1
        , Block 0 2
        , Block 1 2
        , Block 2 2
        , Block 3 2
        , Block 4 2
        ]
    , boxes = [ Block 2 1 ]
    , dots = [ Block 3 1 ]
    , gameSize = ( 5, 3 )
    }


dotsEncodedLevel1 : EncodedLevel
dotsEncodedLevel1 =
    "G5AHAGDCDFAHA4GEAHG5A"


dotsStringLevel1 : String
dotsStringLevel1 =
    """
 #####
# $+$.#
#    *#
 #####
"""


dotsLevel1 : Level
dotsLevel1 =
    { width = 7
    , height = 4
    , map =
        [ [ ' ', '#', '#', '#', '#', '#' ]
        , [ '#', ' ', '$', '+', '$', '.', '#' ]
        , [ '#', ' ', ' ', ' ', ' ', '*', '#' ]
        , [ ' ', '#', '#', '#', '#', '#' ]
        ]
    , id = "G5AHAGDCDFAHA4GEAHG5A"
    }


dotsViewLevel1 : ViewLevel
dotsViewLevel1 =
    { player = Block 3 1
    , walls =
        [ Block 1 0
        , Block 2 0
        , Block 3 0
        , Block 4 0
        , Block 5 0
        , Block 0 1
        , Block 6 1
        , Block 0 2
        , Block 6 2
        , Block 1 3
        , Block 2 3
        , Block 3 3
        , Block 4 3
        , Block 5 3
        ]
    , boxes =
        [ Block 2 1
        , Block 4 1
        , Block 5 2
        ]
    , dots =
        [ Block 3 1
        , Block 5 1
        , Block 5 2
        ]
    , gameSize = ( 7, 4 )
    }
