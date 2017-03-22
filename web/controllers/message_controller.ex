defmodule Healthlocker.MessageController do
  use Healthlocker.Web, :controller

  plug :authenticate

  def index(conn, _params) do
    render conn, "index.html"
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error,  "You must be logged in to access that page!")
      |> redirect(to: login_path(conn, :index))
      |> halt()
    end
  end
end
