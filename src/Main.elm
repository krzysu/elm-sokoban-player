module Main exposing (..)

import Html
import Types exposing (Model, Msg, Block, Level)
import View exposing (view)
import Update exposing (update)
import Model exposing (initModel)
import Sub exposing (subscriptions)
import XmlLevel exposing (getXmlLevel)


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


init : ( Model, Cmd Msg )
init =
    ( initModel (getXmlLevel xmlLevel)
    , Cmd.none
    )


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
