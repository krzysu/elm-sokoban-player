module StringLevel
    exposing
        ( getLevelFromString
        , getStringFromLevel
        , encodeStringLevel
        , decodeStringLevel
        , urlEncodeLevel
        , urlDecodeLevel
        , getLevelFromPathName
        , getLevelFromEncodedLevel
        , getEncodedLevelFromLevel
        )

import Set
import Char
import Types exposing (Level, EncodedLevel, ViewLevel)
import RunLengthEncoding exposing (encode, decode, replace)


{-| supports rows separated by pipe or new line
-}
getLevelFromString : String -> Maybe Level
getLevelFromString levelString =
    let
        rows =
            levelString
                |> replace "\n" "|"
                |> String.filter isStringLevelChar
                |> String.split "|"
                |> List.filter (\row -> not (String.isEmpty row))
                |> List.filter (\row -> String.contains "#" row)
    in
        if List.isEmpty rows then
            Nothing
        else
            Just
                { width = getLengthOfLongestRow rows
                , height = List.length rows
                , map = List.map String.toList rows
                , id =
                    String.join "|" rows
                        |> encodeStringLevel
                        |> urlEncodeLevel
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
        |> String.join "\n"


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


{-| map short format to more url friendly symbols
[name: sokobanFormatSymbol urlEncodedSymbol]
wall: # A
player: @ B
player on dot: + C
box: $ D
box on dot: * E
dot: . F
floor: _ G
pipe: | H
-}
urlEncodeLevel : String -> String
urlEncodeLevel shortString =
    shortString
        |> replace "#" "A"
        |> replace "@" "B"
        |> replace "\\+" "C"
        |> replace "\\$" "D"
        |> replace "\\*" "E"
        |> replace "\\." "F"
        |> replace "\\_" "G"
        |> replace "\\|" "H"


{-| get shortStringLevel from urlEncodedLevel
-}
urlDecodeLevel : String -> String
urlDecodeLevel urlString =
    urlString
        |> replace "A" "#"
        |> replace "B" "@"
        |> replace "C" "+"
        |> replace "D" "$"
        |> replace "E" "*"
        |> replace "F" "."
        |> replace "G" "_"
        |> replace "H" "|"


{-| get Level from Location.pathname
-}
getLevelFromPathName : String -> Maybe Level
getLevelFromPathName pathname =
    let
        urlEncodedLevel =
            pathname
                |> String.dropLeft 1
    in
        if String.isEmpty urlEncodedLevel then
            Nothing
        else
            urlEncodedLevel
                |> getLevelFromEncodedLevel


getLevelFromEncodedLevel : String -> Maybe Level
getLevelFromEncodedLevel urlEncodedLevel =
    urlEncodedLevel
        |> urlDecodeLevel
        |> String.filter isShortStringLevelChar
        |> decodeStringLevel
        |> getLevelFromString


getEncodedLevelFromLevel : Level -> EncodedLevel
getEncodedLevelFromLevel level =
    level
        |> getStringFromLevel
        |> encodeStringLevel
        |> urlEncodeLevel


isShortStringLevelChar : Char -> Bool
isShortStringLevelChar char =
    let
        allowedChars =
            [ '#', '@', '+', '$', '*', '.', '_', '|' ]

        isDigit =
            Char.isDigit char

        isAllowedChar =
            Set.member char (Set.fromList allowedChars)
    in
        isDigit || isAllowedChar


isStringLevelChar : Char -> Bool
isStringLevelChar char =
    let
        allowedChars =
            [ '#', '@', '+', '$', '*', '.', '_', '|', ' ' ]
    in
        Set.member char (Set.fromList allowedChars)
