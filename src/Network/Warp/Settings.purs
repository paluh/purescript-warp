module Network.Warp.Settings where 

import Prelude (Unit, pure, unit, ($))
import Data.Maybe (Maybe)
import Data.Tuple.Nested ((/\))
import Data.String.NonEmpty (unsafeFromString) as NE
import Effect (Effect)
import Effect.Console as Console 
import Effect.Exception as Ex 
import Network.HTTP.Types (Host(..))
import Network.HTTP.Types (hContentType, status500) as H
import Network.Wai.Internal (Request, Response)
import Network.Wai (responseStr)
import URI.Host.RegName (unsafeFromString) as HostRegName 
import Partial.Unsafe (unsafePartial)

type Settings 
    = { port :: Int
      , host :: Host 
      , beforeMainLoop :: Effect Unit
      , onException :: Maybe Request -> Ex.Error -> Effect Unit 
      , onExceptionResponse :: Ex.Error -> Response 
      , serverName :: String
      }

defaultSettings :: Settings 
defaultSettings = { port: 3000
                  , host: localhost
                  , beforeMainLoop: pure unit 
                  , onException: \_ e -> Console.log $ Ex.message e 
                  , onExceptionResponse: defaultOnExceptionResponse
                  , serverName: "Warp/0.0.1"
                  }
        where 
            localhost = NameAddress $ HostRegName.unsafeFromString $ unsafePartial $ NE.unsafeFromString "localhost"

defaultOnExceptionResponse :: Ex.Error -> Response 
defaultOnExceptionResponse _ = 
  responseStr H.status500 [H.hContentType /\ "text/plain; charset=utf-8"] H.status500.message