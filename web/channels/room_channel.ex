defmodule Healthlocker.RoomChannel do
  use Healthlocker.Web, :channel

  alias Healthlocker.Message
  alias Healthlocker.MessageView

  def join("room:general", message, socket) do
    Process.flag(:trap_exit, true)
    send(self, {:after_join, message})
    messages = Repo.all(Message)
    resp = %{messages: Phoenix.View.render_many(messages, MessageView, "message.json")}
    {:ok, resp, socket}
  end

  def handle_in(event, params, socket) do
    user = Repo.get(Healthlocker.User, socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("new:msg", msg, user, socket) do
    changeset = Message.changeset(%Message{
        body: msg["body"],
        name: msg["name"],
        user_id: user.id
      })
    case Repo.insert(changeset) do
      {:ok, _message} ->
        broadcast! socket, "new:msg", %{
          name: msg["name"],
          body: msg["body"]
        }
        {:reply, {:ok, %{msg: msg["body"]}}, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
