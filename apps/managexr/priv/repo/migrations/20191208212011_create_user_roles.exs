defmodule Managexr.Repo.Migrations.CreateUserRoles do
  use Ecto.Migration

  def change do
    create table(:user_roles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :role_name, :string

      timestamps()
    end

    create unique_index(:user_roles, [:role_name])
  end
end
