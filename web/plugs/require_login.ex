defmodule Healthlocker.Plugs.RequireLogin do
  import Plug.Conn
  use Healthlocker.Web, :controller

  def init(opts), do: opts
  def call(conn, _) do
    if conn.assigns[:current_user] do
      conn
    else
      conn |> redirect_to_login
    end
  end

  defp redirect_to_login(conn) do
    conn
    |> put_flash(:error,  "You must be logged in to access that page!")
    |> redirect(to: login_path(conn, :index))
    |> halt
  end
end
