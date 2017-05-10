defmodule Healthlocker.RoomChannel do
  use Healthlocker.Web, :channel

  alias Healthlocker.{Message, MessageView, Room}

  def join("room:" <> room_id, _params, socket) do
    room = Repo.get!(Room, room_id)
    messages = Repo.all from m in Message,
      where: m.room_id == ^room.id,
      order_by: [asc: :inserted_at, asc: :id],
      preload: [:user]

    send(self, :after_join)
    {:ok, nil, assign(socket, :room, room)}
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
    rendered_message = Phoenix.View.render_to_string(MessageView, "_message.html", message: message, current_user_id: nil)
    broadcast!(socket, "msg:created", %{template: rendered_message, id: message.id, message_user_id: socket.assigns.user_id})
  end
end
