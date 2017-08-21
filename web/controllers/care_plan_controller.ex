defmodule Healthlocker.CarePlanController do
  use Healthlocker.Web, :controller

  def index(conn, _params) do
    conn
    |> Healthlocker.SetView.set_view("CarePlanView")
    |> render("index.html")
  end
end
