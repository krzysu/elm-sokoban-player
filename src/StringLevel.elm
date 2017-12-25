module StringLevel exposing (getStringLevel)

import Types exposing (Level)


getStringLevel : String -> Level
getStringLevel levelString =
    let
        rows =
            levelString
                |> String.split "|"

        firstRow =
            Maybe.withDefault "" (List.head rows)
    in
        { width = String.length firstRow
        , height = List.length rows
        , map = List.map String.toList rows
        }
