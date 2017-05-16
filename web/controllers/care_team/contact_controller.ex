defmodule Healthlocker.CareTeam.ContactController do
  use Healthlocker.Web, :controller

  def show(conn, _params) do
    service_user = Healthlocker.Slam.ServiceUser.for(conn.assigns.current_user)

    conn
    |> assign(:service_user, service_user)
    |> assign(:care_team, Healthlocker.Slam.CareTeam.for(service_user))
    |> render("show.html")
  end
end
