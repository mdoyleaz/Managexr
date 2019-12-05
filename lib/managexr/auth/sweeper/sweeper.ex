defmodule Managexr.Auth.Sweeper.Sweeper do
  alias Managexr.Auth.AuthToken

  def sweep(state) do
    IO.inspect(state)
    AuthToken.sweep_tokens()
    schedule_work(state)
  end

  def schedule_work(state) do
    case state[:timer] do
      true -> Process.cancel_timer(state.timer)
      _ -> state
    end

    timer = Process.send_after(self(), :sweep, state[:ttl])

    Map.put(state, :timer, timer)
  end

  def get_ttl do
    Application.get_env(:managexr, :token_sweeper)[:ttl]
    |> minute_to_ms()
  end

  defp minute_to_ms(value) when is_binary(value) do
    value
    |> String.to_integer()
    |> minute_to_ms()
  end

  defp minute_to_ms(value) when value < 1, do: 1000
  defp minute_to_ms(value), do: round(value * 60 * 1000)
end
