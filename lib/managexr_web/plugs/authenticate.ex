defmodule ManagexrWeb.Plugs.Authenticate do
  import Plug.Conn

  alias Managexr.Auth

  def init(default), do: default

  def call(conn, _default) do
    case Managexr.Auth.Authenticator.parse_token(conn) do
      {:ok, token} ->
        case check_session_cache(token) do
          nil -> get_token_from_database(conn, token)
          user -> authorized(conn, user)
        end

      _ ->
        unauthorized(conn)
    end
  end

  defp get_token_from_database(conn, auth_token) do
    case Auth.get_token_by_user(auth_token) do
      nil -> unauthorized(conn)
      auth_token -> authorized(conn, auth_token.user)
    end
  end

  defp check_session_cache(token), do: ConCache.get_or_store(:session_cache, token)

  defp authorized(conn, user) do
    conn
    |> assign(:signed_in, true)
    |> assign(:signed_user, user)
  end

  defp unauthorized(conn) do
    conn |> send_resp(401, "Unauthorized") |> halt()
  end
end
