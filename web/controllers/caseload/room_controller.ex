defmodule Healthlocker.Caseload.RoomController do
  alias Healthlocker.{Message, Room}
  use Healthlocker.Web, :controller

  def show(conn, %{"id" => id, "user_id" => _user_id}) do
    room = Repo.get((from r in Room, preload: [messages: :user]), id)

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
