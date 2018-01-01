module StringLevelTests exposing (..)

import Test exposing (..)
import Expect
import Types exposing (Level)
import StringLevel exposing (getLevelFromString, getStringFromLevel)


stringLevel : String
stringLevel =
    """
####
#@$.#
#####
"""


stringLevelWithPipes : String
stringLevelWithPipes =
    """
####|
#@$.#|
#####
"""


level : Level
level =
    { width = 5
    , height = 3
    , map =
        [ [ '#', '#', '#', '#' ]
        , [ '#', '@', '$', '.', '#' ]
        , [ '#', '#', '#', '#', '#' ]
        ]
    }


{-| removes chars which are ignored anyway
just to normalize test results
-}
normalize : String -> String
normalize string =
    String.trim string


all : Test
all =
    describe "StringLevel"
        [ describe "getLevelFromString"
            [ test "case 1" <|
                \_ ->
                    Expect.equal (getLevelFromString stringLevel) level
            , test "case 2" <|
                \_ ->
                    Expect.equal (getLevelFromString stringLevelWithPipes) level
            , test "is reversable" <|
                \_ ->
                    let
                        stringLevelTemp =
                            getStringFromLevel level
                    in
                        Expect.equal (getLevelFromString stringLevelTemp) level
            ]
        , describe "getStringFromLevel"
            [ test "case 1" <|
                \_ ->
                    Expect.equal (getStringFromLevel level) (normalize stringLevelWithPipes)
            , test "is reversable" <|
                \_ ->
                    let
                        levelTemp =
                            getLevelFromString stringLevel
                    in
                        Expect.equal (getStringFromLevel levelTemp) (normalize stringLevelWithPipes)
            ]
        ]
