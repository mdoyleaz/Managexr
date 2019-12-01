defmodule ManagexrWeb.SessionController do
  use ManagexrWeb, :controller

  alias Managexr.Auth

  action_fallback ManagexrWeb.FallbackController

  def create(conn, %{"email" => _, "password" => _} = user) do
    case Auth.sign_in(user) do
      {:ok, auth_token} ->
        render(conn, "auth_token.json", auth_token: auth_token)

      error ->
        error
    end
  end

  def delete(conn, _) do
    case Auth.sign_out(conn) do
      {:ok, _} -> send_resp(conn, 204, "")
      error -> error
    end
  end
end
