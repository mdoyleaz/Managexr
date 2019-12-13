defmodule Managexr.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias Authentication.Password
  alias Managexr.Accounts.UserRole

  @derive {Jason.Encoder, except: [:__meta__, :__struct__, :role, :password_hash]}

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    belongs_to :role, UserRole, foreign_key: :role_id, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :role_id])
    |> validate_required([:email, :password, :role_id])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> hash_password
    |> foreign_key_constraint(:role_id)
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    put_change(changeset, :password_hash, Password.hash_password(password))
  end
end
