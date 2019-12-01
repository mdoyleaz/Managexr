defmodule ManagexrWeb.Plugs.Authenticate do
  import Plug.Conn

  alias Managexr.Auth

  def init(default), do: default

  def call(conn, _default) do
    case Managexr.Auth.Authenticator.parse_token(conn) do
      {:ok, token} ->
        case(Auth.get_token_by_user(token)) do
          nil -> unauthorized(conn)
          auth_token -> authorized(conn, auth_token.user)
        end

      _ ->
        unauthorized(conn)
    end
  end

  defp authorized(conn, user) do
    conn
    |> assign(:signed_in, true)
    |> assign(:signed_user, user)
  end

  defp unauthorized(conn) do
    conn |> send_resp(401, "Unauthorized") |> halt()
  end
end
