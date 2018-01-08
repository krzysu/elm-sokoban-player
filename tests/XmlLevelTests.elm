module XmlLevelTests exposing (..)

import Test exposing (..)
import Expect
import Types exposing (Level)
import XmlLevel exposing (getLevelFromXml)


xmlLevel : String
xmlLevel =
    """
<Level Id="soko42" Width="7" Height="9">
  <L> ######</L>
  <L> #    #</L>
  <L>## $  #</L>
  <L>#  ##$#</L>
  <L># $.#.#</L>
  <L># $...#</L>
  <L># $####</L>
  <L>#@ #</L>
  <L>####</L>
</Level>
"""


level : Level
level =
    { width = 7
    , height = 9
    , map =
        [ [ ' ', '#', '#', '#', '#', '#', '#' ]
        , [ ' ', '#', ' ', ' ', ' ', ' ', '#' ]
        , [ '#', '#', ' ', '$', ' ', ' ', '#' ]
        , [ '#', ' ', ' ', '#', '#', '$', '#' ]
        , [ '#', ' ', '$', '.', '#', '.', '#' ]
        , [ '#', ' ', '$', '.', '.', '.', '#' ]
        , [ '#', ' ', '$', '#', '#', '#', '#' ]
        , [ '#', '@', ' ', '#' ]
        , [ '#', '#', '#', '#' ]
        ]
    , id = "G6AHGA4GAH2AGD2GAHA2G2ADAHAGDFAFAHAGD3FAHAGD4AHABGAH4A"
    }


all : Test
all =
    describe "XmlLevel"
        [ describe "getLevelFromXml"
            [ test "case 1" <|
                \_ ->
                    Expect.equal (getLevelFromXml xmlLevel) level
            ]
        ]
