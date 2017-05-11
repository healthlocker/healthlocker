defmodule Mix.Tasks.Healthlocker.Room.Create do
  alias Healthlocker.{ClinicianRooms, ReadOnlyRepo, Repo, Room, User, UserRoom}
  import Ecto.Query
  require Logger
  use Mix.Task

  @shortdoc "Create Rooms and their members."
  def run(_) do
    Logger.info "Starting..."

    Logger.info "Starting ecto..."
    [:postgrex, :ecto]
    |> Enum.each(&Application.ensure_all_started/1)

    Repo.start_link
    ReadOnlyRepo.start_link
    Logger.info "Finished starting ecto..."

    carers = Repo.all from u in User, join: c in assoc(u, :caring), preload: [caring: c]
    users   = Repo.all from u in User, where: not is_nil(u.slam_id)

    for carer <- carers do
      # Create the Room and add the carer as a member
      room = find_or_create(%Room{name: "carer-care-team:" <> Integer.to_string(carer.id)})
      add_to_room(room, carer)

      # Add the clinicians as members of the room
      [service_user | _] = carer.caring
      care_team = Healthlocker.Slam.CareTeam.for(service_user)

      add_clinicians_to_room(room, care_team)
    end

    for user <- users do
      room = find_or_create(%Room{name: "service-user-care-team:" <> Integer.to_string(user.id)})
      add_to_room(room, user)

      care_team = Healthlocker.Slam.CareTeam.for(user)
      add_clinicians_to_room(room, care_team)
    end
  end

  defp find_or_create(room) do
    query = from r in Room,
      where: r.name == ^room.name
    Repo.one(query) || Repo.insert!(room)
  end

  defp add_to_room(room, user) do
    changeset = UserRoom.changeset(%UserRoom{}, %{user_id: user.id, room_id: room.id})

    case Repo.insert(changeset) do
      {:ok, _assoc} -> Logger.info "UserRoom assoc created"
      {:error, _changest} -> Logger.error "Something went wrong"
    end
  end

  defp add_clinicians_to_room(room, care_team) do
    changesets = Enum.map(care_team, fn(clinician) ->
      ClinicianRooms.changeset(%ClinicianRooms{}, %{room_id: room.id, clinician_id: clinician.id})
    end)
    Enum.map(changesets, &Repo.insert/1)
  end
end
