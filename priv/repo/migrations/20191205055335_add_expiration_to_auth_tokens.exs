defmodule Managexr.Repo.Migrations.AddExpirationToAuthTokens do
  use Ecto.Migration

  def change do
    alter table(:auth_tokens) do
      add :expiration, :utc_datetime
    end
  end
end
