defmodule Healthlocker.Slam.DisconnectSlam do
  alias Ecto.Multi
  alias Healthlocker.{User}

  def disconnect_su(user) do
    Multi.new
    |> Multi.update(:user, User.disconnect_changeset(user))
  end
end
