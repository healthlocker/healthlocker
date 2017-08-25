defmodule Healthlocker.Slam.CareTeam do
  alias Healthlocker.{EPJSTeamMember, ReadOnlyRepo}
  import Ecto.Query

  @moduledoc """
  For a given service user query EPJS for all the associated clinicians,
  these will form the user's care team.
  """
  def for(user) do
    query = if Map.has_key?(user, :slam_id) do
      from e in EPJSTeamMember, where: e."Patient_ID" == ^user.slam_id
    else
      from e in EPJSTeamMember, where: e."Patient_ID" == ^user."Patient_ID"
    end

    ReadOnlyRepo.all(query)
  end
end
