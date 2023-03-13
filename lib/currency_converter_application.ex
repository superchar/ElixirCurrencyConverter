defmodule CurrencyConverterApplication do
  alias Core.CurrencyConverter
  use Application

  def start(_type, _args) do
    children = [
      {Registry, [keys: :unique, name: :currency_registry]},
      {Core.CurrencyConverter, []},
    ]
    opts = [strategy: :one_for_one, name: CurrencyConverter.Supervisor]

    Supervisor.start_link(children, opts)
  end

end
