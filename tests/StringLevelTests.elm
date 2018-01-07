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
        , getPathNameFromLevel
        )


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
                    Expect.equal (getStringFromLevel level) (normalize stringLevel)
            , test "is reversable" <|
                \_ ->
                    let
                        levelTemp =
                            getLevelFromString stringLevel
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
                    let
                        pathname =
                            "/4AHABDFAH5A"
                    in
                        Expect.equal (getLevelFromPathName pathname) (Just level)
            , test "empty pathname" <|
                \_ ->
                    let
                        pathname =
                            "/"
                    in
                        Expect.equal (getLevelFromPathName pathname) Nothing
            ]
        , describe "getPathNameFromLevel"
            [ test "case 1" <|
                \_ ->
                    let
                        pathname =
                            "/4AHABDFAH5A"
                    in
                        Expect.equal (getPathNameFromLevel level) pathname
            ]
        ]
