defmodule Managexr.AuthErrorHandler do
  import Plug.Conn

  def auth_error(conn, {:invalid_token, _reason}, _opts),
    do: response(conn, :unauthorized, :invalid_token)

  def auth_error(conn, {:unauthenticated, _reason}, _opts),
    do: response(conn, :unauthorized, :unauthorized)

  def auth_error(conn, {:no_resource_found, _reason}, _opts),
    do: response(conn, :unauthorized, :no_resource_found)

  def auth_error(conn, {type, _reason}, _opts), do: response(conn, :forbidden, to_string(type))

  defp response(conn, status, message) do
    body = Jason.encode!(%{error: message})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, body)
  end
end
