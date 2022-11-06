module Main exposing (main)

import Browser
import Dialog exposing (DialogState(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Random.String as RString
import Random.Char as RChar
import Random 
fiveLetterEnglishWord =
    RString.string 5 RChar.english


type alias Model =
    { first_dialog_comp : Maybe Dialog.DialogComp, second_dialog_comp: Maybe Dialog.DialogComp } 

type Msg
    = ToggleDialogMenu | RandomString String | RandomString2 String | ToggleDialogMenu2 


backdrop : Html Msg
backdrop =
    button [class "fixed inset-0 w-full bg-orange-200 bg-opacity-25", tabindex -1, onClick ToggleDialogMenu] [ ]

render__modal : Maybe Dialog.DialogComp -> Msg -> Html Msg 
render__modal modal close_msg =  
    case modal of 
        Just dialog_comp -> 
                    Dialog.view 
                        dialog_comp 
                        [ class "realative z-10"  ]
                        (div [ class "fixed inset-0 overflow-y-auto" ]
                                [ backdrop
                                , div [ class "flex min-h-full items-center justify-center p-4 text-center" ]
                                    [ div [ class "w-full max-w-md transform overflow-hidden rounded-2xl bg-white p-6 text-left align-middle shadow-xl transition-all" ]
                                        [ Dialog.title_component_wrapper dialog_comp "h3" [ class "text-lg font-medium leading-6 text-gray-900" ] [ text "Payment successful" ]
                                        , Dialog.body_component_wrapper dialog_comp "div" [] [p [ class "text-sm text-gray-500" ] [ text "Your payment has been successfully submitted. We've sent you an email with all of the details of your order." ]
                                        , button
                                            [ type_ "button"
                                            , tabindex 0
                                            , class "inline-flex justify-center rounded-md border border-transparent bg-blue-100 px-4 py-2 text-sm font-medium text-blue-900 hover:bg-blue-200 focus:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 focus-visible:ring-offset-2"
                                            , onClick close_msg -- ToggleDialogMenu
                                            ]
                                            [ text "Got it, thanks!" ]
                                        ]
                                        ]
                                    ]
                                ]
                        )
        Nothing -> text ""
                            


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
        , render__modal model.first_dialog_comp ToggleDialogMenu

        , button
            [ type_ "button"
            , onClick ToggleDialogMenu2
            , class "rounded-md bg-black bg-opacity-20 px-4 py-2 text-sm font-medium text-white hover:bg-opacity-30 focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75"
            ]
            [ text "Open dialog 2"
            ]
        , render__modal model.second_dialog_comp ToggleDialogMenu2

        ]
        


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of

        ToggleDialogMenu ->
            let
                maybe_first_modal_dialog = model.first_dialog_comp 
                updated_modal_dialog = case maybe_first_modal_dialog of 
                                            Just dialog -> 
                                                case dialog.dialog_state  of
                                                    DialogIsClosed ->
                                                        Just { dialog | dialog_state = DialogIsOpen}

                                                    DialogIsOpen ->
                                                        Just { dialog | dialog_state = DialogIsClosed}
                                            Nothing -> Nothing  
                                                
            in
            ({ model | first_dialog_comp = updated_modal_dialog }, Cmd.none)

        ToggleDialogMenu2 ->
            let
                maybe_second_modal_dialog = model.second_dialog_comp
                updated_modal_dialog = case maybe_second_modal_dialog of 
                                            Just dialog -> 
                                                case dialog.dialog_state  of
                                                    DialogIsClosed ->
                                                        Just { dialog | dialog_state = DialogIsOpen}

                                                    DialogIsOpen ->
                                                        Just { dialog | dialog_state = DialogIsClosed}
                                            Nothing -> Nothing  
                                                
            in
            ({ model | second_dialog_comp = updated_modal_dialog }, Cmd.none)
           
        RandomString rand_str -> ({model | first_dialog_comp = Just (Dialog.init rand_str) }, Cmd.none)
        RandomString2 rand_str -> ({model | second_dialog_comp = Just (Dialog.init rand_str) }, Cmd.none)


init : flags -> (Model, Cmd Msg)
init _ =
    ({ first_dialog_comp = Nothing, second_dialog_comp = Nothing }, Cmd.batch [Random.generate RandomString fiveLetterEnglishWord, Random.generate RandomString2 fiveLetterEnglishWord]) 


main : Program () Model Msg
main =
    Browser.element 
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
