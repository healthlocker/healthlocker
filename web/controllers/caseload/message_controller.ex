defmodule Healthlocker.Caseload.MessageController do
  alias Healthlocker.{Message, User}
  use Healthlocker.Web, :controller

  def show(conn, %{"id" => carer_id, "caseload_id" => _service_user_id}) do
    carer = Repo.get!(User, carer_id) |> Repo.preload(:rooms)
    [room|_] = carer.rooms |> Repo.preload([messages: :user])

    messages = Repo.all from m in Message,
      where: m.room_id == ^room.id,
      order_by: [asc: :inserted_at, asc: :id],
      preload: [:user]

    conn
    |> assign(:room, room)
    |> assign(:messages, messages)
    |> assign(:current_user, conn.assigns.current_user)
    |> render("show.html")
  end
end
