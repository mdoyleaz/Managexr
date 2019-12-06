defmodule Managexr.Auth.Authenticator do
  @secret Application.get_env(:managexr, :authenticator)[:secret]
  @seed Application.get_env(:managexr, :authenticator)[:seed]

  @missing_token {:error, :missing_token}

  def generate_token(id) do
    Phoenix.Token.sign(@secret, @seed, id, max_age: 86400)
  end

  def verify_token(token) do
    case Phoenix.Token.verify(@secret, @seed, token, max_age: 86400) do
      {:ok, _} -> {:ok, token}
      {:error, _} -> :error
    end
  end

  def parse_token(conn) do
    case extract_token(conn) do
      {:ok, token} -> verify_token(token)
      error -> error
    end
  end

  defp extract_token(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      [auth_header] -> get_token_from_header(auth_header)
      _ -> @missing_token
    end
  end

  defp get_token_from_header(auth_header) do
    {:ok, reg} = Regex.compile("Bearer\:?\s+(.*)$", "i")

    case Regex.run(reg, auth_header) do
      [_, match] -> {:ok, String.trim(match)}
      _ -> @missing_token
    end
  end
end
