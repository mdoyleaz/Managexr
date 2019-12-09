# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Managexr.Repo.insert!(%Managexr.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
require Logger

alias Managexr.Repo
alias Managexr.Accounts.User
alias Managexr.Accounts.UserRole

## Seed Roles
roles =
  ["admin", "escalated", "basic"]
  |> Enum.map(&UserRole.changeset(%UserRole{}, %{role_name: &1}))

Repo.transaction(fn ->
  Enum.each(roles, &Repo.insert!(&1, []))
end)

# ## Seed Default Admin User
role = Repo.get_by(UserRole, role_name: "admin")

User.changeset(%User{}, %{email: "admin@example.com", password_hash: "password", role_id: role.id})
|> Repo.insert()

Logger.info("Seeds complete")
