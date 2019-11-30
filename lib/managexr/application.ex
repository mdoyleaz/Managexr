defmodule Managexr.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Managexr.Repo,
      ManagexrWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Managexr.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ManagexrWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
