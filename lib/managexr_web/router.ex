defmodule ManagexrWeb.Router do
  use ManagexrWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Managexr.Guardian.AuthPipeline
  end

  scope "/api/v1", ManagexrWeb do
    pipe_through :api

    scope "/auth" do
      post "/signin", SessionController, :sign_in
    end
  end

  # Protected Routes
  scope "/api/v1", ManagexrWeb do
    pipe_through [:api, :auth]

    scope "/accounts" do
      get "/", Accounts.UserController, :index
      post "/create_user", Accounts.UserController, :create
    end

    delete "/auth/signout", SessionController, :sign_out
  end
end
