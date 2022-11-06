module Dialog exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Attributes.Aria exposing (role, ariaDescribedby, ariaLabelledby)
import Random.String as RString
import Random.Char as RChar

fiveLetterEnglishWord =
    RString.string 5 RChar.english

type DialogState
    = DialogIsOpen
    | DialogIsClosed


type alias DialogComp =
    { dialog_state : DialogState
    , random_str : String 
    }

init : String -> DialogComp 
init random_str = { random_str=random_str, dialog_state=DialogIsClosed }

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

aria_description_for_title random_str = "dialog-component-title-" ++ random_str
aria_label_for_id random_str = "aria-label-for-id-" ++ random_str

title_component_wrapper : DialogComp -> String -> List (Html.Attribute msg) -> List (Html msg) -> Html msg 
title_component_wrapper comp as_node attributes children = 
    Html.node as_node (List.append attributes [ comp.random_str |> aria_description_for_title |> id 
        ]) 
         children 
        


body_component_wrapper : DialogComp -> String -> List (Html.Attribute msg) -> List (Html msg) -> Html msg 
body_component_wrapper comp as_node attributes children = 
    Html.node as_node (List.append attributes [ comp.random_str |> aria_label_for_id |> id 
        ]) 
         children
        

view : DialogComp -> List (Html.Attribute msg) -> Html msg -> Html msg
view dialog_comp root_div_attributes children = 
    case dialog_comp.dialog_state of
        DialogIsOpen ->
            let 
                combined_attributes = 
                    List.append 
                        root_div_attributes 
                        [ role "dialog"
                        , ariaDescribedby <| aria_description_for_title <| dialog_comp.random_str
                        , ariaLabelledby <| aria_label_for_id <| dialog_comp.random_str
                        ]
            in
            div combined_attributes  
                [ children  
                ]
        DialogIsClosed ->
            text ""
