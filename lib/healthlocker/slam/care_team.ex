defmodule Healthlocker.Slam.CareTeam do
  alias Healthlocker.{EPJSTeamMember, ReadOnlyRepo}
  import Ecto.Query

  @moduledoc """
  For a given service user query EPJS for all the associated clinicians,
  these will form the user's care team.
  """
  def for(user) do
    query = from e in EPJSTeamMember,
      where: e."Patient_ID" == ^user.slam_id

    ReadOnlyRepo.all(query)
  end
end
