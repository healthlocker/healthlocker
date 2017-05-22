defmodule Healthlocker.Slam.ConnectSlam do
  alias Ecto.Multi
  alias Healthlocker.{User, Room, UserRoom, Repo, ClinicianRooms}

  def connect_su_and_create_rooms(user, params) do
    Multi.new
    |> Multi.update(:user, User.connect_slam(user, params))
    |> Multi.insert(:room, Room.changeset(%Room{}, %{
      name: "service-user-care-team:" <> Integer.to_string(user.id)
    }))
    |> Multi.run(:user_room, &add_su_to_room/1)
    |> Multi.run(:clinician_room, &add_clinicians_to_room/1)
  end

  defp add_su_to_room(multi) do
    changeset = UserRoom.changeset(%UserRoom{}, %{
      user_id: multi.user.id,
      room_id: multi.room.id
    })
    case Repo.insert(changeset) do
      {:ok, user_room} ->
        {:ok, user_room}
      {:error, changeset} ->
        {:error, changeset, "Error adding user to room"}
    end
  end

  defp add_clinicians_to_room(multi) do
    care_team = Healthlocker.Slam.CareTeam.for(multi.user)
    clinicians = make_clinicians(care_team, multi.room.id)

    case Repo.insert_all(ClinicianRooms, clinicians) do
      {n, nil} ->
        {:ok, n}
      err ->
        {:error, "Error adding clinician to room"}
    end
  end

  defp make_clinicians(care_team, room_id) do
    care_team
    |> Enum.map(fn(clinician) ->
      %{
        room_id: room_id,
        clinician_id: clinician.id,
        inserted_at: DateTime.utc_now(),
        updated_at: DateTime.utc_now()
      }
    end)
  end
end
