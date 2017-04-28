alias Healthlocker.{ReadOnlyRepo, EPJSClinician, EPJSTeamMember}

clinician = ReadOnlyRepo.insert!(%EPJSClinician{
  GP_Code: "yr68Dobil7yD40Ag",
  First_Name: "Trudy",
  Last_Name: "Braun"
})

ids_list = (1..182) |> Enum.take_random(20)
patient_ids = ids_list ++ [202]

defmodule Healthlocker.TeamData do
  def add_team_members(patient_list, clinician_id) do
    patient_list
    |> Enum.each(fn patient_id -> ReadOnlyRepo.insert!(%EPJSTeamMember{
      Patient_ID: patient_id,
      Staff_ID: clinician_id
    }) end)
  end
end

Healthlocker.TeamData.add_team_members(patient_ids, clinician.id)
