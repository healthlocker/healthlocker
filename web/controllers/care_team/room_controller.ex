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

  # returns an empty list if the care team hasn't been added to
  # if it has changed it returns a list of clinicians to be added to clinician_rooms in DB
  def filter_clinicians(clinl, rooml) do
    Enum.reject(clinl, fn x ->
      Enum.any?(rooml, fn i ->
        x."Staff_ID" == i.clinician_id
      end)
    end)
  end

  # returns an empty list if no one has left the care team
  # if some has left the team the it returns a list of clinician_rooms to be deleted from DB
  def filter_rooms(clinl, rooml) do
    Enum.reject(rooml, fn x ->
      Enum.any?(clinl, fn i ->
        x.clinician_id == i."Staff_ID"
      end)
    end)
  end

  def add_clinicians_to_clinician_rooms(clinician_list, room_id) do
    clinician_list
    |> Enum.each(fn clinician ->
      Repo.insert!(%{clinician_id: clinician.id, room_id: room_id})
    end)
  end

  def delete_clinician_rooms(rooms) do
    rooms
    |> Enum.each(fn room ->
      Repo.delete!(room)
    end)
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
