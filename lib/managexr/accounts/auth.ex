defmodule Managexr.Accounts.Auth do
  alias Managexr.Accounts
  alias Managexr.Accounts.Guardian

  def authenticate_user(%{"email" => email, "password" => password}) do
    case Accounts.get_user_by_email(email) do
      nil ->
        Argon2.no_user_verify()
        {:error, :invalid_credentials}

      user ->
        Argon2.verify_pass(password, user.password_hash)
        |> check_password_verification(user)
    end
  end

  defp check_password_verification(true, user), do: user |> Guardian.encode_and_sign()
  defp check_password_verification(_, _), do: {:error, :unauthorized}
end
