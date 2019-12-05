defmodule Managexr.Auth do
  alias Managexr.Repo

  import Ecto.Query, only: [from: 2]

  alias Managexr.Accounts
  alias Managexr.Auth.AuthToken
  alias Managexr.Auth.SessionCache
  alias Managexr.Auth.Authenticator

  @invalid_token {:error, :invalid_token}

  # Public functions
  def sign_in(%{"email" => email, "password" => password}) do
    case Accounts.get_user_by_email(email) do
      nil ->
        Argon2.no_user_verify()
        {:error, :invalid_credentials}

      user ->
        Argon2.verify_pass(password, user.password_hash)
        |> store_token(user)
    end
  end

  def sign_out(conn) do
    case Authenticator.parse_token(conn) do
      {:ok, token} ->
        get_token(token)
        |> delete_token()

      error ->
        error
    end
  end

  def get_token(token),
    do: Repo.get_by(AuthToken, %{token: token}) |> Repo.preload(:user)

  def verify_session(conn) do
    with {:ok, token} <- Authenticator.parse_token(conn) do
      get_session(token)
    else
      _ -> @invalid_token
    end
  end

  def revoke_tokens_by_user_id(%{assigns: %{signed_user: %{id: user_id}}}) do
    remove_revoked_tokens_from_cache(user_id)

    from(t in AuthToken,
      where: t.user_id == ^user_id,
      where: t.revoked == false,
      update: [set: [revoked: true, revoked_at: ^DateTime.utc_now()]]
    )
    |> Repo.update_all([])
  end

  # Private Functions
  defp remove_revoked_tokens_from_cache(user_id) do
    from(t in AuthToken,
      where: t.user_id == ^user_id,
      where: t.revoked == false,
      select: t.token
    )
    |> Repo.all()
    |> SessionCache.delete_session()
  end

  defp get_session(token) do
    case SessionCache.get_session(token) do
      nil -> verify_session_with_database(token)
      session -> session
    end
  end

  defp verify_session_with_database(token) do
    case get_token(token) do
      %{revoked: revoked} = session when not revoked ->
        SessionCache.add_session(session)
        session

      _ ->
        @invalid_token
    end
  end

  defp delete_token(nil), do: @invalid_token

  defp delete_token(%{token: token} = auth_token) do
    SessionCache.delete_session(token)
    Repo.delete(auth_token)
  end

  defp store_token(true, user) do
    token = Authenticator.generate_token(%{user_id: user.id, email: user.email, role: "Admin"})
    SessionCache.add_session(%{token: token, user: user})

    Repo.insert(
      Ecto.build_assoc(user, :auth_tokens, %{token: token, expiration: expiration_time()})
    )
  end

  defp store_token(false, _), do: @invalid_token

  # Session tokens expire after 21 days
  defp expiration_time do
    DateTime.utc_now()
    |> DateTime.add(86400 * 21, :second)
    |> DateTime.truncate(:second)
  end
end
