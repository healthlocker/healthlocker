defmodule Healthlocker.Slam.ConnectSlam do
  alias Ecto.Multi
  alias Healthlocker.{User}

  def connect_su_and_create_rooms(user, params) do
    Multi.new
    |> Multi.update(:user, User.connect_slam(user, params))
  end
end
