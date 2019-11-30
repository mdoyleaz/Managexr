defmodule Managexr.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Argon2, only: [hash_pwd_salt: 1]

  alias __MODULE__
  alias Managexr.Auth.AuthToken

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    has_many :auth_tokens, AuthToken
    field :email, :string
    field :password_hash, :string

    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> hash_password
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    put_change(changeset, :password_hash, hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset
end
