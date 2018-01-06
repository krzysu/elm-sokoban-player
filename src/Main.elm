module Main exposing (..)

import Html
import Types exposing (Model, Msg, Block, Level)
import View exposing (view)
import Update exposing (update)
import Model exposing (initModel)
import Sub exposing (subscriptions)


init : ( Model, Cmd Msg )
init =
    ( initModel
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
