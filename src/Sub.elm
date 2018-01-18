module Sub exposing (subscriptions)

import Keyboard
import Types exposing (Model, Msg(..), Page(..))


subscriptions : Model -> Sub Msg
subscriptions model =
    Keyboard.downs (keyPressed model)


keyPressed : Model -> Keyboard.KeyCode -> Msg
keyPressed model code =
    if model.currentPage == GamePage then
        case code of
            37 ->
                -- LeftKey
                Move -1 0

            38 ->
                -- UpKey
                Move 0 -1

            39 ->
                -- RightKey
                Move 1 0

            40 ->
                -- DownKey
                Move 0 1

            13 ->
                -- Enter
                if model.isWin then
                    LoadNextLevel
                else
                    NoOp

            27 ->
                -- Esc
                RestartLevel

            85 ->
                -- u
                Undo

            _ ->
                NoOp
    else
        NoOp
