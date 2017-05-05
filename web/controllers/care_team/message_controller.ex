defmodule Healthlocker.CareTeam.MessageController do
  alias Healthlocker.{Room}
  use Healthlocker.Web, :controller

  def show(conn, _params) do
    current_user = conn.assigns.current_user
    name = "carer-care-team:" <> Integer.to_string(current_user.id)
    room = Repo.get_by!(Room, name: name) |> Repo.preload([:users])

    conn
    |> assign(:room, room)
    |> render("show.html")
  end
end
