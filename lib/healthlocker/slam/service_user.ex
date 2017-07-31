defmodule Healthlocker.Slam.ServiceUser do
  alias Healthlocker.Repo
  alias Healthlocker.{QueryEpjs}

  @moduledoc """
  If the User has a slam_id then they're already a service user. However, if the
  user is a carer, then their service user is the user they care for.
  """
  def for(carer) do
    if carer.slam_id do
      carer
    else
      carer = carer |> Repo.preload(:caring)
      [service_user | _] = carer.caring
      service_user
    end
  end

  def get_user(service_user) do
    QueryEpjs.query_epjs("http://localhost:4001/user/carer-connection/find-user?service_user=", service_user)
  end
end
