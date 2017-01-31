defmodule Healthlocker.ComponentController do
  use Healthlocker.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
