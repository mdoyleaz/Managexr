defmodule Managexr.Auth.SessionCache do
  @table :session_cache
  def add_session(%{token: token, user: user}), do: ConCache.put(@table, token, user)

  def delete_session(tokens) when is_list(tokens) do
    Enum.each(tokens, fn token -> delete_session(token) end)
  end

  def delete_session(token), do: ConCache.delete(@table, token)

  def get_session(token), do: ConCache.get(@table, token)
end
