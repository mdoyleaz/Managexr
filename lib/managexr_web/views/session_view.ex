defmodule ManagexrWeb.SessionView do
  use ManagexrWeb, :view

  def render("auth_token.json", %{auth_token: auth_token}) do
    %{data: %{auth_token: auth_token.token}}
  end

  def render("revoked.json", %{revoked: revoked_count}) do
    %{data: %{tokens_revoked: revoked_count}}
  end
end
