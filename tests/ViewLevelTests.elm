module ViewLevelTests exposing (..)

import Test exposing (..)
import Expect
import Types exposing (Block, Level, ViewLevel)
import ViewLevel exposing (getViewLevelFromLevel)


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


viewLevel : ViewLevel
viewLevel =
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


all : Test
all =
    describe "ViewLevel"
        [ describe "getViewLevelFromLevel"
            [ test "case 1" <|
                \_ ->
                    Expect.equal (getViewLevelFromLevel level) viewLevel
            ]
        ]
