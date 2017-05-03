defmodule Healthlocker.RoomController do
  use Healthlocker.Web, :controller
  alias Healthlocker.Room

  def show(conn, _params) do
    current_user = conn.assigns.current_user
    name = "carer-care-team:" <> Integer.to_string(current_user.id) 
    room = find_or_create(%Room{name: name})

    render conn, "show.html", room: room
  end

  def find_or_create(room) do
    query = from r in Room,
      where: r.name == ^room.name
    Repo.one(query) || Repo.insert!(room)
  end
end
