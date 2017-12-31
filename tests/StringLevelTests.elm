module StringLevelTests exposing (..)

import Test exposing (..)
import Expect
import Types exposing (Level)
import StringLevel exposing (getStringLevel)


stringLevel : String
stringLevel =
    """
#####|
#@$.#|
#####|
"""


level : Level
level =
    { width = 5
    , height = 3
    , map =
        [ [ '#', '#', '#', '#', '#' ]
        , [ '#', '@', '$', '.', '#' ]
        , [ '#', '#', '#', '#', '#' ]
        ]
    }


all : Test
all =
    describe "StringLevel"
        [ describe "getStringLevel"
            [ test "case 1" <|
                \_ ->
                    Expect.equal (getStringLevel stringLevel) level
            ]
        ]
