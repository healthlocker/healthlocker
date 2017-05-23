defmodule Healthlocker.Slam.DisconnectSlam do
  alias Ecto.Multi
  import Ecto.Query
  alias Healthlocker.{User, Repo, UserRoom, ClinicianRooms, Message}

  def disconnect_su(user) do
    Multi.new
    |> Multi.update(:user, User.disconnect_changeset(user))
    |> Multi.run(:user_room, &delete_user_room/1)
    |> Multi.run(:clinician_room, &delete_clinician_room/1)
    |> Multi.run(:messages, &delete_messages/1)
  end

  def delete_user_room(multi) do
    user_room = Repo.get_by!(UserRoom, user_id: multi.user.id)
    case Repo.delete(user_room) do
      {:ok, user_room} ->
        {:ok, user_room}
      {:error, changeset} ->
        {:error, changeset, "Error deleting user_room"}
    end
  end

  def delete_clinician_room(multi) do
    clinician_room = Repo.get_by!(ClinicianRooms, room_id: multi.user_room.room_id)
    case Repo.delete(clinician_room) do
      {:ok, clinician_room} ->
        {:ok, clinician_room}
      {:error, changeset} ->
        {:error, changeset, "Error deleting clinician_room"}
    end
  end

  def delete_messages(multi) do
    query = from m in Message, where: m.room_id == ^multi.user_room.room_id
    case Repo.delete_all(query) do
      {n, nil} ->
        {:ok, n}
      _err ->
        {:error, "Error deleting messages"}
    end
  end
end
