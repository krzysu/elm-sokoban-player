module Sub exposing (subscriptions)

import Keyboard
import Types exposing (Model, Msg)


subscriptions : Model -> Sub Msg
subscriptions model =
    arrowChanged model


arrowChanged : Model -> Sub Msg
arrowChanged model =
    Keyboard.downs (toArrowChanged model)


toArrowChanged : Model -> Keyboard.KeyCode -> Msg
toArrowChanged model code =
    case code of
        37 ->
            -- LeftKey
            Types.Move -1 0

        38 ->
            -- UpKey
            Types.Move 0 -1

        39 ->
            -- RightKey
            Types.Move 1 0

        40 ->
            -- DownKey
            Types.Move 0 1

        13 ->
            -- Enter
            if model.isWin then
                Types.LoadLevel (model.currentLevel + 1)
            else
                Types.NoOp

        _ ->
            Types.NoOp
