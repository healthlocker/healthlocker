defmodule Healthlocker.SupportController do
  use Healthlocker.Web, :controller
  import Healthlocker.Plugs.FindRoom
  plug :find_room

  def index(conn, _params) do
    render conn, "index.html"
  end
end
