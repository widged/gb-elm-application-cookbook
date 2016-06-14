module Messages (..) where

import Html exposing (..)
import Effects exposing (Effects, Never)
import MessagesActions exposing (..)


type alias Model =
  { message : String
  }


initialModel : Model
initialModel =
  { message = "Initial message"
  }



-- VIEW


view : Signal.Address Action -> Model -> Html
view address model =
  div [] [ text model.message ]



-- UPDATE


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    ShowMessage msg ->
      ( { model | message = msg }, Effects.none )
