defmodule CurrencyConverterApplication do
  alias Core.CurrencyConverter
  alias Api.CurrencyConverterApi
  use Application

  def start(_type, _args) do
    children = [
      {Registry, [keys: :unique, name: :currency_registry]},
      {CurrencyConverter, []},
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: CurrencyConverterApi,
        options: [port: 4001]
      )
    ]
    opts = [strategy: :one_for_one, name: CurrencyConverter.Supervisor]

    Supervisor.start_link(children, opts)
  end

end
