defmodule Healthlocker.RoomChannel do
  use Healthlocker.Web, :channel

  alias Healthlocker.{Message, CareTeam.MessageView, Room}

  def join("room:" <> room_id, _params, socket) do
    room = Repo.get!(Room, room_id)
    messages = Repo.all from m in Message,
      where: m.room_id == ^room.id,
      order_by: [asc: :inserted_at, asc: :id],
      preload: [:user]

    resp = %{messages: Phoenix.View.render_many(messages, MessageView, "message.json")}

    send(self, :after_join)
    {:ok, resp, assign(socket, :room, room)}
  end

  def handle_in("msg:new", params, socket) do
    changeset =
      socket.assigns.room
      |> build_assoc(:messages, user_id: socket.assigns.user_id)
      |> Message.changeset(params)

    case Repo.insert(changeset) do
      {:ok, message} ->
        broadcast_message(socket, message)
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  defp broadcast_message(socket, message) do
    message = Repo.preload(message, :user)
    rendered_message = Phoenix.View.render_one(message, MessageView, "message.json")
    broadcast!(socket, "msg:created", rendered_message)
  end
end
