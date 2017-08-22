defmodule Healthlocker.CareTeam.RoomController do
  alias Healthlocker.{Message, ClinicianRooms}
  use Healthlocker.Web, :controller

  def show(conn, %{"id" => id}) do
    room = Repo.get! assoc(conn.assigns.current_user, :rooms), id
    service_user = Healthlocker.Slam.ServiceUser.for(conn.assigns.current_user)
    care_team = Healthlocker.Slam.CareTeam.for(service_user)
    Repo.delete_all(from cr in ClinicianRooms, where: cr.room_id == ^id) # delete all from ClinicianRooms where id == room.id

    messages = Repo.all from m in Message,
      where: m.room_id == ^room.id,
      order_by: [asc: :inserted_at, asc: :id],
      preload: [:user]

    clinicians = make_clinician_rooms_entries(care_team, id)

    case Repo.insert_all(ClinicianRooms, clinicians) do
      {n, nil} ->
        return_conn(conn, room, service_user, messages)
      _err ->
        conn
        |> redirect(to: page_path(conn, :index))
    end
  end

  def make_clinician_rooms_entries(care_team, room_id) do
    care_team
    |> Enum.map(fn(clinician) ->
      %{
        room_id: room_id,
        clinician_id: clinician."Staff_ID",
        inserted_at: DateTime.utc_now(),
        updated_at: DateTime.utc_now()
      }
    end)
    |> Enum.uniq_by(fn %{clinician_id: x} -> x end)
  end

  def return_conn(conn, room, service_user, messages) do
    conn
    |> assign(:room, room)
    |> assign(:service_user, service_user)
    |> assign(:messages, messages)
    |> assign(:current_user_id, conn.assigns.current_user.id)
    |> render("show.html")
  end
end
