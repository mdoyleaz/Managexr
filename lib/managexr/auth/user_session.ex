defmodule Managexr.Auth.UserSession do
  defstruct [:user_id, :email, :role, :token, :expiration]

  alias __MODULE__
  alias Managexr.Auth.Authenticator

  def build_session(%{user_id: id, email: email}) do
    session = %UserSession{
      user_id: id,
      email: email,
      role: "role",
      expiration: expiration_time()
    }

    %UserSession{session | token: Authenticator.generate_token(session)}
  end

  # Session tokens expire after 21 days
  defp expiration_time do
    DateTime.utc_now()
    |> DateTime.add(86400 * 21, :second)
    |> DateTime.truncate(:second)
  end
end
