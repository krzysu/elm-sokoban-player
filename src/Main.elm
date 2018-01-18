module Main exposing (..)

import Navigation exposing (Location)
import Types exposing (Model, Msg(..), LevelCollection)
import View exposing (view)
import Update exposing (update)
import Model exposing (initModel, updateModelFromLocation)
import Sub exposing (subscriptions)
import Storage exposing (decodeLevels)


type alias Flags =
    { levels : Maybe String
    }


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        -- decode flags
        levels : Maybe LevelCollection
        levels =
            decodeLevels flags.levels

        model =
            initModel levels
    in
        updateModelFromLocation location model


main : Program Flags Model Msg
main =
    Navigation.programWithFlags UrlChange
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
