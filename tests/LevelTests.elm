module LevelTests exposing (..)

import Test exposing (..)
import Expect
import Level
    exposing
        ( getViewLevelFromEncodedLevel
        , getEncodedLevelFromString
        , getEncodedLevelFromPathName
        )
import Fixtures
    exposing
        ( basicEncodedLevel1
        , basicStringLevel1
        , basicViewLevel1
        , dotsEncodedLevel1
        , dotsStringLevel1
        , dotsViewLevel1
        )


all : Test
all =
    describe "Level"
        [ describe "getViewLevelFromEncodedLevel"
            [ test "basic level" <|
                \_ ->
                    Expect.equal
                        (getViewLevelFromEncodedLevel basicEncodedLevel1)
                        basicViewLevel1
            , test "dots level" <|
                \_ ->
                    Expect.equal
                        (getViewLevelFromEncodedLevel dotsEncodedLevel1)
                        dotsViewLevel1
            ]
        , describe "getEncodedLevelFromString"
            [ test "basic level" <|
                \_ ->
                    Expect.equal
                        (getEncodedLevelFromString basicStringLevel1)
                        (Just basicEncodedLevel1)
            , test "dots level" <|
                \_ ->
                    Expect.equal
                        (getEncodedLevelFromString dotsStringLevel1)
                        (Just dotsEncodedLevel1)
            , test "wrong string" <|
                \_ ->
                    Expect.equal
                        (getEncodedLevelFromString "not a level")
                        Nothing
            ]
        , describe "getEncodedLevelFromPathName"
            [ test "basic level" <|
                \_ ->
                    Expect.equal
                        (getEncodedLevelFromPathName ("/" ++ basicEncodedLevel1))
                        (Just basicEncodedLevel1)
            , test "dots level" <|
                \_ ->
                    Expect.equal
                        (getEncodedLevelFromPathName ("/" ++ dotsEncodedLevel1))
                        (Just dotsEncodedLevel1)
            , test "wrong string" <|
                \_ ->
                    Expect.equal
                        (getEncodedLevelFromPathName "/notlEvEl")
                        Nothing
            , test "empty pathName" <|
                \_ ->
                    Expect.equal
                        (getEncodedLevelFromPathName "/")
                        Nothing
            ]
        ]
