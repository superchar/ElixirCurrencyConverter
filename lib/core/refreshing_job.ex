defmodule Core.RefreshingJob do
  use GenServer

  defstruct timeout: 6000, callback: nil, rate: nil, name: nil

  def start_link(%__MODULE__{name: name} = args) do
    GenServer.start_link(__MODULE__, args, name: name)
  end

  def init(args) do
    schedule_next(args)
    {:ok, args}
  end

  def handle_call(:get_rates, from, %__MODULE__{rate: nil, callback: callback} = args) do
    handle_call(:get_rates, from, %__MODULE__{args | rate: callback.()})
  end

  def handle_call(:get_rates, _, %__MODULE__{rate: rate} = args) do
    {:reply, rate, args}
  end

  def handle_info(:poll, %__MODULE__{callback: callback} = args) do
    schedule_next(args)
    {:noreply, Map.put(args, :rate, callback.())}
  end

  defp schedule_next(%__MODULE__{timeout: timeout}) do
    Process.send_after(self(), :poll, timeout)
  end

end
