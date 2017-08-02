defmodule Healthlocker.Slam.Address do
  alias Healthlocker.{QueryEpjs}

  @moduledoc """
  For a given service user make api call to epjs_app for all the associated
  clinicians, these will form the user's care team.
  """
  def for(user) do
    QueryEpjs.query_epjs("http://localhost:4001/patient-address-details/address/get-address?service_user=", user)
  end
end
