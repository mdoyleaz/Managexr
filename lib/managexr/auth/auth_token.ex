defmodule Managexr.Auth.AuthToken do
  use Ecto.Schema

  import Ecto.Query
  import Ecto.Changeset

  alias __MODULE__
  alias Managexr.Repo
  alias Managexr.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "auth_tokens" do
    belongs_to :user, User, foreign_key: :user_id, type: :binary_id
    field :token, :string
    field :revoked, :boolean, default: false
    field :revoked_at, :utc_datetime
    field :expiration, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(%AuthToken{} = auth_token, attrs) do
    auth_token
    |> cast(attrs, [:token, :revoked, :revoked_at, :expiration])
    |> validate_required([:token, :revoked, :revoked_at])
    |> unique_constraint(:token)
  end

  def sweep_tokens,
    do: Repo.delete_all(from t in AuthToken, where: t.expiration < ^DateTime.utc_now())

  def get_tokens_by_user(user_id) do
    from(t in AuthToken,
      where: t.user_id == ^user_id,
      where: t.revoked == false,
      select: t.token
    )
    |> Repo.all()
  end
end
