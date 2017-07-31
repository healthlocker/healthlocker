defmodule Healthlocker.Plugs.AppName do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    if conn.assigns[:app_name] do
      conn
    else
      conn
      |> put_app_name(Healthlocker.Endpoint.url())
    end
  end

  defp put_app_name(conn, current_url) do
    # this will later default to "healthlocker", unless it is the url for oxleas
    case current_url do
      "http://localhost:4000"->
        conn
        |> Phoenix.Controller.put_layout({Healthlocker.HealthlockerLayoutView, "app.html"})
      "https://www.healthlocker.uk/" ->
        conn
        |> Phoenix.Controller.put_layout({Healthlocker.HealthlockerLayoutView, "app.html"})
      _ ->
        conn
        |> Phoenix.Controller.put_layout({Healthlocker.OxleasLayoutView, "app.html"})
    end
  end
end
