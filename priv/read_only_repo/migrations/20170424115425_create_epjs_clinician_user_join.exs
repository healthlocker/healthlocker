defmodule Healthlocker.ReadOnlyRepo.Migrations.CreateEpjsClinicianUserJoin do
  use Ecto.Migration

  def change do
    create table(:epjs_team_members) do
      add :Patient_ID, references(:epjs_users)
      add :Staff_ID, references(:epjs_clinicians)
    end
  end
end
