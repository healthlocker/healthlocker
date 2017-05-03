defmodule Healthlocker.RoomController do
  use Healthlocker.Web, :controller
  alias Healthlocker.{EPJSClinician, Room}

  def show(conn, _params) do
    current_user = conn.assigns.current_user
    name = "carer-care-team:" <> Integer.to_string(current_user.id)
    room = Repo.get_by(Room, name: name) |> Repo.preload([:users])

    conn
    |> assign(:room, room)
    |> assign(:users, room.users)
    |> assign(:clinicians, clinicians(room))
    |> render("show.html")
  end

  defp clinicians(room) do
    query = from cr in Healthlocker.ClinicianRooms,
      where: cr.room_id == ^room.id,
      select: cr.clinician_id
    clinician_ids = Repo.all(query)

    query = from c in EPJSClinician,
      where: c.id in ^clinician_ids

    ReadOnlyRepo.all(query)
  end
end
