defmodule Managexr.Accounts do
  import Ecto.Query, warn: false
  alias Managexr.Repo

  alias Managexr.Accounts.User
  alias Managexr.Accounts.Token
  alias Managexr.Accounts.UserRole

  alias Authentication.Guardian

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id) |> create_token()
  def get_by_email!(email), do: Repo.get_by!(User, email: email)

  def create_user(%{"role" => role} = attrs \\ %{}) do
    %{id: role_id} = get_role_by_name(role)
    attrs = Map.put(attrs, "role_id", role_id)

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def create_token(user) do
    user
    |> Repo.preload(:role)
    |> Jason.encode()
    |> Map.from_struct()
    |> Guardian.encode_and_sign()
  end

  def get_role_by_name(role), do: Repo.get_by!(UserRole, role_name: role)
end
