defmodule Healthlocker.ReadOnlyRepo.Migrations.CreateEpjsUsers do
  use Ecto.Migration

  def change do
    create table(:epjs_users) do
      add :patient_id, :integer, null: false
      add :surname, :string
      add :forename, :string
      add :title, :string
      add :patient_name, :string
      add :trust_id, :string
      add :nhs_number, :string
      add :dob, :utc_datetime
      add :spell_number, :integer
      add :spell_start_date, :utc_datetime
      add :spell_end_date, :utc_datetime
    end
  end
end
