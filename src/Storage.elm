port module Storage
    exposing
        ( storeLevels
        , storeLevelsData
        , decodeLevelCollection
        , encodeLevelCollection
        , encodeLevelDataCollection
        , decodeLevelDataCollection
        )

import Json.Encode exposing (Value)
import Json.Decode exposing (Decoder)
import Dict exposing (Dict)
import Array exposing (Array)
import Types exposing (LevelCollection, LevelData, LevelDataCollection)
import StringLevel exposing (getLevelFromEncodedLevel, getEncodedLevelFromLevel)


port portStoreLevels : String -> Cmd msg


port portStoreData : String -> Cmd msg


{-| decode json encoded levels from Flags to elm type
-}
decodeLevelCollection : Maybe String -> Maybe LevelCollection
decodeLevelCollection string =
    let
        result =
            string
                |> Maybe.withDefault ""
                |> Json.Decode.decodeString (Json.Decode.list Json.Decode.string)
    in
        case result of
            Ok result ->
                result
                    -- transform both ways to validate
                    |> List.filterMap getLevelFromEncodedLevel
                    |> List.map getEncodedLevelFromLevel
                    |> Array.fromList
                    |> Just

            Err _ ->
                Nothing


decodeLevelDataCollection : Maybe String -> LevelDataCollection
decodeLevelDataCollection string =
    let
        result =
            string
                |> Maybe.withDefault ""
                |> Json.Decode.decodeString levelsDataDecoder
    in
        case result of
            Ok result ->
                result

            Err _ ->
                Dict.empty


levelsDataDecoder : Decoder (Dict String LevelData)
levelsDataDecoder =
    Json.Decode.dict
        (Json.Decode.map
            (\int -> LevelData int)
            (Json.Decode.field "bestMovesCount" Json.Decode.int)
        )


{-| encode and send to port
-}
storeLevels : LevelCollection -> Cmd msg
storeLevels levels =
    levels
        |> encodeLevelCollection
        |> portStoreLevels


encodeLevelCollection : LevelCollection -> String
encodeLevelCollection levels =
    levels
        |> Array.map Json.Encode.string
        |> Json.Encode.array
        |> Json.Encode.encode 0


{-| encode and send to port
-}
storeLevelsData : LevelDataCollection -> Cmd msg
storeLevelsData levelsData =
    levelsData
        |> encodeLevelDataCollection
        |> portStoreData


encodeLevelDataCollection : LevelDataCollection -> String
encodeLevelDataCollection levelsData =
    levelsData
        |> dictToObject identity levelDataToObject
        |> Json.Encode.encode 0


dictToObject : (comparable -> String) -> (v -> Value) -> Dict comparable v -> Value
dictToObject toKey toValue dict =
    Dict.toList dict
        |> List.map (\( key, value ) -> ( toKey key, toValue value ))
        |> Json.Encode.object


levelDataToObject : LevelData -> Value
levelDataToObject levelData =
    Json.Encode.object
        [ ( "bestMovesCount", Json.Encode.int levelData.bestMovesCount )
        ]
