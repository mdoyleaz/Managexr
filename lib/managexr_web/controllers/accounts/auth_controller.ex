defmodule ManagexrWeb.Accounts.AuthController do
  use ManagexrWeb, :controller

  alias Managexr.Accounts.Auth
  action_fallback ManagexrWeb.FallbackController

  def sign_in(conn, %{"email" => _, "password" => _} = user) do
    case Auth.authenticate_user(user) do
      {:ok, token, _claims} ->
        render(conn, "auth_token.json", auth_token: token)

      error ->
        error
    end
  end
end
