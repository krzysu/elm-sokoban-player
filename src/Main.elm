module Main exposing (..)

import Navigation exposing (Location)
import Types exposing (Model, Msg(..), Flags, LevelCollection, LevelDataCollection)
import View exposing (view)
import Update exposing (update)
import Model
import Sub exposing (subscriptions)
import Storage exposing (decodeLevelCollection, decodeLevelDataCollection)
import Router


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        -- decode flags
        levels : Maybe LevelCollection
        levels =
            decodeLevelCollection flags.levels

        levelsData : LevelDataCollection
        levelsData =
            decodeLevelDataCollection flags.levelsData

        modelWithCmd =
            Model.initModel flags levels levelsData
    in
        Router.match location modelWithCmd


main : Program Flags Model Msg
main =
    Navigation.programWithFlags UrlChange
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
