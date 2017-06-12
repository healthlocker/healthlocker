defmodule Healthlocker.CareTeam.RoomController do
  alias Healthlocker.{Message, ClinicianRooms}
  use Healthlocker.Web, :controller

  def show(conn, %{"id" => id}) do
    room = Repo.get! assoc(conn.assigns.current_user, :rooms), id
    service_user = Healthlocker.Slam.ServiceUser.for(conn.assigns.current_user)
    clinicians_list = Healthlocker.Slam.CareTeam.for(service_user)
    clinician_rooms = Repo.all(from cr in ClinicianRooms, where: cr.room_id == ^id)

    messages = Repo.all from m in Message,
      where: m.room_id == ^room.id,
      order_by: [asc: :inserted_at, asc: :id],
      preload: [:user]

    case filter_clinicians(clinicians_list, clinician_rooms) do
      [] ->
        conn
        |> assign(:room, room)
        |> assign(:service_user, service_user)
        |> assign(:messages, messages)
        |> assign(:current_user_id, conn.assigns.current_user.id)
        |> render("show.html")
      clinicians ->
        rooms = filter_rooms(clinicians_list, clinician_rooms)
        get_single_clinician_and_room(clinicians, rooms)

        conn
        |> assign(:room, room)
        |> assign(:service_user, service_user)
        |> assign(:messages, messages)
        |> assign(:current_user_id, conn.assigns.current_user.id)
        |> render("show.html")
    end
  end

  def update(conn, %{"id" => clinician_room_id}) do
    clinician_room = Repo.get(ClinicianRooms, clinician_room_id)
    changeset = ClinicianRooms.changeset(clinigian_room, %{clinician_id: })
  end
end
