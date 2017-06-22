defmodule Healthlocker.ReadOnlyRepo.Migrations.CreateEpjsUsers do
  use Ecto.Migration

  def change do
    create table(:mhlPatIndex, primary_key: false) do
      add :Patient_ID, :integer, primary_key: true
      add :Surname, :string
      add :Forename, :string
      add :Title, :string
      add :Patient_Name, :string
      add :Trust_ID, :string
      add :NHS_Number, :string
      add :DOB, :utc_datetime
      add :Spell_Number, :integer
      add :Spell_Start_Date, :utc_datetime
      add :Spell_End_Date, :utc_datetime
    end
  end
end
