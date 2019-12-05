defmodule Managexr.Auth.Sessions.SweeperServer do
  use GenServer
  alias Managexr.Auth.Sessions.Sweeper

  def start_link(opts) do
    state = Enum.into(opts, %{ttl: Sweeper.get_ttl()})

    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def reset_timer, do: GenServer.call(__MODULE__, :reset_timer)

  def sweep, do: GenServer.call(__MODULE__, :sweep)

  def init(state), do: {:ok, Sweeper.schedule_work(state)}

  def handle_call(:sweep, _from, state), do: {:reply, :ok, Sweeper.sweep(state)}
  def handle_call(:reset_timer, _from, state), do: {:reply, :ok, Sweeper.schedule_work(state)}

  def handle_info(:sweep, state), do: {:noreply, Sweeper.sweep(state)}
  def handle_info(_, state), do: {:noreply, state}
end
