defmodule Managexr.Accounts.Token do
  defstruct [:user_id, :email, :role, :password_hash, :password]

  alias __MODULE__

  def build_token(%{id: id, email: email, role: %{role_name: role} = user}) do
    # %Token{user_id: id, email: email, role: role}
  end
end
