defmodule Healthlocker.Slam.ConnectSlam do
  alias Ecto.Multi
  alias Healthlocker.{User, Room, UserRoom, Repo, ClinicianRooms, Carer}
  import Ecto.Query

  def connect_su_and_create_rooms(user, params, carer) do
    Multi.new
    |> Multi.update(:user, User.connect_slam(user, params))
    |> Multi.insert(:room, Room.changeset(%Room{}, %{
      name: "service-user-care-team:" <> Integer.to_string(user.id)
    }))
    |> Multi.run(:carer, &check_carers_to_add(&1, user, params.slam_id, carer))
    |> Multi.run(:user_room, &add_su_to_room/1)
    |> Multi.run(:clinician_room, &add_clinicians_to_room/1)
  end

  defp check_carers_to_add(_multi, user, slam_id, carer) do
    if carer do
      query = from(c in Carer, where: c.slam_id == ^slam_id, update: [set: [caring_id: ^user.id]])
      case Repo.update_all(query, []) do
        {_n, nil} -> {:ok, "Carer updated successfully"}
      end
    else
      {:ok, "No carers to update"}
    end
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
