defmodule Healthlocker.Slam.CareTeam do
  alias Healthlocker.{EPJSTeamMember, ReadOnlyRepo}
  import Ecto.Query

  @moduledoc """
  For a given service user make api call to epjs_app for all the associated
  clinicians, these will form the user's care team.
  """
  def for(user) do
    QueryEpjs.query_epjs("http://localhost:4001/care-team/for?service_user=", user)
  end
end
