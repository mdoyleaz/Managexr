defmodule Managexr.Auth.AuthToken do
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__
  alias Managexr.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "auth_tokens" do
    belongs_to :user, User, foreign_key: :user_id, type: :binary_id
    field :revoked, :boolean, default: false
    field :revoked_at, :utc_datetime
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(%AuthToken{} = auth_token, attrs) do
    auth_token
    |> cast(attrs, [:token, :revoked, :revoked_at])
    |> validate_required([:token, :revoked, :revoked_at])
    |> unique_constraint(:token)
  end
end
