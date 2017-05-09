defmodule Healthlocker.CareTeam.MessageController do
  alias Healthlocker.{Message, Room}
  use Healthlocker.Web, :controller

  def show(conn, _params) do
    current_user = conn.assigns.current_user
    name = "carer-care-team:" <> Integer.to_string(current_user.id)
    room = Repo.get_by!(Room, name: name) |> Repo.preload([:users])

    messages = Repo.all from m in Message,
      where: m.room_id == ^room.id,
      order_by: [asc: :inserted_at, asc: :id],
      preload: [:user]

    conn
    |> assign(:room, room)
    |> assign(:messages, messages)
    |> assign(:current_user_id, conn.assigns.current_user.id)
    |> render("show.html")
  end
end
