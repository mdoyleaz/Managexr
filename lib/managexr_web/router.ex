defmodule ManagexrWeb.Router do
  use ManagexrWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug ManagexrWeb.Plugs.Authenticate
  end

  scope "/api/v1", ManagexrWeb do
    pipe_through :api

    scope "/auth" do
      post "/signin", SessionController, :create
      delete "/signout", SessionController, :delete
    end
  end

  # Protected Routes
  scope "/api/v1", ManagexrWeb do
    pipe_through [:api, :auth]

    resources "/accounts", Accounts.UserController

    put "/auth/revoke", SessionController, :revoke_tokens
  end
end
