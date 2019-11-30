defmodule Managexr.Auth.Guardian do
  use Guardian, otp_app: :managexr

  alias Managexr.Accounts

  def subject_for_token(resource, _claims), do: {:ok, resource.id}

  def resource_from_claims(claims) do
    case Accounts.get_user(claims["sub"]) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end

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

  defp check_password_verification(true, user), do: {:ok, user}
  defp check_password_verification(_, _), do: {:error, :unauthorized}
end