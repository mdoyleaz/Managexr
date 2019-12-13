defmodule ManagexrWeb.UserController do
  use ManagexrWeb, :controller

  alias Managexr.Accounts
  alias Managexr.Accounts.User

  action_fallback ManagexrWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => %{"email" => _, "password" => _} = user}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user),
         {:ok, token, _claims} <- Accounts.create_token(user) do
      conn
      |> render("jwt.json", jwt: token)
    end
  end

  def show(conn, %{"id" => id}) do
    user =
      Accounts.get_user!(id)
      |> IO.inspect()

    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
