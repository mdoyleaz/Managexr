defmodule Managexr.Repo do
  use Ecto.Repo,
    otp_app: :managexr,
    adapter: Ecto.Adapters.Postgres
end
