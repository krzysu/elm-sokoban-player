port module LocalStorage exposing (storeLevels, decodeLevels)

import Json.Encode exposing (Value, encode, object, string)
import Json.Decode
import Dict exposing (Dict)
import Types exposing (Level, Levels)
import StringLevel exposing (getLevelFromUrlEncodedLevel)


port portStoreLevels : String -> Cmd msg


{-| decode json encoded levels from Flags to elm type
-}
decodeLevels : Maybe String -> Maybe Levels
decodeLevels encodedLevels =
    let
        result =
            Json.Decode.decodeString
                (Json.Decode.keyValuePairs Json.Decode.string)
                (Maybe.withDefault "" encodedLevels)
    in
        case result of
            Ok result ->
                result
                    |> List.map Tuple.first
                    |> List.filterMap getLevelFromUrlEncodedLevel
                    |> List.map (\level -> ( level.id, level ))
                    |> Dict.fromList
                    |> Just

            Err _ ->
                Nothing


{-| decode and send to port
-}
storeLevels : Levels -> Cmd msg
storeLevels levels =
    let
        levelsObject =
            levels
                |> dictToObject identity levelToObject
    in
        portStoreLevels (encode 0 levelsObject)


levelToObject : Level -> Value
levelToObject level =
    string ""


dictToObject : (comparable -> String) -> (v -> Value) -> Dict comparable v -> Value
dictToObject toKey toValue dict =
    Dict.toList dict
        |> List.map (\( key, value ) -> ( toKey key, toValue value ))
        |> object
