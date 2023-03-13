defmodule Helpers.NameHelper do

  def get_name(currency_from, currency_to) do
    key = "#{currency_from}_#{currency_to}"
    {:via, Registry, {:currency_registry, key}}
  end

end
