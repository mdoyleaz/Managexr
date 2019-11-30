defmodule ManagexrWeb.SessionController do
  use ManagexrWeb, :controller

  alias Managexr.Auth.Guardian

  action_fallback ManagexrWeb.FallbackController

  def sign_in(conn, %{"email" => _, "password" => _} = user) do
    case Guardian.authenticate_user(user) do
      {:ok, user} ->
        token =
          Guardian.Plug.sign_in(conn, user)
          |> Guardian.Plug.current_token()

        render(conn, "auth_token.json", auth_token: token)

      error ->
        error
    end
  end

  def sign_out(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> json(%{success: "logged_out"})
  end
end
