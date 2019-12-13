defmodule Authentication.Password do
  alias Argon2

  def hash_password(password), do: Argon2.hash_pwd_salt(password)

  def validate_password(password, hashed_password) do
    case Argon2.verify_pass(password, hashed_password) do
      true -> :ok
      false -> {:error, :invalid_credentials}
    end
  end
end
