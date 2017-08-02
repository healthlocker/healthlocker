defmodule Healthlocker.QueryEpjs do
  def query_epjs(url, data) do
    stringified_data = Poison.encode!(data)
    case HTTPoison.get(url <> stringified_data, [], []) do
      {:ok, response} ->
        response.body
          |> Poison.decode!
      {:error, response} ->
        # something went wrong. returning an empty list for now
        []
    end
  end
end
