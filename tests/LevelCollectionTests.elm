module LevelCollectionTests exposing (..)

import Test exposing (..)
import Expect
import Array
import Types exposing (Level, LevelCollection)
import LevelCollection
    exposing
        ( getLevel
        , appendLevel
        , prependLevel
        , removeLevel
        , isDuplicate
        , getIndexOf
        )


initialLevels : LevelCollection
initialLevels =
    Array.fromList [ "ABC", "BCD", "CDE" ]


all : Test
all =
    describe "LevelCollection"
        [ describe "getLevel"
            [ test "case 1" <|
                \_ ->
                    Expect.equal (getLevel 2 initialLevels) "CDE"
            ]
        , describe "appendLevel"
            [ test "case 1" <|
                \_ ->
                    Expect.equal
                        (appendLevel "DEF" initialLevels)
                        (Array.fromList
                            [ "ABC", "BCD", "CDE", "DEF" ]
                        )
            , test "handles duplicates" <|
                \_ ->
                    Expect.equal
                        (appendLevel "BCD" initialLevels)
                        (Array.fromList
                            [ "ABC", "BCD", "CDE" ]
                        )
            ]
        , describe "prependLevel"
            [ test "case 1" <|
                \_ ->
                    Expect.equal
                        (prependLevel "DEF" initialLevels)
                        (Array.fromList
                            [ "DEF", "ABC", "BCD", "CDE" ]
                        )
            , test "handles duplicates" <|
                \_ ->
                    Expect.equal
                        (prependLevel "BCD" initialLevels)
                        (Array.fromList
                            [ "ABC", "BCD", "CDE" ]
                        )
            ]
        , describe "removeLevel"
            [ test "case 1" <|
                \_ ->
                    Expect.equal
                        (removeLevel "BCD" initialLevels)
                        (Array.fromList
                            [ "ABC", "CDE" ]
                        )
            ]
        , describe "isDuplicate"
            [ test "true" <|
                \_ ->
                    Expect.equal
                        (isDuplicate "BCD" initialLevels)
                        True
            , test "false" <|
                \_ ->
                    Expect.equal
                        (isDuplicate "XYZ" initialLevels)
                        False
            ]
        , describe "getIndexOf"
            [ test "true" <|
                \_ ->
                    Expect.equal
                        (getIndexOf "BCD" initialLevels)
                        1
            , test "false" <|
                \_ ->
                    Expect.equal
                        (getIndexOf "XYZ" initialLevels)
                        -1
            ]
        ]
