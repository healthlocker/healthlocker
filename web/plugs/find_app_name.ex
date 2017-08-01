defmodule Healthlocker.Plugs.AppName do
  import Plug.Conn

  def init(opts), do: opts

  # can put app_name in assigns and use for setting the layout view & also for
  # manually changing the app environment

  def call(conn, _) do
    case Healthlocker.Endpoint.url() do
      "http://localhost:4000"->
        conn
        |> assign(:app_name, "healthlocker")
      "https://www.healthlocker.uk/" ->
        conn
        |> assign(:app_name, "healthlocker")
      _ ->
        conn
        |> assign(:app_name, "oxleas")
        |> Phoenix.Controller.put_layout({Healthlocker.Oxleas.LayoutView, "app.html"})
    end
  end

  # Will use this for /entry point and call from above. Can set something in conn to indicate it's been set manually.
  # defp put_app_name(conn, current_url) do
  #   # this will later default to "healthlocker", unless it is the url for oxleas
  #   case current_url do
  #     "http://localhost:4000"->
  #       conn
  #       |> Phoenix.Controller.put_layout({Healthlocker.HealthlockerLayoutView, "app.html"})
  #     "https://www.healthlocker.uk/" ->
  #       conn
  #       |> Phoenix.Controller.put_layout({Healthlocker.HealthlockerLayoutView, "app.html"})
  #     _ ->
  #       conn
  #       |> Phoenix.Controller.put_layout({Healthlocker.OxleasLayoutView, "app.html"})
  #   end
  # end
end
