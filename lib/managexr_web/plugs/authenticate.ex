defmodule ManagexrWeb.Plugs.Authenticate do
  import Plug.Conn

  alias Managexr.Auth

  def init(default), do: default

  def call(conn, _default) do
    case Auth.verify_session(conn) do
      {:error, _} ->
        unauthorized(conn)

      session ->
        authorized(conn, session)
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
