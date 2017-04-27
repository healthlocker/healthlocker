defmodule Healthlocker.CareTeamController do
  use Healthlocker.Web, :controller

  def index(conn, _params) do
    conn
    |> assign(:service_user, service_user_for(conn.assigns.current_user))
    |> render("index.html")
  end


  defp service_user_for(carer) do
    carer = carer |> Repo.preload(:caring)
    [service_user | _] = carer.caring
    service_user
  end
end
