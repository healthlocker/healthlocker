defmodule Healthlocker.ReadOnlyRepo.Migrations.RenameTables do
  use Ecto.Migration

  def change do
    rename table(:epjs_users), to: table(:mhlPatIndex)
    rename table(:epjs_patient_address_details), to: table(:mhlPatientAddressDetails)
    rename table(:epjs_clinicians), to: table(:mhlGPDetails)
    rename table(:epjs_team_members), to: table(:mhlTeamMembers)
  end
end
