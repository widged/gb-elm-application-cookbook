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
  { stepper : NumericStepper.Model
  }

initialStore : Store
initialStore =
  {  stepper = NumericStepper.initialModel
  }

-- INTERACTIVITY

type Msg = NumericStepperMsg NumericStepper.Msg

update : Msg -> Store -> (Store, Cmd Msg)
update msg model =
  case msg of
    NumericStepperMsg wgMsg ->
      let
        ( stepperModel, stepperCmd ) = NumericStepper.update wgMsg model.stepper
      in
        { model | stepper = stepperModel } ! [Cmd.map NumericStepperMsg stepperCmd]

-- VIEW

view : Store -> Html Msg
view model =
  div []
    [ text "Store:"
    , br [] []
    , text (toString model)
    , App.map NumericStepperMsg (NumericStepper.view model.stepper)
    ]
