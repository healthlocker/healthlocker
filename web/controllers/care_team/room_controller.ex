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

  def update_clinician_rooms(clinician, clinician_room) do
    changeset = ClinicianRooms.changeset(clinician_room, %{clinician_id: clinician.id})
    Repo.update!(changeset)
  end

  def filter_clinicians(clinl, rooml) do
    Enum.reject(clinl, fn x ->
      Enum.any?(rooml, fn i ->
        x.id == i.clinician_id
      end)
    end)
  end

  def filter_rooms(clinl, rooml) do
    Enum.reject(rooml, fn x ->
      Enum.any?(clinl, fn i ->
        x.clinician_id == i.id
      end)
    end)
  end

  def get_single_clinician_and_room([], _), do: :ok

  def get_single_clinician_and_room(clinicians, rooms) do
    [clinician | clinicians_tail] = clinicians
    [room | rooms_tail] = rooms

    update_clinician_rooms(clinician, room)
    get_single_clinician_and_room(clinicians_tail, rooms_tail)
  end
end
