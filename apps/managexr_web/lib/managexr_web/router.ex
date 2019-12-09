defmodule ManagexrWeb.Router do
  use ManagexrWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ManagexrWeb do
    pipe_through :api

    resources "/accounts", UserController
  end
end
