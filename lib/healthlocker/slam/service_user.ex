defmodule Healthlocker.Slam.ServiceUser do
  alias Healthlocker.Repo

  def for(carer) do
    if carer.slam_id do
      carer
    else
      carer = carer |> Repo.preload(:caring)
      [service_user | _] = carer.caring
      service_user
    end
  end
end
