defmodule Managexr.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :managexr,
    module: Managexr.Guardian,
    error_handler: Managexr.AuthErrorHandler,
    secret_key: "7MebKn6qOWX18OetI6OAQB8R7aAiRVpbPUcmdB3M6jk1uSZi6rhUhnSaxMYdUg77"

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated, claims: %{"typ" => "access"}
end
