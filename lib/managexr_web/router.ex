defmodule ManagexrWeb.Router do
  use ManagexrWeb, :router

  alias Managexr.Guardian

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Guardian.AuthPipeline
  end

  scope "/api/v1", ManagexrWeb do
    pipe_through :api

    scope "/auth" do
      post "/sign_in", Accounts.AuthController, :sign_in
      post "/sign_out", Accounts.AuthController, :sign_out
    end
  end

  # Protected Routes
  scope "/api/v1", ManagexrWeb do
    pipe_through [:api, :auth]

    scope "/accounts" do
      get "/", Accounts.UserController, :index
      post "/create_user", Accounts.UserController, :create
    end
  end
end
