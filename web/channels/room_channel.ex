defmodule Healthlocker.RoomChannel do
  use Healthlocker.Web, :channel

  alias Healthlocker.Message

  def join("room:general", message, socket) do
    Process.flag(:trap_exit, true)
    send(self, {:after_join, message})
    {:ok, socket}
  end

  def handle_in(event, params, socket) do
    user = Repo.get(Healthlocker.User, socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("new:msg", msg, user, socket) do
    changeset = Message.changeset(%Message{
        body: msg["body"],
        user_id: user.id
      })
    case Repo.insert(changeset) do
      {:ok, _message} ->
        broadcast! socket, "new:msg", %{
          user: msg["user"],
          body: msg["body"]
        }
        {:reply, {:ok, %{msg: msg["body"]}}, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
