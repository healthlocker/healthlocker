defmodule Healthlocker.ReadOnlyRepo.Migrations.CreateEpjsClinicianUserJoin do
  use Ecto.Migration

  def change do
    create table(:epjs_team_members) do
      add :Patient_ID, :integer
      add :Staff_ID, :integer
    end
  end
end
