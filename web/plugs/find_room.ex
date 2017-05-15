defmodule Healthlocker.Plugs.FindRoom do
  @moduledoc """
  A small plug to find the room for a service user.
  """

  import Plug.Conn
  alias Healthlocker.Repo

  def find_room(conn, _options) do
    if conn.assigns[:current_user] do
      room = Repo.one Ecto.assoc(conn.assigns[:current_user], :rooms)

      conn
      |> assign(:room, room)
    else
      conn
      |> assign(:room, nil)
    end
  end
end
