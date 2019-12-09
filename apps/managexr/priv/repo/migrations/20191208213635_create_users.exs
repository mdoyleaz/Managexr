defmodule Managexr.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :password_hash, :string
      add :role_id, references(:user_roles, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
