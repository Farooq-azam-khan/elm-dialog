module Main exposing (main)

import Browser
import Dialog exposing (DialogState(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

type alias Model =
    { first_dialog_comp : Dialog.DialogComp  }

type Msg
    = ToggleDialogMenu


backdrop : Html Msg
backdrop =
    button [class "fixed inset-0 w-full bg-orange-200 bg-opacity-25", tabindex -1, onClick ToggleDialogMenu] [ ]

    
view : Model -> Html Msg
view model =   
    div [ class "fixed inset-0 flex items-center justify-center" ]
        [ button
            [ type_ "button"
            , onClick ToggleDialogMenu
            , class "rounded-md bg-black bg-opacity-20 px-4 py-2 text-sm font-medium text-white hover:bg-opacity-30 focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75"
            ]
            [ text "Open dialog"
            ]
        , Dialog.view 
                model.first_dialog_comp 
                [ class "realative z-10"  ]
                (div [ class "fixed inset-0 overflow-y-auto" ]
                        [ backdrop
                        , div [ class "flex min-h-full items-center justify-center p-4 text-center" ]
                            [ div [ class "w-full max-w-md transform overflow-hidden rounded-2xl bg-white p-6 text-left align-middle shadow-xl transition-all" ]
                                [ Dialog.title_component_wrapper model.first_dialog_comp "h3" [ class "text-lg font-medium leading-6 text-gray-900" ] [ text "Payment successful" ]
                                , Dialog.body_component_wrapper model.first_dialog_comp "div" [] [p [ class "text-sm text-gray-500" ] [ text "Your payment has been successfully submitted. We've sent you an email with all of the details of your order." ]
                                , button
                                    [ type_ "button"
                                    , tabindex 0
                                    , class "inline-flex justify-center rounded-md border border-transparent bg-blue-100 px-4 py-2 text-sm font-medium text-blue-900 hover:bg-blue-200 focus:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 focus-visible:ring-offset-2"
                                    , onClick ToggleDialogMenu
                                    ]
                                    [ text "Got it, thanks!" ]
                                ]
                                ]
                            ]
                        ]
                )
                    
        ]
        


update : Msg -> Model -> Model
update msg model =
    case msg of

        ToggleDialogMenu ->
            let
                first_modal_dialog = model.first_dialog_comp 
                updated_modal_dialog = case first_modal_dialog.dialog_state  of
                                            DialogIsClosed ->
                                                {first_modal_dialog | dialog_state = DialogIsOpen}

                                            DialogIsOpen ->
                                                {first_modal_dialog | dialog_state = DialogIsClosed}
                                                
            in
            { model | first_dialog_comp = updated_modal_dialog }


init : Model
init =
    { first_dialog_comp =  Dialog.init "random-str-for-unique-modal" }
    


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
