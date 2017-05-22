defmodule Healthlocker.Slam.ConnectSlam do
  alias Ecto.Multi
  alias Healthlocker.{User, Room, UserRoom, Repo}

  def connect_su_and_create_rooms(user, params) do
    Multi.new
    |> Multi.update(:user, User.connect_slam(user, params))
    |> Multi.insert(:room, Room.changeset(%Room{}, %{
      name: "service-user-care-team:" <> Integer.to_string(user.id)
    }))
    |> Multi.run(:user_room, &add_su_to_room/1)
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
end
