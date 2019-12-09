defmodule Managexr.Accounts.UserRole do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "user_roles" do
    field :role_name, :string

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:role_name])
    |> validate_required([:role_name])
  end
end
