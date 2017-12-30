module RunLengthEncoding exposing (encode, decode)

import String exposing (fromChar)
import List exposing (head, tail)
import Maybe exposing (withDefault)
import Regex


{- based on https://github.com/exercism/elm/blob/master/exercises/run-length-encoding/RunLengthEncoding.example.elm -}


encode : String -> String
encode string =
    replace "\n" "|" string
        |> replace " " "-"
        |> String.toList
        |> List.foldr countChars []
        |> List.map stringifyCounts
        |> String.join ""


countChars : a -> List ( number, a ) -> List ( number, a )
countChars current counted =
    case head counted of
        Just ( count, previous ) ->
            if previous == current then
                ( count + 1, current ) :: withDefault [] (tail counted)
            else
                ( 1, current ) :: counted

        Nothing ->
            [ ( 1, current ) ]


stringifyCounts : ( comparable, Char ) -> String
stringifyCounts ( count, char ) =
    if count > 1 then
        toString count ++ fromChar char
    else
        fromChar char


decode : String -> String
decode string =
    String.trim string
        |> Regex.find Regex.All (Regex.regex "(\\d+)|(\\D)")
        |> List.map .match
        |> List.foldl expandCounts ( "", Nothing )
        |> Tuple.first
        |> replace "-" " "
        |> replace "\\|" "\n"


expandCounts : String -> ( String, Maybe Int ) -> ( String, Maybe Int )
expandCounts match ( result, count ) =
    case count of
        Just number ->
            ( result ++ String.repeat number match, Nothing )

        Nothing ->
            case String.toInt match of
                Ok number ->
                    ( result, Just number )

                Err _ ->
                    ( result ++ match, Nothing )


replace : String -> String -> String -> String
replace charToFind newChar =
    Regex.replace Regex.All (Regex.regex charToFind) (\_ -> newChar)
