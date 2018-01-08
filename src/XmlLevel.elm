module XmlLevel exposing (getLevelFromXml)

import Dict
import Xml exposing (Value)
import Xml.Encode exposing (null)
import Xml.Decode exposing (decode)
import Xml.Query exposing (tags, tag, collect)
import Types exposing (Level)
import StringLevel exposing (encodeStringLevel, urlEncodeLevel)


getLevelFromXml : String -> Level
getLevelFromXml xmlString =
    let
        decodedXmlString =
            decodeXmlString xmlString

        levelMap =
            getLevelMap decodedXmlString

        levelSize =
            getLevelSize decodedXmlString

        levelString =
            getLevelString decodedXmlString
    in
        { width = Tuple.first (levelSize)
        , height = Tuple.second (levelSize)
        , map = levelMap
        , id =
            levelString
                |> encodeStringLevel
                |> urlEncodeLevel
        }


decodeXmlString : String -> Value
decodeXmlString xmlString =
    xmlString
        |> decode
        |> Result.toMaybe
        |> Maybe.withDefault null


getLevelString : Value -> String
getLevelString decodedXmlString =
    tags "L" decodedXmlString
        |> collect (tag "L" Xml.Query.string)
        |> String.join "|"


getLevelMap : Value -> List (List Char)
getLevelMap decodedXmlString =
    tags "L" decodedXmlString
        |> collect (tag "L" Xml.Query.string)
        |> List.map String.toList


getLevelSize : Value -> ( Int, Int )
getLevelSize decodedXmlString =
    case List.head (tags "Level" decodedXmlString) of
        Just (Xml.Tag _ attrs _) ->
            ( getIntAttr attrs "Width", getIntAttr attrs "Height" )

        _ ->
            ( 0, 0 )


getIntAttr : Dict.Dict String Value -> String -> Int
getIntAttr attrs attrName =
    Dict.get attrName attrs
        |> Maybe.map valueToString
        |> Maybe.withDefault 0


valueToString : Value -> Int
valueToString value =
    case value of
        Xml.IntNode a ->
            a

        _ ->
            0
