import Html exposing (Html, div, text, br)
import Html.App as App
--import Html.Attributes exposing (..)
--import Html.Events exposing (onClick)
-- Introducing the convention of using Store in the parent app. Provides context.
import NumericStepper
import Debug

main : Program Never
main =
  App.program
    { init = initialStore ! [] -- equivalent of (initialStore, Cmd.none)
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none -- if none, declare it straightaway
    }

-- MODEL

type alias Store =
  { stepper1 : NumericStepper.Model
  , stepper2 : NumericStepper.Model
  , stepper3 : NumericStepper.Model
  }

initialStore : Store
initialStore =
  {  stepper1 = NumericStepper.initialModel
  ,  stepper2 = NumericStepper.initialModel
  ,  stepper3 = NumericStepper.initialModel
  }

-- INTERACTIVITY

type Msg = WidgetMsg Int NumericStepper.Msg

update : Msg -> Store -> (Store, Cmd Msg)
update msg model =
  case msg of
    WidgetMsg 1 wgMsg ->
      let
        ( newModel, cmd ) = NumericStepper.update wgMsg model.stepper1
      in
        ( { model | stepper1 = newModel }, Cmd.map (WidgetMsg 1) cmd )
    WidgetMsg 2 wgMsg ->
      let
        ( newModel, cmd ) = NumericStepper.update wgMsg model.stepper2
      in
        ( { model | stepper2 = newModel }, Cmd.map (WidgetMsg 2) cmd )
    WidgetMsg 3 wgMsg ->
      let
        ( newModel, cmd ) = NumericStepper.update wgMsg model.stepper3
      in
        ( { model | stepper3 = newModel }, Cmd.map (WidgetMsg 3) cmd )
    WidgetMsg _ wgMsg ->
      model ! []

-- VIEW

view : Store -> Html Msg
view model =
  div []
    [ text "Store:"
    , br [] []
    , text (toString model)
    , App.map (WidgetMsg 1) (NumericStepper.view model.stepper1)
    , App.map (WidgetMsg 2) (NumericStepper.view model.stepper2)
    , App.map (WidgetMsg 3) (NumericStepper.view model.stepper3)
    ]
