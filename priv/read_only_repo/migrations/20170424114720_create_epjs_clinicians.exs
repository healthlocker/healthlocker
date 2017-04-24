defmodule Healthlocker.ReadOnlyRepo.Migrations.CreateEpjsClinicians do
  use Ecto.Migration

  def change do
    create table(:epjs_clinicians) do
      add :GP_Code, :string
      add :First_Name, :string
      add :Last_Name, :string
    end
  end
end
