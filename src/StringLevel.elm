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
    in
        { width = getLengthOfLongestRow rows
        , height = List.length rows
        , map = List.map String.toList rows
        }


getLengthOfLongestRow : List String -> Int
getLengthOfLongestRow rows =
    rows
        |> List.map String.length
        |> List.maximum
        |> Maybe.withDefault 0


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


{-| get long format from short
-}
decodeStringLevel : String -> String
decodeStringLevel shortStringLevel =
    decode shortStringLevel


{-| get short format from long
-}
encodeStringLevel : String -> String
encodeStringLevel stringLevel =
    encode stringLevel
