defmodule Healthlocker.CareTeam.RoomController do
  alias Healthlocker.{Message, Room}
  use Healthlocker.Web, :controller

  def show(conn, %{"id" => id}) do
    room = Repo.get! assoc(conn.assigns.current_user, :rooms), id
    service_user = Healthlocker.Slam.ServiceUser.for(conn.assigns.current_user)

    messages = Repo.all from m in Message,
      where: m.room_id == ^room.id,
      order_by: [asc: :inserted_at, asc: :id],
      preload: [:user]

    conn
    |> assign(:room, room)
    |> assign(:service_user, service_user)
    |> assign(:messages, messages)
    |> assign(:current_user_id, conn.assigns.current_user.id)
    |> render("show.html")
  end
end
