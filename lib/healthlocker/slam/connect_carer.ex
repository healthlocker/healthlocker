defmodule Healthlocker.Slam.ConnectCarer do
  use Ecto.Schema
  alias Ecto.Multi
  alias Healthlocker.{User, Carer, Room, UserRoom, ClinicianRooms, Repo}

  def connect_carer_and_create_rooms(user, params, service_user) do
    Multi.new
    |> Multi.update(:user, User.name_changeset(user, %{first_name: params["first_name"], last_name: params["last_name"]}))
    |> Multi.insert(:carer, Carer.changeset(%Carer{carer_id: user.id, caring_id: service_user.id}))
    |> Multi.run(:room, &create_rooms/1)
    |> Multi.run(:carer_room, &add_carer_to_room/1)
    |> Multi.run(:clinician_room, &add_clinicians_to_room/1)
  end

  defp create_rooms(multi) do
    changeset = Room.changeset(%Room{}, %{name: "carer-care-team:" <> Integer.to_string(multi.user.id)})
    case Repo.insert(changeset) do
      {:ok, room} ->
        {:ok, room}
      {:error, _changeset} ->
        {:error, "Error in creating room"}
    end
  end

  defp add_carer_to_room(multi) do
    changeset = UserRoom.changeset(%UserRoom{}, %{user_id: multi.user.id, room_id: multi.room.id})
    case Repo.insert(changeset) do
      {:ok, carer_room} ->
        {:ok, carer_room}
      {:error, _changeset} ->
        {:error, "Error adding carer to room"}
    end
  end

  defp add_clinicians_to_room(multi) do
    carer = multi.user |> Repo.preload([:caring])
    [service_user|_] = carer.caring

    care_team = Healthlocker.Slam.CareTeam.for(service_user)
    clinicians =
      make_clinicians(care_team, multi.room.id)
      |> Enum.uniq_by(fn %{clinician_id: x} -> x end)
    case Repo.insert_all(ClinicianRooms, clinicians) do
      {n, nil} ->
        {:ok, n}
      _err ->
        {:error, "Error adding clinician to room"}
    end
  end


  defp make_clinicians(care_team, room_id) do
    care_team
    |> Enum.map(fn(clinician) ->
      %{
        room_id: room_id,
        clinician_id: clinician."Staff_ID",
        inserted_at: DateTime.utc_now(),
        updated_at: DateTime.utc_now()
      }
    end)
  end
end
