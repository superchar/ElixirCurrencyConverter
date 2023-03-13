defmodule Api.CurrencyConverterApi do
  use Plug.Router
  alias Core.CurrencyConverter

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  get "/convertions/:currencyfrom/:currencyto/:amount" do
    callback = fn -> :timer.sleep(10000); IO.puts("executed"); 42; end
    {int_amount, _} = Integer.parse(amount)

    result = CurrencyConverter.convert(currencyfrom, currencyto, int_amount, callback)
    send_resp(conn, 200, Poison.encode!(%{converted_amount: result}))
  end

  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end
end
