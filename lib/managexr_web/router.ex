defmodule ManagexrWeb.Router do
  use ManagexrWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", ManagexrWeb do
    pipe_through :api

    scope "/auth" do
      post "/signin", SessionController, :create
      delete "/signout", SessionController, :delete
    end

    scope "/accounts" do
      get "/", Accounts.UserController, :index
      post "/create_user", Accounts.UserController, :create
    end
  end

  # Protected Routes
  scope "/api/v1", ManagexrWeb do
    pipe_through [:api]
  end
end
