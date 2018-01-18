module StorageTests exposing (..)

import Test exposing (..)
import Expect
import Array
import Dict
import Types exposing (LevelData, LevelDataCollection)
import Storage
    exposing
        ( encodeLevelCollection
        , decodeLevelCollection
        , encodeLevelDataCollection
        , decodeLevelDataCollection
        )


jsonEncodedLevelsData : String
jsonEncodedLevelsData =
    "{\"ABC\":{\"bestMovesCount\":10},\"BCD\":{\"bestMovesCount\":20}}"


levelsData : LevelDataCollection
levelsData =
    Dict.fromList
        [ ( "ABC", getLevelData 10 )
        , ( "BCD", getLevelData 20 )
        ]


getLevelData : Int -> LevelData
getLevelData number =
    { bestMovesCount = number }


all : Test
all =
    describe "Storage"
        [ describe "encodeLevelCollection"
            [ test "case 1" <|
                \_ ->
                    Expect.equal
                        (encodeLevelCollection (Array.fromList [ "ABC", "BCD" ]))
                        "[\"ABC\",\"BCD\"]"
            ]
        , describe "decodeLevelCollection"
            [ test "case 1" <|
                \_ ->
                    Expect.equal
                        (decodeLevelCollection (Just "[\"5AHABDFAH5A\",\"4AHABDFAH5A\"]"))
                        (Just (Array.fromList [ "5AHABDFAH5A", "4AHABDFAH5A" ]))
            , test "nothing" <|
                \_ ->
                    Expect.equal
                        (decodeLevelCollection Nothing)
                        Nothing
            ]
        , describe "encodeLevelDataCollection"
            [ test "case 1" <|
                \_ ->
                    Expect.equal
                        (encodeLevelDataCollection levelsData)
                        jsonEncodedLevelsData
            ]
        , describe "decodeLevelDataCollection"
            [ test "case 1" <|
                \_ ->
                    Expect.equal
                        (decodeLevelDataCollection (Just jsonEncodedLevelsData))
                        levelsData
            , test "nothing" <|
                \_ ->
                    Expect.equal
                        (decodeLevelDataCollection Nothing)
                        Dict.empty
            ]
        ]
