defmodule ManagexrWeb.Router do
  use ManagexrWeb, :router

  forward "/graphql", Absinthe.Plug, schema: ManagexrWeb.Schema, json_codec: Jason

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ManagexrWeb do
    pipe_through :api

    resources "/accounts", UserController
  end
end
