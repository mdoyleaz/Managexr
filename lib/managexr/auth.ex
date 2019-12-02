defmodule Managexr.Auth do
  alias Managexr.Repo

  alias Managexr.Accounts
  alias Managexr.Auth.AuthToken
  alias Managexr.Auth.SessionCache
  alias Managexr.Auth.Authenticator

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

    SessionCache.add_session_to_cache(%{token: token, user: user})
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

  def get_token(token), do: Repo.get_by(AuthToken, %{token: token})
  def get_token_with_user(token), do: get_token(token) |> Repo.preload(:user)

  defp delete_token(nil), do: {:error, :invalid_token}

  defp delete_token(%{token: token} = auth_token) do
    SessionCache.delete_session_from_cache(token)
    Repo.delete(auth_token)
  end

  def verify_session(conn) do
    with {:ok, token} <- Authenticator.parse_token(conn),
         cached_session <- SessionCache.get_session_from_cache(token) do
      case cached_session do
        nil -> verify_session_with_database(token)
        _ -> cached_session
      end
    else
      error -> error
    end
  end

  defp verify_session_with_database(token) do
    case get_token_with_user(token) do
      nil ->
        :error

      session ->
        SessionCache.add_session_to_cache(session)
        session
    end
  end
end
