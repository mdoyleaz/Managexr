defmodule Managexr.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :managexr,
    module: Managexr.Auth.Guardian,
    error_handler: Managexr.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
