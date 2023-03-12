defmodule Core.RefreshingJob do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, [])
  end

  def init(args) do
    {:ok, args}
  end

  def handle_call(:get_rates, _from, args) do
    new_args = case args do
      [{:rate, _ }| _] -> args
      [callback: callback] -> [rate: callback.()] ++ args
    end
    {:reply, new_args[:rate], new_args}
  end

end
