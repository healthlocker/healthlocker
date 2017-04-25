defmodule Healthlocker.CaseloadController do
  use Healthlocker.Web, :controller

  alias Healthlocker.{EPJSTeamMember, EPJSUser, ReadOnlyRepo}

  def index(conn, _params) do
    # only have one known clinician right now, so using this to get info
    # will need to grab the clinician_id from the token used to go from
    # epjs to HL
    clinician_id = 12
    all_patient_data = EPJSTeamMember
                  |> EPJSTeamMember.patient_ids(clinician_id)
                  |> ReadOnlyRepo.all
                  |> Enum.map(fn x ->
                    ReadOnlyRepo.all(from e in EPJSUser,
                    where: e."Patient_ID" == ^x) end)
                  |> Enum.concat()
    render(conn, "index.html", all_patients: all_patient_data)
  end
end
