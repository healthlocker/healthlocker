defmodule Healthlocker.Slam.ConnectSlam do
  alias Ecto.Multi
  alias Healthlocker.{User, Room}

  def connect_su_and_create_rooms(user, params) do
    Multi.new
    |> Multi.update(:user, User.connect_slam(user, params))
    |> Multi.insert(:room, Room.changeset(%Room{}, %{name: "service-user-care-team:" <> Integer.to_string(user.id)}))
  end
end
