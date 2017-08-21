defmodule Healthlocker.SetView do
  def set_view(conn, view) do
    case conn.assigns.app_name do
      "oxleas" ->
        conn
        |> Phoenix.Controller.put_view(:"Elixir.Healthlocker.Oxleas.#{view}")
      _ ->
        conn
    end
  end
end
