defmodule Healthlocker.SupportController do
  use Healthlocker.Web, :controller
  import Healthlocker.Plugs.FindRoom
  plug :find_room

  def index(conn, _params) do
    conn
    |> Healthlocker.SetView.set_view("SupportView")
    |> render("index.html")
  end
end
