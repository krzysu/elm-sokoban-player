module LevelTests exposing (..)

import Test exposing (..)
import Expect
import Level
    exposing
        ( getViewLevelFromEncodedLevel
        , getEncodedLevelFromString
        , getEncodedLevelFromPathName
        , getGameBlockSize
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


getBlockSizeForFixedGameSize : { width : Int, height : Int } -> Int
getBlockSizeForFixedGameSize windowSize =
    getGameBlockSize windowSize ( 14, 10 ) 60


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
        , describe "getGameBlockSize"
            [ test "my laptop" <|
                \_ ->
                    Expect.equal
                        (getBlockSizeForFixedGameSize { width = 1853, height = 962 })
                        60
            , test "ipad portrait" <|
                \_ ->
                    Expect.equal
                        (getBlockSizeForFixedGameSize { width = 768, height = 1024 })
                        49
            , test "ipad landscape" <|
                \_ ->
                    Expect.equal
                        (getBlockSizeForFixedGameSize { width = 1024, height = 768 })
                        60
            , test "some smartphone" <|
                \_ ->
                    Expect.equal
                        (getBlockSizeForFixedGameSize { width = 360, height = 640 })
                        23
            ]
        ]
