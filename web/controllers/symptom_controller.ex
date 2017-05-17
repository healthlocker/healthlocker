defmodule Healthlocker.SymptomController do
  use Healthlocker.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end

end
