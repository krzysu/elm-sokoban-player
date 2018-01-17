module ViewLevelTests exposing (..)

import Test exposing (..)
import Expect
import Types exposing (Block, Level, ViewLevel)
import ViewLevel exposing (getViewLevelFromLevel, getLevelFromViewLevel)
import Fixtures exposing (basicLevel1, basicViewLevel1, dotsLevel1, dotsViewLevel1)


all : Test
all =
    describe "ViewLevel"
        [ describe "getViewLevelFromLevel"
            [ test "simple" <|
                \_ ->
                    Expect.equal (getViewLevelFromLevel basicLevel1) basicViewLevel1
            , test "box on a dot, player on a dot" <|
                \_ ->
                    Expect.equal (getViewLevelFromLevel dotsLevel1) dotsViewLevel1
            ]

        -- , describe "getLevelFromViewLevel"
        --     [ test "simple" <|
        --         \_ ->
        --             Expect.equal (getLevelFromViewLevel basicViewLevel1) basicLevel1
        --     , test "box on a dot, player on a dot" <|
        --         \_ ->
        --             Expect.equal (getLevelFromViewLevel dotsViewLevel1) dotsLevel1
        --     ]
        ]
