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
        |> check_password_verification(user)
    end
  end

  defp check_password_verification(true, user) do
    token = Authenticator.generate_token(user)
    Repo.insert(Ecto.build_assoc(user, :auth_tokens, %{token: token}))
  end

  defp check_password_verification(_, _), do: {:error, :unauthorized}

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
  defp delete_token(auth_token), do: Repo.delete(auth_token)
end
