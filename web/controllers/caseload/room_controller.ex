defmodule Healthlocker.Caseload.RoomController do
  alias Healthlocker.{EPJSUser, Message, ReadReceipt, Room, User}
  use Healthlocker.Web, :controller

  def show(conn, %{"id" => id, "user_id" => user_id}) do
    room = Repo.get((from r in Room, preload: [messages: :user]), id)
    messages = Repo.all from m in Message,
      where: m.room_id == ^room.id,
      order_by: [asc: :inserted_at, asc: :id],
      preload: [:user]

    user = Repo.get!(User, user_id)
    slam_user = find_slam_user(user)

    conn
    |> assign(:room, room)
    |> assign(:messages, messages)
    |> assign(:slam_user, slam_user)
    |> assign(:user, user)
    |> assign(:current_user_id, conn.assigns.current_user.id)
    |> render("show.html")
  end

  defp find_slam_user(user) do
    if user.slam_id do
      ReadOnlyRepo.one(from e in EPJSUser, where: e."Patient_ID" == ^user.slam_id)
    else
      nil
    end
  end
end
