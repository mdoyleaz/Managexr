defmodule Managexr.Authenticate do
  alias Managexr.Accounts

  alias Authentication

  def sign_in(%{"email" => email, "password" => password}) do
    email
    |> Accounts.get_by_email!()
    |> Authentication.verify_user(password)
  end
end
