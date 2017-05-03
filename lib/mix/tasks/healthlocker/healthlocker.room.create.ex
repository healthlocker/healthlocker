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

    for carer <- carers do
      # Create the Room and add the carer as a member
      room = find_or_create(%Room{name: "carer-care-team:" <> Integer.to_string(carer.id)})
      changeset = UserRoom.changeset(%UserRoom{}, %{user_id: carer.id, room_id: room.id})

      case Repo.insert(changeset) do
        {:ok, _assoc} -> Logger.info "UserRoom assoc created"
        {:error, _changest} -> Logger.error "Something went wrong"
      end

      # Add the clinicians as members of the room
      [service_user | _] = carer.caring
      care_team = Healthlocker.Slam.CareTeam.for(service_user)
      Logger.info inspect(care_team)
      changesets = Enum.map(care_team, fn(clinician) ->
        ClinicianRooms.changeset(%ClinicianRooms{}, %{room_id: room.id, clinician_id: clinician.id})
      end)
      Enum.map(changesets, &Repo.insert/1)
    end
  end

  defp find_or_create(room) do
    query = from r in Room,
      where: r.name == ^room.name
    Repo.one(query) || Repo.insert!(room)
  end
end
