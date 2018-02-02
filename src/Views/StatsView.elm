module Views.StatsView exposing (stats, bestMovesCount)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Array
import Dict
import Types exposing (Model, Msg, LevelData)


stats : Model -> Html Msg
stats model =
    let
        stats =
            [ levelCount model
            , "moves: " ++ (toString model.movesCount)
            , bestMovesCount (Dict.get model.currentEncodedLevel model.levelsData)
            ]
    in
        div [ class "text" ]
            [ Html.text (String.join " | " stats)
            ]


levelCount : Model -> String
levelCount model =
    let
        levelsCount =
            toString (Array.length model.levels)

        currentLevel =
            toString (model.currentLevelIndex + 1)
    in
        "level " ++ currentLevel ++ "/" ++ levelsCount


bestMovesCount : Maybe LevelData -> String
bestMovesCount levelData =
    let
        bestMovesCount =
            levelData
                |> Maybe.map .bestMovesCount
                |> Maybe.withDefault 0
                |> toString
    in
        "best score: " ++ bestMovesCount
