defmodule Healthlocker.Slam.DisconnectSlam do
  alias Ecto.Multi
  alias Healthlocker.{User, Repo, UserRoom}

  def disconnect_su(user) do
    Multi.new
    |> Multi.update(:user, User.disconnect_changeset(user))
    |> Multi.run(:user_room, &delete_user_room/1)
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
end
