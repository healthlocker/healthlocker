defmodule Healthlocker.PasswordController do
  use Healthlocker.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end
end
