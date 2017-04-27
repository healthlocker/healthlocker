defmodule Healthlocker.CareTeamView do
  use Healthlocker.Web, :view
  alias Healthlocker.Repo

  def service_user_for(carer) do
    carer = carer |> Repo.preload(:caring)
    [service_user | _] = carer.caring
    service_user
  end
end
