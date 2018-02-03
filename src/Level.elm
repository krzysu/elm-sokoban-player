module Level
    exposing
        ( getViewLevelFromEncodedLevel
        , getEncodedLevelFromString
        , getEncodedLevelFromPathName
        , getGameBlockSize
        )

import Types exposing (EncodedLevel, Level, ViewLevel)
import ViewLevel exposing (getViewLevelFromLevel)
import StringLevel
    exposing
        ( getLevelFromString
        , getLevelFromEncodedLevel
        , getLevelFromPathName
        , getStringFromLevel
        , encodeStringLevel
        , urlEncodeLevel
        )
import Window


getViewLevelFromEncodedLevel : EncodedLevel -> ViewLevel
getViewLevelFromEncodedLevel encodedLevel =
    encodedLevel
        |> getLevelFromEncodedLevel
        -- we trust that EncodedLevel is always correct
        |> Maybe.withDefault (Level 0 0 [] "")
        |> getViewLevelFromLevel


getEncodedLevelFromString : String -> Maybe EncodedLevel
getEncodedLevelFromString string =
    string
        |> getLevelFromString
        |> Maybe.map .id


getEncodedLevelFromPathName : String -> Maybe EncodedLevel
getEncodedLevelFromPathName pathName =
    let
        maybeLevel =
            pathName
                |> getLevelFromPathName
    in
        case maybeLevel of
            Just maybeLevel ->
                maybeLevel
                    |> getStringFromLevel
                    |> encodeStringLevel
                    |> urlEncodeLevel
                    |> Just

            Nothing ->
                Nothing


type alias Config =
    { minBlockSize : Float
    }


config : Config
config =
    { minBlockSize = 10
    }


getGameBlockSize : Window.Size -> ( Int, Int ) -> Float -> Int
getGameBlockSize windowSize ( gameWidth, gameHeight ) maxBlockSize =
    let
        horizontalSize =
            0.9 * (toFloat windowSize.width) / (toFloat gameWidth)

        verticalSize =
            0.9 * (toFloat windowSize.height) / (toFloat gameHeight)

        possibleSize =
            if horizontalSize > verticalSize then
                verticalSize
            else
                horizontalSize
    in
        if possibleSize > maxBlockSize then
            round maxBlockSize
        else if possibleSize < config.minBlockSize then
            round config.minBlockSize
        else
            round possibleSize
