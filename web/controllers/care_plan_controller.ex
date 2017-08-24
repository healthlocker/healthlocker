defmodule Healthlocker.CarePlanController do
  use Healthlocker.Web, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end
end
