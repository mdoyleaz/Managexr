defmodule Managexr.Auth do
  alias Managexr.Repo

  alias Managexr.Accounts
  alias Managexr.Auth.AuthToken
  alias Managexr.Auth.Authenticator

  def get_token(token), do: Repo.get_by(AuthToken, %{token: token})
  def get_token_by_user(token), do: get_token(token) |> Repo.preload(:user)

  def sign_in(%{"email" => email, "password" => password}) do
    case Accounts.get_user_by_email(email) do
      nil ->
        Argon2.no_user_verify()
        {:error, :invalid_credentials}

      user ->
        Argon2.verify_pass(password, user.password_hash)
        |> store_token(user)
    end
  end

  defp store_token(false, _), do: {:error, :unauthorized}

  defp store_token(true, user) do
    token = Authenticator.generate_token(user)

    ConCache.put(:session_cache, token, user)
    Repo.insert(Ecto.build_assoc(user, :auth_tokens, %{token: token}))
  end

  def sign_out(conn) do
    case Authenticator.parse_token(conn) do
      {:ok, token} ->
        get_token(token)
        |> delete_token()

      error ->
        error
    end
  end

  defp delete_token(nil), do: {:error, :invalid_token}

  defp delete_token(auth_token) do
    ConCache.delete(:session_cache, auth_token.token)
    Repo.delete(auth_token)
  end
end
