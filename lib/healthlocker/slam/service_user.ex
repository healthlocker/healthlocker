defmodule Healthlocker.Slam.ServiceUser do
  alias Healthlocker.{Repo, ReadOnlyRepo, Carer, EPJSUser}
  alias Healthlocker.ReadOnlyRepo
  @moduledoc """
  If the User has a slam_id then they're already a service user. However, if the
  user is a carer, then their service user is the user they care for.
  """
  def for(user) do
    carer = user |> Repo.preload(:caring)
    cond do
      user.slam_id ->
        user
      carer.caring == [] ->
        carer_connection = Repo.get_by(Carer, carer_id: user.id)
        ReadOnlyRepo.get_by(EPJSUser, Patient_ID: carer_connection.slam_id)
      true ->
        [service_user | _] = carer.caring
        service_user
    end
  end
end
