defmodule ManagexrWeb.SessionView do
  use ManagexrWeb, :view

  def render("auth_token.json", %{auth_token: auth_token}) do
    %{data: %{auth_token: auth_token.token}}
  end
end
