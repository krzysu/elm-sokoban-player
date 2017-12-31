module StringLevel exposing (getStringLevel)

import Types exposing (Level)
import RunLengthEncoding exposing (encode, decode, replace)


getStringLevel : String -> Level
getStringLevel levelString =
    let
        rows =
            levelString
                |> replace "\n" ""
                |> String.split "|"
                |> List.filter (\row -> not (String.isEmpty row))

        firstRow =
            Maybe.withDefault "" (List.head rows)
    in
        { width = String.length firstRow
        , height = List.length rows
        , map = List.map String.toList rows
        }
