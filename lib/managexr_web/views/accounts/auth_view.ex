defmodule ManagexrWeb.Accounts.AuthView do
  use ManagexrWeb, :view

  def render("auth_token.json", %{auth_token: token}) do
    %{auth_token: token}
  end
end
