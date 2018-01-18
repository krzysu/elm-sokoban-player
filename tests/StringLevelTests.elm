module StringLevelTests exposing (..)

import Test exposing (..)
import Expect
import Types exposing (Level)
import StringLevel
    exposing
        ( getLevelFromString
        , getStringFromLevel
        , urlEncodeLevel
        , urlDecodeLevel
        , getLevelFromPathName
        , getEncodedLevelFromLevel
        )
import Fixtures exposing (dotsLevel1, dotsStringLevel1, dotsEncodedLevel1)


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
    , id = "4AHABDFAH5A"
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
                    Expect.equal (getLevelFromString stringLevel) (Just level)
            , test "case 2" <|
                \_ ->
                    Expect.equal (getLevelFromString stringLevelWithPipes) (Just level)
            , test "case 3" <|
                \_ ->
                    Expect.equal (getLevelFromString dotsStringLevel1) (Just dotsLevel1)
            , test "is reversable" <|
                \_ ->
                    let
                        stringLevelTemp =
                            getStringFromLevel level
                    in
                        Expect.equal (getLevelFromString stringLevelTemp) (Just level)
            , test "not level string" <|
                \_ ->
                    Expect.equal (getLevelFromString "notALevEl@$+") Nothing
            ]
        , describe "getStringFromLevel"
            [ test "case 1" <|
                \_ ->
                    Expect.equal (getStringFromLevel level) (normalize stringLevel)
            , test "is reversable" <|
                \_ ->
                    let
                        levelTemp =
                            getLevelFromString stringLevel
                                |> Maybe.withDefault (Level 0 0 [] "")
                    in
                        Expect.equal (getStringFromLevel levelTemp) (normalize stringLevel)
            ]
        , describe "urlEncodeLevel"
            [ test "case 1" <|
                \_ ->
                    let
                        shortStringLevelTestDots =
                            "5#_|#_$+$.#|#4_*#|_5#"

                        urlEncodedLevel =
                            "5AGHAGDCDFAHA4GEAHG5A"
                    in
                        Expect.equal (urlEncodeLevel shortStringLevelTestDots) urlEncodedLevel
            , test "case 2" <|
                \_ ->
                    let
                        shortStringLevel =
                            "4#|#@$.#|5#"

                        urlEncodedLevel =
                            "4AHABDFAH5A"
                    in
                        Expect.equal (urlEncodeLevel shortStringLevel) urlEncodedLevel
            , test "is reversible" <|
                \_ ->
                    let
                        string =
                            "4#|#@$.#|5#"
                    in
                        Expect.equal (urlDecodeLevel (urlEncodeLevel string)) string
            ]
        , describe "urlDecodeLevel"
            [ test "case 1" <|
                \_ ->
                    let
                        shortStringLevelTestDots =
                            "5#_|#_$+$.#|#4_*#|_5#"

                        urlEncodedLevel =
                            "5AGHAGDCDFAHA4GEAHG5A"
                    in
                        Expect.equal (urlDecodeLevel urlEncodedLevel) shortStringLevelTestDots
            , test "case 2" <|
                \_ ->
                    let
                        shortStringLevel =
                            "4#|#@$.#|5#"

                        urlEncodedLevel =
                            "4AHABDFAH5A"
                    in
                        Expect.equal (urlDecodeLevel urlEncodedLevel) shortStringLevel
            , test "is reversible" <|
                \_ ->
                    let
                        string =
                            "4AHABDFAH5A"
                    in
                        Expect.equal (urlEncodeLevel (urlDecodeLevel string)) string
            ]
        , describe "getLevelFromPathName"
            [ test "case 1" <|
                \_ ->
                    Expect.equal (getLevelFromPathName "/4AHABDFAH5A") (Just level)
            , test "empty pathname" <|
                \_ ->
                    Expect.equal (getLevelFromPathName "/") Nothing
            , test "wrong pathname" <|
                \_ ->
                    Expect.equal (getLevelFromPathName "/notLevEl") Nothing
            ]
        , describe "getEncodedLevelFromLevel"
            [ test "case 1" <|
                \_ ->
                    Expect.equal (getEncodedLevelFromLevel dotsLevel1) dotsEncodedLevel1
            ]
        ]
