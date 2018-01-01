module ViewLevelTests exposing (..)

import Test exposing (..)
import Expect
import Types exposing (Block, Level, ViewLevel)
import ViewLevel exposing (getViewLevelFromLevel, getLevelFromViewLevel)


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


levelTestDots : Level
levelTestDots =
    { width = 7
    , height = 4
    , map =
        [ [ ' ', '#', '#', '#', '#', '#' ]
        , [ '#', ' ', '$', '+', '$', '.', '#' ]
        , [ '#', ' ', ' ', ' ', ' ', '*', '#' ]
        , [ ' ', '#', '#', '#', '#', '#' ]
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


viewLevelTestDots : ViewLevel
viewLevelTestDots =
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


all : Test
all =
    describe "ViewLevel"
        [ describe "getViewLevelFromLevel"
            [ test "simple" <|
                \_ ->
                    Expect.equal (getViewLevelFromLevel level) viewLevel
            , test "box on a dot, player on a dot" <|
                \_ ->
                    Expect.equal (getViewLevelFromLevel levelTestDots) viewLevelTestDots
            ]

        -- , describe "getLevelFromViewLevel"
        --     [ test "simple" <|
        --         \_ ->
        --             Expect.equal (getLevelFromViewLevel viewLevel) level
        --     , test "box on a dot, player on a dot" <|
        --         \_ ->
        --             Expect.equal (getViewLevelFromLevel levelTestDots) viewLevelTestDots
        --     ]
        ]
