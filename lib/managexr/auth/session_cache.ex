defmodule Managexr.Auth.SessionCache do
  @table :session_cache
  def add_session_to_cache(%{token: token, user: user}), do: ConCache.put(@table, token, user)
  def delete_session_from_cache(token), do: ConCache.delete(@table, token)
  def get_session_from_cache(token), do: ConCache.get(@table, token)
end
