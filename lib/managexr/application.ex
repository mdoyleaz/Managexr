defmodule Managexr.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Managexr.Repo,
      ManagexrWeb.Endpoint,
      Managexr.Auth.Sessions.Supervisor,
      {ConCache,
       [
         name: :session_cache,
         ttl_check_interval: :timer.seconds(30),
         global_ttl: :timer.minutes(60),
         touch_on_read: true,
         write_concurrency: true,
         read_concurrency: true
       ]}
    ]

    opts = [strategy: :one_for_one, name: Managexr.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ManagexrWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
