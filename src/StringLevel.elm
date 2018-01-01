module StringLevel
    exposing
        ( getLevelFromString
        , getStringFromLevel
        , encodeStringLevel
        , decodeStringLevel
        )

import Types exposing (Level)
import RunLengthEncoding exposing (encode, decode, replace)


{-| supports rows separated by pipe or new line
-}
getLevelFromString : String -> Level
getLevelFromString levelString =
    let
        rows =
            levelString
                |> replace "\n" "|"
                |> String.split "|"
                |> List.filter (\row -> not (String.isEmpty row))

        firstRow =
            Maybe.withDefault "" (List.head rows)
    in
        { width = String.length firstRow
        , height = List.length rows
        , map = List.map String.toList rows
        }


{-| string format always with pipes to separate rows
-}
getStringFromLevel : Level -> String
getStringFromLevel level =
    level.map
        |> List.map joinChars
        |> String.join "|\n"


joinChars : List Char -> String
joinChars chars =
    chars
        |> List.map String.fromChar
        |> String.concat


decodeStringLevel : String -> String
decodeStringLevel shortStringLevel =
    decode shortStringLevel


encodeStringLevel : String -> String
encodeStringLevel stringLevel =
    encode stringLevel
