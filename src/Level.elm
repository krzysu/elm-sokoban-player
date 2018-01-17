module Level
    exposing
        ( getViewLevelFromEncodedLevel
        , getEncodedLevelFromString
        , getEncodedLevelFromPathName
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
