defmodule Healthlocker.CareTeam.RoomController do
  alias Healthlocker.{Message, ClinicianRooms}
  use Healthlocker.Web, :controller

  def show(conn, %{"id" => id}) do
    room = Repo.get! assoc(conn.assigns.current_user, :rooms), id
    service_user = Healthlocker.Slam.ServiceUser.for(conn.assigns.current_user)
    clinicians_list = Healthlocker.Slam.CareTeam.for(service_user)
    Repo.delete_all(from cr in ClinicianRooms, where: cr.room_id == ^id) # delete all from ClinicianRooms where id == room.id

    messages = Repo.all from m in Message,
      where: m.room_id == ^room.id,
      order_by: [asc: :inserted_at, asc: :id],
      preload: [:user]

    add_clinicians_to_clinician_rooms(clinicians_list, id)
    return_conn(conn, room, service_user, messages)
  end

  def add_clinicians_to_clinician_rooms(clinician_list, room_id) do
    clinician_list
    |> Enum.each(fn clinician ->
      Repo.insert!(%{clinician_id: clinician."Staff_ID", room_id: room_id})
    end)
  end

  def return_conn(conn, room, service_user, messages) do
    conn
    |> assign(:room, room)
    |> assign(:service_user, service_user)
    |> assign(:messages, messages)
    |> assign(:current_user_id, conn.assigns.current_user.id)
    |> Healthlocker.SetView.set_view("CareTeam.RoomView")
    |> render("show.html")
  end
end
