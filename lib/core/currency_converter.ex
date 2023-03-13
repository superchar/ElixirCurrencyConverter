defmodule Core.CurrencyConverter do
  use DynamicSupervisor
  alias Core.CurrencyRateJob
  import Helpers.NameHelper

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def convert(currency_from, currency_to, amount, retrieve_currency_rate) do
    name = get_name(currency_from, currency_to)
    child_spec = {CurrencyRateJob, %CurrencyRateJob{name: name, callback: retrieve_currency_rate}}
    rate = case DynamicSupervisor.start_child(__MODULE__, child_spec) do
      {:ok, _} -> GenServer.call(name, :get_rates, :infinity)
      {:error, {:already_started, _}} -> GenServer.call(name, :get_rates, :infinity)
    end

    amount * rate
  end
end
