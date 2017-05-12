defmodule Healthlocker.Plugs.FindRoom do
  @moduledoc """
  A small plug to find the room for a service user.
  """

  import Plug.Conn
  alias Healthlocker.Repo

  def find_room(conn, _options) do
    current_user = conn.assigns[:current_user]
    room = Repo.one Ecto.assoc(current_user, :rooms)

    conn
    |> assign(:room, room)
  end
end
