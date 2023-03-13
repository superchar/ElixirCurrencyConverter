defmodule Core.CurrencyConverter do
  use DynamicSupervisor
  alias Core.RefreshingJob
  import Helpers.NameHelper

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def convert(currency_from, currency_to, amount, retrieve_currency_rate) do
    name = get_name(currency_from, currency_to)
    child_spec = {RefreshingJob, %RefreshingJob{name: name, callback: retrieve_currency_rate}}
    rate = case DynamicSupervisor.start_child(__MODULE__, child_spec) do
      {:ok, _} -> IO.puts("OK"); GenServer.call(name, :get_rates)
      {:error, {:already_started, _}} ->  IO.puts("NOTOK");  GenServer.call(name, :get_rates)
    end

    amount * rate
  end
end
