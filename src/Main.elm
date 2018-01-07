module Main exposing (..)

import Navigation exposing (Location)
import Types exposing (Model, Msg(..))
import View exposing (view)
import Update exposing (update)
import Model exposing (initModel, updateModelFromLocation)
import Sub exposing (subscriptions)


init : Location -> ( Model, Cmd Msg )
init location =
    let
        model =
            initModel
    in
        ( updateModelFromLocation location model
        , Cmd.none
        )


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
