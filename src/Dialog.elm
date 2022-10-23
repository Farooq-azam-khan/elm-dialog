module Dialog exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type DialogState
    = DialogIsOpen
    | DialogIsClosed


type alias DialogComp msg =
    { title : Html msg
    , dialog_state : DialogState
    , dialog_panel : Html msg
    }


aria_modal : DialogState -> Attribute msg
aria_modal isDialogOpen =
    let
        aria_modal_tag =
            attribute "aria-modal"
    in
    case isDialogOpen of
        DialogIsOpen ->
            aria_modal_tag "true"

        DialogIsClosed ->
            aria_modal_tag "false"


view : DialogComp msg -> Html msg
view dialog_comp =
    case dialog_comp.dialog_state of
        DialogIsOpen ->
            dialog_comp.dialog_panel

        DialogIsClosed ->
            text ""
