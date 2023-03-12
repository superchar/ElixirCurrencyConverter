defmodule Core.RefreshingJob do
  use GenServer

  defstruct timeout: 6000, callback: nil, rate: nil

  def start_link(args) do

    GenServer.start_link(__MODULE__, args, [])
  end

  def init(args) do
    schedule_next(args)

    {:ok, args}
  end

  def handle_call(:get_rates, from, %__MODULE__{rate: nil, callback: callback} = args) do

    handle_call(:get_rates, from, %__MODULE__{args | rate: callback.()})
  end

  def handle_call(:get_rates, _, %{rate: rate} = args) do

    {:reply, rate, args}
  end

  def handle_info(:poll, %{callback: callback} = args) do
    schedule_next(args)

    {:noreply, Map.put(args, :rate, callback.())}
  end

  defp schedule_next(%{timeout: timeout}) do

    Process.send_after(self(), :poll, timeout)
  end

end
