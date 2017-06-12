defmodule Healthlocker.CareTeam.RoomController do
  alias Healthlocker.{Message, ClinicianRooms}
  use Healthlocker.Web, :controller

  def show(conn, %{"id" => id}) do
    room = Repo.get! assoc(conn.assigns.current_user, :rooms), id
    service_user = Healthlocker.Slam.ServiceUser.for(conn.assigns.current_user)
    clinicians_list = Healthlocker.Slam.CareTeam.for(service_user)
    [clinician | _nothing] = clinicians_list
    clinician_room = Repo.get_by(ClinicianRooms, room_id: id)

    messages = Repo.all from m in Message,
      where: m.room_id == ^room.id,
      order_by: [asc: :inserted_at, asc: :id],
      preload: [:user]

    case clinician.id == clinician_room.clinician_id do
      true ->
        conn
        |> assign(:room, room)
        |> assign(:service_user, service_user)
        |> assign(:messages, messages)
        |> assign(:current_user_id, conn.assigns.current_user.id)
        |> render("show.html")
      _ ->
        IO.puts "where new update function will called"
    end
  end

  def update(conn, %{"id" => clinician_room_id}) do
    clinician_room = Repo.get(ClinicianRooms, clinician_room_id)
    changeset = ClinicianRooms.changeset(clinigian_room, %{clinician_id: })
  end
end
