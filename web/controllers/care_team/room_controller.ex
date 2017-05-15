defmodule Healthlocker.CareTeam.RoomController do
  alias Healthlocker.{Message, Room}
  use Healthlocker.Web, :controller

  def show(conn, %{"id" => id}) do
    room = Repo.get! assoc(conn.assigns.current_user, :rooms), id
    service_user = service_user_for(conn.assigns.current_user)

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

  defp service_user_for(carer) do
    if carer.slam_id do
      carer
    else
      carer = carer |> Repo.preload(:caring)
      [service_user | _] = carer.caring
      service_user
    end
  end
end
