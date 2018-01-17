port module LocalStorage exposing (storeLevels, decodeLevels)

import Json.Encode
import Json.Decode
import Array exposing (Array)
import Types exposing (LevelCollection)
import StringLevel exposing (getLevelFromEncodedLevel, getEncodedLevelFromLevel)


port portStoreLevels : String -> Cmd msg


{-| decode json encoded levels from Flags to elm type
-}
decodeLevels : Maybe String -> Maybe LevelCollection
decodeLevels encodedLevels =
    let
        result =
            Json.Decode.decodeString
                (Json.Decode.array Json.Decode.string)
                (Maybe.withDefault "" encodedLevels)
    in
        case result of
            Ok result ->
                result
                    |> Array.toList
                    |> List.filterMap getLevelFromEncodedLevel
                    |> List.map getEncodedLevelFromLevel
                    |> Array.fromList
                    |> Just

            Err _ ->
                Nothing


{-| decode and send to port
-}
storeLevels : LevelCollection -> Cmd msg
storeLevels levels =
    levels
        |> Array.map Json.Encode.string
        |> Json.Encode.array
        |> Json.Encode.encode 0
        |> portStoreLevels
