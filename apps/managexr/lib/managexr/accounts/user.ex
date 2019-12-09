defmodule Managexr.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias Managexr.Accounts.UserRole

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    belongs_to :role, UserRole, foreign_key: :role_id, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password_hash, :role_id])
    |> validate_required([:email, :password_hash, :role_id])
    |> foreign_key_constraint(:role_id)
  end
end
