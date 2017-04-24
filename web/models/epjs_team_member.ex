defmodule Healthlocker.EPJSTeamMembers do
  use Healthlocker.Web, :model

  schema "epjs_team_members" do
    belongs_to :Patient_ID, EPJSUser
    belongs_to :Staff_ID, EPJSClinician
  end
end
