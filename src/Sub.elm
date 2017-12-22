module Sub exposing (subscriptions)

import Keyboard
import Types exposing (Model, Msg)


subscriptions : Model -> Sub Msg
subscriptions model =
    arrowChanged


arrowChanged : Sub Msg
arrowChanged =
    Keyboard.downs toArrowChanged


toArrowChanged : Keyboard.KeyCode -> Msg
toArrowChanged code =
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

        _ ->
            Types.NoOp
