module Main exposing (..)

import Navigation exposing (Location)
import Types exposing (Model, Msg(..), Levels)
import View exposing (view)
import Update exposing (update)
import Model exposing (initModel, updateModelFromLocation)
import Sub exposing (subscriptions)
import LocalStorage exposing (decodeLevels)


type alias Flags =
    { levels : Maybe String
    }


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        -- decode flags
        levels : Maybe Levels
        levels =
            decodeLevels flags.levels

        model =
            initModel levels
    in
        ( updateModelFromLocation location model
        , Cmd.none
        )


main : Program Flags Model Msg
main =
    Navigation.programWithFlags UrlChange
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
